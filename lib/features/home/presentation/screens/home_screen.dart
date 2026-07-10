import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/hero_tags.dart';
import '../../../../shared/components/animations/breathing_scale.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/avatars/user_avatar.dart';
import '../../../../shared/components/buttons/nort_icon_button.dart';
import '../../../../shared/components/cards/goal_card.dart';
import '../../../../shared/components/common/pressable_scale.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/navigation/section_header.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';
import '../../../../shared/components/progress/progress_bar.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;

    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final firstName = profile?.displayNameOrFallback.split(' ').first ?? '';
    final greeting = firstName.isNotEmpty ? 'Bom dia, $firstName' : 'Bom dia';
    final initials = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'EM';

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
                    greeting,
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
                  Text(
                    'Seu dia está tranquilo.\nNada pra se preocupar agora.',
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

            FadeScaleIn(
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
                    Text(
                      'Você pode gastar até',
                      style: context.textStyles.bodyMedium,
                    ),
                    SizedBox(height: spacing.xs),
                    Text('R\$84', style: context.numericStyles.large),
                    SizedBox(height: spacing.md),
                    const NortProgressBar(progress: 0.4),
                    SizedBox(height: spacing.xs),
                    Row(
                      children: [
                        Text('de R\$210 disponíveis', style: context.textStyles.bodySmall),
                        const Spacer(),
                        Text(
                          '40%',
                          style: context.textStyles.labelMedium?.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.lg),
                    Divider(height: 1, color: colors.border),
                    SizedBox(height: spacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _InlineStat(
                            icon: Icons.savings_outlined,
                            label: 'R\$2.620 de saldo',
                          ),
                        ),
                        Expanded(
                          child: _InlineStat(
                            icon: Icons.check_circle_outline,
                            label: '2 metas ativas',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: spacing.xxl),

            Section(
              header: SectionHeader(
                title: 'Suas metas',
                actionLabel: 'Ver tudo',
                onAction: () => context.go(AppRoutes.goals),
              ),
              child: FadeScaleIn(
                delay: const Duration(milliseconds: 140),
                child: GoalCard(
                  title: 'Viagem para o Japão',
                  currentAmountLabel: 'R\$8.450',
                  targetAmountLabel: 'R\$15.000',
                  progress: 0.56,
                  dateLabel: 'Conclusão: Dez 2025',
                  imageBuilder: (context) => Container(
                    color: colors.brand.disabled,
                    alignment: Alignment.center,
                    child: Icon(Icons.flight_takeoff, color: colors.brand.defaultColor, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  const _InlineStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textSecondary),
        SizedBox(width: context.spacing.xs),
        Expanded(
          child: Text(
            label,
            style: context.textStyles.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}