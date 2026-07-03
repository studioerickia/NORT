import 'package:flutter/material.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/cards/goal_card.dart';
import '../../../../shared/components/navigation/tab_bar.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

/// Tela de Metas — placeholder navegável, com abas (Ativas/Concluídas/
/// Sonhos) já montadas visualmente, mas sem troca de conteúdo real
/// por trás ainda (mesmo dado mockado nas 3 abas).
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
          padding: EdgeInsets.all(spacing.lg),
          children: [
            NortTabBar(
              tabs: const ['Ativas', 'Concluídas', 'Sonhos'],
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
            SizedBox(height: spacing.lg),
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
          ],
        ),
      ),
    );
  }
}
