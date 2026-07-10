import 'package:flutter/material.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/animations/breathing_scale.dart';
import '../../../../shared/components/animations/fade_scale_in.dart';
import '../../../../shared/components/cards/info_card.dart';
import '../../../../shared/components/inputs/search_input.dart';
import '../../../../shared/components/layout/list_tile.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Transações'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.md,
            spacing.lg,
            spacing.xxxl,
          ),
          children: [
            FadeScaleIn(
              child: Text(
                'Aqui você acompanha, sem julgamento.',
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: spacing.lg),
            const SearchInput(placeholder: 'Buscar transação...'),
            SizedBox(height: spacing.xl),

            _DayGroup(
              label: 'Hoje',
              context_: 'um dia tranquilo',
              items: const [
                _TxItem(icon: Icons.restaurant_outlined, title: 'Almoço', time: '12:32', amount: 'R\$38,00'),
                _TxItem(icon: Icons.local_cafe_outlined, title: 'Café', time: '09:10', amount: 'R\$12,50'),
              ],
            ),

            SizedBox(height: spacing.lg),
            FadeScaleIn(
              delay: const Duration(milliseconds: 80),
              child: InfoCard(
                leading: const BreathingScale(
                  child: BlueAvatar(state: BlueState.idle, size: 32, showGlow: false),
                ),
                title: 'Observação da Blue',
                description: 'Essa semana seus gastos com alimentação estão 12% menores que a média. Nada pra ajustar agora.',
              ),
            ),
            SizedBox(height: spacing.lg),

            _DayGroup(
              label: 'Ontem',
              context_: 'nada fora do comum',
              items: const [
                _TxItem(icon: Icons.directions_car_outlined, title: 'Transporte', time: '18:45', amount: 'R\$22,00'),
                _TxItem(icon: Icons.shopping_bag_outlined, title: 'Farmácia', time: '15:20', amount: 'R\$54,90'),
                _TxItem(icon: Icons.movie_outlined, title: 'Cinema', time: '20:00', amount: 'R\$45,00'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TxItem {
  const _TxItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.amount,
  });

  final IconData icon;
  final String title;
  final String time;
  final String amount;
}

class _DayGroup extends StatelessWidget {
  const _DayGroup({
    required this.label,
    required this.context_,
    required this.items,
  });

  final String label;
  final String context_;
  final List<_TxItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Section(
      header: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(label, style: context.textStyles.titleMedium),
          SizedBox(width: spacing.xs),
          Text(
            '· $context_',
            style: context.textStyles.bodySmall?.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            NortListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(items[i].icon, size: 18, color: colors.textSecondary),
              ),
              title: items[i].title,
              subtitle: items[i].time,
              trailing: Text(
                items[i].amount,
                style: context.numericStyles.small,
              ),
            ),
            if (i != items.length - 1) const NortDivider(),
          ],
        ],
      ),
    );
  }
}