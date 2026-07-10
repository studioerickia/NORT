import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/buttons/nort_icon_button.dart';
import '../../../../shared/components/cards/goal_card.dart';
import '../../../../shared/components/common/pressable_scale.dart';
import '../../../../shared/components/empty_states/empty_error_offline_states.dart';
import '../../../../shared/components/navigation/tab_bar.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';
import '../../domain/entities/goal.dart';
import '../providers/goals_providers.dart';
import '../widgets/goal_card_skeleton.dart';
import '../widgets/goal_detail_sheet.dart';
import '../widgets/goal_form_sheet.dart';
import '../widgets/trash_sheet.dart';
import '../../../../shared/tokens/spacing/nort_spacing.dart';

const _tabStatuses = [GoalStatus.active, GoalStatus.completed, GoalStatus.archived];
const _tabLabels = ['Ativas', 'Concluídas', 'Sonhos'];

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  int _tabIndex = 0;

  void _openCreateForm({GoalStatus status = GoalStatus.active}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GoalFormSheet(initialStatus: status),
    );
  }

  void _openTrash() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const TrashSheet(),
    );
  }

  void _openDetail(Goal goal) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GoalDetailSheet(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final goalsAsync = ref.watch(goalsStreamProvider);
    final currentStatus = _tabStatuses[_tabIndex];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: NortTopAppBar(
        title: 'Metas',
        trailing: [
          NortIconButton(icon: Icons.delete_outline, onPressed: _openTrash),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.md,
            spacing.lg,
            spacing.xxxl,
          ),
          children: [
            Text('Suas metas', style: context.textStyles.headlineMedium),
            SizedBox(height: spacing.xs),
            Text(
              'Perspectiva, foco e consistência te levam longe.',
              style: context.textStyles.bodyLarge?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.lg),
            NortTabBar(
              tabs: _tabLabels,
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
            SizedBox(height: spacing.lg),
            goalsAsync.when(
              loading: () => Column(
                children: [
                  const GoalCardSkeleton(),
                  SizedBox(height: spacing.md),
                  const GoalCardSkeleton(),
                ],
              ),
              error: (error, _) => Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xl),
                child: ErrorState(
                  onAction: () => ref.invalidate(goalsStreamProvider),
                ),
              ),
              data: (allGoals) {
                final goals = allGoals.where((g) => g.status == currentStatus).toList();
                return _buildTabContent(context, goals, currentStatus, spacing);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    List<Goal> goals,
    GoalStatus status,
    NortSpacing spacing,
  ) {
    if (goals.isEmpty) {
      return _buildEmptyForStatus(status);
    }

    return Column(
      children: [
        for (int i = 0; i < goals.length; i++) ...[
          FadeScaleIn(
            delay: Duration(milliseconds: i * 60),
            child: GoalCard(
              title: goals[i].title,
              currentAmountLabel: formatCurrencyBRL(goals[i].currentAmount),
              targetAmountLabel: formatCurrencyBRL(goals[i].targetAmount),
              progress: goals[i].progress,
              dateLabel: goals[i].targetDate != null
                  ? 'Conclusão: ${formatMonthYear(goals[i].targetDate!)}'
                  : 'Sem data definida',
              imageBuilder: goals[i].imageUrl != null
                  ? (context) => Image.network(goals[i].imageUrl!, fit: BoxFit.cover)
                  : null,
              onTap: () => _openDetail(goals[i]),
            ),
          ),
          SizedBox(height: spacing.md),
        ],
        if (status == GoalStatus.active) _buildNewGoalCard(),
      ],
    );
  }

  Widget _buildEmptyForStatus(GoalStatus status) {
    switch (status) {
      case GoalStatus.active:
        return Column(
          children: [
            EmptyState(
              icon: Icons.flag_outlined,
              title: 'Nenhuma meta ativa',
              description: 'Crie sua primeira meta e comece a guardar.',
              actionLabel: 'Criar meta',
              onAction: () => _openCreateForm(status: GoalStatus.active),
            ),
          ],
        );
      case GoalStatus.completed:
        return const EmptyState(
          icon: Icons.emoji_events_outlined,
          title: 'Nenhuma meta concluída ainda',
          description: 'Quando você concluir uma meta, ela aparece aqui.',
        );
      case GoalStatus.archived:
        return EmptyState(
          icon: Icons.star_outline,
          title: 'Comece a sonhar',
          description: 'Guarde aqui aquilo que você ainda está planejando.',
          actionLabel: 'Adicionar sonho',
          onAction: () => _openCreateForm(status: GoalStatus.archived),
        );
    }
  }

  Widget _buildNewGoalCard() {
    return PressableScale(
      onTap: () => _openCreateForm(status: GoalStatus.active),
      child: Builder(
        builder: (context) {
          final colors = context.colors;
          final spacing = context.spacing;
          final radii = context.radii;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(spacing.lg),
            decoration: BoxDecoration(
              borderRadius: radii.lgRadius,
              border: Border.all(color: colors.border, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.border, width: 1.5),
                  ),
                  child: Icon(Icons.add, color: colors.textSecondary),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nova meta', style: context.textStyles.titleMedium),
                      Text(
                        'Comece a construir seu próximo sonho',
                        style: context.textStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}