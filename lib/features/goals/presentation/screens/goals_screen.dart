import 'package:flutter/material.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/cards/goal_card.dart';
import '../../../../shared/components/common/pressable_scale.dart';
import '../../../../shared/components/empty_states/empty_error_offline_states.dart';
import '../../../../shared/components/navigation/tab_bar.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';
import '../../../../shared/tokens/spacing/nort_spacing.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Metas'),
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
              tabs: const ['Ativas', 'Concluídas', 'Sonhos'],
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
            SizedBox(height: spacing.lg),
            ..._contentForTab(_tabIndex, spacing),
          ],
        ),
      ),
    );
  }

  List<Widget> _contentForTab(int index, NortSpacing spacing) {
    switch (index) {
      case 0: // Ativas
        return [
          GoalCard(
            title: 'Viagem para o Japão',
            currentAmountLabel: 'R\$8.450',
            targetAmountLabel: 'R\$15.000',
            progress: 0.56,
            dateLabel: 'Conclusão: Dez 2025',
          ),
          SizedBox(height: spacing.md),
          GoalCard(
            title: 'Entrada do apartamento',
            currentAmountLabel: 'R\$24.600',
            targetAmountLabel: 'R\$60.000',
            progress: 0.41,
            dateLabel: 'Conclusão: Mai 2026',
          ),
          SizedBox(height: spacing.md),
          GoalCard(
            title: 'Reserva de emergência',
            currentAmountLabel: 'R\$12.300',
            targetAmountLabel: 'R\$20.000',
            progress: 0.62,
            dateLabel: 'Conclusão: Jun 2026',
          ),
          SizedBox(height: spacing.md),
          _NewGoalCard(),
        ];
      case 1: // Concluídas
        return const [
          SizedBox(height: 32),
          EmptyState(
            icon: Icons.emoji_events_outlined,
            title: 'Nenhuma meta concluída ainda',
            description: 'Quando você concluir uma meta, ela aparece aqui.',
          ),
        ];
      case 2: // Sonhos
        return const [
          SizedBox(height: 32),
          EmptyState(
            icon: Icons.star_outline,
            title: 'Comece a sonhar',
            description: 'Guarde aqui aquilo que você ainda está planejando.',
            actionLabel: 'Adicionar sonho',
          ),
        ];
      default:
        return const [];
    }
  }
}

class _NewGoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return PressableScale(
      onTap: () {},
      child: Container(
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
      ),
    );
  }
}