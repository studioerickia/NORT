import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../blue/domain/entities/blue_message.dart';
import '../../../../blue/domain/personality/blue_rules_engine.dart';
import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_mood_mapper.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../blue/presentation/providers/blue_providers.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/hero_tags.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/period.dart';
import '../../../../shared/components/animations/animated_currency_text.dart';
import '../../../../shared/components/animations/breathing_scale.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/avatars/user_avatar.dart';
import '../../../../shared/components/buttons/nort_icon_button.dart';
import '../../../../shared/components/buttons/primary_button.dart';
import '../../../../shared/components/cards/goal_card.dart';
import '../../../../shared/components/common/pressable_scale.dart';
import '../../../../shared/components/empty_states/empty_error_offline_states.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/navigation/section_header.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';
import '../../../goals/domain/entities/goal.dart';
import '../../../goals/presentation/providers/goals_providers.dart';
import '../../../goals/presentation/widgets/goal_card_skeleton.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/providers/transactions_providers.dart';
import '../../../transactions/presentation/widgets/transaction_list_tile_skeleton.dart';
import '../providers/home_period_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;

    final blueEngine = ref.watch(blueRulesEngineProvider);

    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final firstName = profile?.displayNameOrFallback.split(' ').first ?? '';
    final initials = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'EM';

    final blueGreeting = blueEngine.greeting(
      now: DateTime.now(),
      firstName: firstName.isNotEmpty ? firstName : null,
    );

    final goalsAsync = ref.watch(goalsStreamProvider);
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final period = ref.watch(selectedSummaryPeriodProvider);

    final isLoading = goalsAsync.isLoading || transactionsAsync.isLoading;
    final hasError = goalsAsync.hasError || transactionsAsync.hasError;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: NortTopAppBar(
        title: 'NORT',
        onMenuTap: () => context.push(AppRoutes.settings),
        trailing: [
          NortIconButton(icon: Icons.notifications_outlined, onPressed: () {}),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: profile?.avatarUrl != null
                ? UserAvatar(
                    size: 28,
                    imageBuilder: (context) => Image.network(
                      profile!.avatarUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : UserAvatar(initials: initials, size: 28),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.xl,
            spacing.lg,
            spacing.xxxl,
          ),
          children: [
            FadeScaleIn(
              child: Column(
                children: [
                  Text(
                    blueGreeting.salutation,
                    textAlign: TextAlign.center,
                    style: context.textStyles.headlineMedium,
                  ),
                  SizedBox(height: spacing.xl),
                  PressableScale(
                    onTap: () => context.push(AppRoutes.chat),
                    child: BreathingScale(
                      child: const BlueAvatar(
                        state: BlueState.idle,
                        size: 128,
                        heroTag: NortHeroTags.blueAvatar,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.lg),
                  if (blueGreeting.reassurance.shouldDisplay)
                    Text(
                      blueGreeting.reassurance.text,
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  SizedBox(height: spacing.lg),
                  PressableScale(
                    onTap: () => context.push(AppRoutes.chat),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.lg,
                        vertical: spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.radii.pill),
                        border: Border.all(color: colors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 14, color: colors.brand.defaultColor),
                          SizedBox(width: spacing.xs),
                          Text('Fale com a Blue', style: context.textStyles.labelLarge),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.xxxl),

            if (isLoading) ...[
              const GoalCardSkeleton(),
              SizedBox(height: spacing.md),
              const TransactionRowSkeleton(),
              const TransactionRowSkeleton(),
            ] else if (hasError) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xl),
                child: ErrorState(
                  onAction: () {
                    ref.invalidate(goalsStreamProvider);
                    ref.invalidate(transactionsStreamProvider);
                  },
                ),
              ),
            ] else ...[
              _buildBalanceCard(
                context,
                blueEngine,
                goalsAsync.value!,
                transactionsAsync.value!,
                period,
              ),
              SizedBox(height: spacing.xxl),
              _buildGoalSection(context, blueEngine, goalsAsync.value!),
              SizedBox(height: spacing.xxl),
              _buildTransactionsSection(context, transactionsAsync.value!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    BlueRulesEngine blueEngine,
    List<Goal> goals,
    List<Transaction> transactions,
    PeriodSelection period,
  ) {
    final colors = context.colors;
    final spacing = context.spacing;

    double totalIncome = 0;
    double totalExpense = 0;
    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
      }
    }
    final balance = totalIncome - totalExpense;
    final balanceMessage = blueEngine.balanceObservation(balance: balance);

    double periodIncome = 0;
    double periodExpense = 0;
    for (final t in transactions) {
      if (!period.contains(t.occurredAt)) continue;
      if (t.type == TransactionType.income) {
        periodIncome += t.amount;
      } else {
        periodExpense += t.amount;
      }
    }

    final activeGoalsCount = goals.where((g) => g.status == GoalStatus.active).length;

    return FadeScaleIn(
      delay: const Duration(milliseconds: 80),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(spacing.xl),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: context.radii.xlRadius,
          boxShadow: context.shadows.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo disponível', style: context.textStyles.bodyMedium),
            SizedBox(height: spacing.xs),
            AnimatedCurrencyText(value: balance, style: context.numericStyles.large),
            if (balanceMessage.shouldDisplay) ...[
              SizedBox(height: spacing.sm),
              _BlueObservation(text: balanceMessage.text, mood: balanceMessage.suggestedMood),
            ],
            SizedBox(height: spacing.lg),
            Divider(height: 1, color: colors.border),
            SizedBox(height: spacing.md),
            Text(
              'Resumo · ${period.label}',
              style: context.textStyles.labelMedium?.copyWith(color: colors.textTertiary),
            ),
            SizedBox(height: spacing.sm),
            Row(
              children: [
                Expanded(
                  child: _InlineStat(
                    icon: Icons.arrow_downward,
                    label: 'Receitas: ${formatCurrencyBRL(periodIncome)}',
                    color: colors.positive.defaultColor,
                  ),
                ),
                Expanded(
                  child: _InlineStat(
                    icon: Icons.arrow_upward,
                    label: 'Despesas: ${formatCurrencyBRL(periodExpense)}',
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.sm),
            Row(
              children: [
                Expanded(
                  child: _InlineStat(
                    icon: Icons.check_circle_outline,
                    label: activeGoalsCount == 1 ? '1 meta ativa' : '$activeGoalsCount metas ativas',
                  ),
                ),
                Expanded(
                  child: _InlineStat(
                    icon: Icons.bolt_outlined,
                    label: 'Atualizado agora',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSection(BuildContext context, BlueRulesEngine blueEngine, List<Goal> goals) {
    final spacing = context.spacing;
    final activeGoals = goals.where((g) => g.status == GoalStatus.active).toList();
    final hasActiveGoal = activeGoals.isNotEmpty;

    return Section(
      header: SectionHeader(
        title: 'Sua meta principal',
        actionLabel: 'Ver tudo',
        onAction: () => context.go(AppRoutes.goals),
      ),
      child: AnimatedSwitcher(
        duration: context.motion.standard,
        switchInCurve: context.motion.enter,
        switchOutCurve: context.motion.exit,
        child: hasActiveGoal
            ? Builder(
                key: ValueKey('goal-${activeGoals.first.id}'),
                builder: (context) {
                  final goal = activeGoals.first;
                  final remaining = (goal.targetAmount - goal.currentAmount).clamp(0, double.infinity);
                  final observation = blueEngine.goalObservation(
                    progress: goal.progress,
                    remainingAmount: remaining.toDouble(),
                    isCompleted: false,
                    goalTitle: goal.title,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeScaleIn(
                        delay: const Duration(milliseconds: 140),
                        child: GoalCard(
                          title: goal.title,
                          currentAmountLabel: formatCurrencyBRL(goal.currentAmount),
                          targetAmountLabel: formatCurrencyBRL(goal.targetAmount),
                          progress: goal.progress,
                          dateLabel: goal.targetDate != null
                              ? 'Conclusão: ${formatMonthYear(goal.targetDate!)}'
                              : 'Sem data definida',
                          imageBuilder: goal.imageUrl != null
                              ? (context) => Image.network(goal.imageUrl!, fit: BoxFit.cover)
                              : null,
                          onTap: () => context.go(AppRoutes.goals),
                        ),
                      ),
                      if (observation.shouldDisplay) ...[
                        SizedBox(height: spacing.sm),
                        _BlueObservation(text: observation.text, mood: observation.suggestedMood),
                      ],
                    ],
                  );
                },
              )
            : _GoalsEmptyState(
                key: const ValueKey('goals-empty'),
                title: blueEngine.emptyStateMessage(BlueEmptyStateKind.noActiveGoals).text,
                onCreateTap: () => context.go(AppRoutes.goals),
              ),
      ),
    );
  }

  Widget _buildTransactionsSection(BuildContext context, List<Transaction> transactions) {
    final colors = context.colors;
    final spacing = context.spacing;
    final recent = transactions.take(3).toList();

    return Section(
      header: SectionHeader(
        title: 'Últimas transações',
        actionLabel: 'Ver tudo',
        onAction: () => context.go(AppRoutes.transactions),
      ),
      child: AnimatedSwitcher(
        duration: context.motion.standard,
        switchInCurve: context.motion.enter,
        switchOutCurve: context.motion.exit,
        child: recent.isEmpty
            ? EmptyState(
                key: const ValueKey('tx-empty'),
                icon: Icons.receipt_long_outlined,
                title: 'Nenhuma transação ainda',
                description: 'Suas transações vão aparecer aqui.',
                actionLabel: 'Ir para Transações',
                onAction: () => context.go(AppRoutes.transactions),
              )
            : PressableScale(
                key: ValueKey('tx-${recent.map((t) => t.id).join('-')}'),
                onTap: () => context.go(AppRoutes.transactions),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: context.radii.lgRadius,
                    boxShadow: context.shadows.low,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < recent.length; i++) ...[
                        _RecentTransactionRow(transaction: recent[i]),
                        if (i != recent.length - 1) const NortDivider(),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _GoalsEmptyState extends StatelessWidget {
  const _GoalsEmptyState({super.key, required this.title, required this.onCreateTap});

  final String title;
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BreathingScale(
              child: BlueAvatar(state: BlueState.idle, size: 48),
            ),
            SizedBox(height: spacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textStyles.titleLarge,
            ),
            SizedBox(height: spacing.sm),
            Text(
              'Crie sua primeira meta e deixe\na Blue acompanhar sua jornada.',
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(color: colors.textSecondary),
            ),
            SizedBox(height: spacing.lg),
            PrimaryButton(
              label: 'Criar minha primeira meta',
              fullWidth: false,
              onPressed: onCreateTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _BlueObservation extends StatelessWidget {
  const _BlueObservation({required this.text, required this.mood});

  final String text;
  final BlueMood mood;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
      child: Row(
        children: [
          BreathingScale(
            child: BlueAvatar(state: mapBlueMoodToState(mood), size: 18, showGlow: false),
          ),
          SizedBox(width: spacing.xs),
          Expanded(
            child: Text(
              text,
              style: context.textStyles.bodySmall?.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  const _InlineStat({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? colors.textSecondary),
        SizedBox(width: context.spacing.xs),
        Expanded(
          child: Text(
            label,
            style: context.textStyles.bodySmall?.copyWith(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RecentTransactionRow extends StatelessWidget {
  const _RecentTransactionRow({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final isIncome = transaction.type == TransactionType.income;
    final title = (transaction.description?.isNotEmpty ?? false)
        ? transaction.description!
        : 'Transação';
    final time = '${transaction.occurredAt.hour.toString().padLeft(2, '0')}:'
        '${transaction.occurredAt.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: colors.background, shape: BoxShape.circle),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              size: 14,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.titleSmall),
                Text(time, style: context.textStyles.bodySmall),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : ''}${formatCurrencyBRL(transaction.amount)}',
            style: context.numericStyles.small.copyWith(
              color: isIncome ? colors.positive.defaultColor : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
