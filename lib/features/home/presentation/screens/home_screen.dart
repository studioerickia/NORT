import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/hero_tags.dart';
import '../../../../shared/components/avatars/user_avatar.dart';
import '../../../../shared/components/buttons/nort_icon_button.dart';
import '../../../../shared/components/cards/goal_card.dart';
import '../../../../shared/components/cards/summary_card.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/navigation/section_header.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

/// Tela Home — placeholder navegável, montado com componentes reais
/// da Component Library e dados mockados. Nenhum provider/usecase
/// real ainda (ver ADR seção 17).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

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
            child: const UserAvatar(initials: 'EM', size: 28),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Section(
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.chat),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: BlueAvatar(
                    state: BlueState.idle,
                    size: 56,
                    showGlow: false,
                    heroTag: NortHeroTags.blueAvatar,
                  ),
                ),
              ),
            ),
            Section(
              header: SectionHeader(title: 'Resumo do dia'),
              child: Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.savings_outlined,
                      value: 'R\$2.620',
                      label: 'Saldo disponível',
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: SummaryCard(
                      icon: Icons.check_circle_outline,
                      value: '2',
                      label: 'Metas ativas',
                    ),
                  ),
                ],
              ),
            ),
            Section(
              header: SectionHeader(
                title: 'Suas metas',
                actionLabel: 'Ver tudo',
                onAction: () => context.go(AppRoutes.goals),
              ),
              child: GoalCard(
                title: 'Viagem para o Japão',
                currentAmountLabel: 'R\$8.450',
                targetAmountLabel: 'R\$15.000',
                progress: 0.56,
                dateLabel: 'Conclusão: Dez 2025',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
