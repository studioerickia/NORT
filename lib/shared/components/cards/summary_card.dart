import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import 'base_card.dart';

/// Mini-card de resumo — usado em grade (ex.: os 4 cards de "Resumo
/// do dia" nas imagens de referência: Saldo, Disponível, Metas,
/// Status).
///
/// Deliberadamente minimalista: um ícone, um valor, um rótulo. Nunca
/// mais que isso — ver Calm UI, "um ponto focal por componente".
///
/// Exemplo:
/// ```dart
/// SummaryCard(icon: Icons.savings_outlined, value: 'R\$2.620', label: 'Saldo disponível')
/// ```
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return BaseCard(
      onTap: onTap,
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: colors.textSecondary),
          SizedBox(height: spacing.sm),
          Text(value, style: context.numericStyles.small),
          SizedBox(height: spacing.xs / 2),
          Text(
            label,
            style: context.textStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
