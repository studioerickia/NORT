import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Linha rótulo-valor — a unidade mais simples de exibir um dado (ex.:
/// dentro de um `ModalCard` de detalhe: "Categoria: Alimentação").
///
/// Exemplo:
/// ```dart
/// StatisticRow(label: 'Categoria', value: 'Alimentação')
/// ```
class StatisticRow extends StatelessWidget {
  const StatisticRow({
    super.key,
    required this.label,
    required this.value,
    this.valueIsNumeric = false,
  });

  final String label;
  final String value;

  /// Quando `true`, usa `numericStyles.small` para o valor (tabular).
  final bool valueIsNumeric;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.textStyles.bodyMedium),
          Text(
            value,
            style: valueIsNumeric
                ? context.numericStyles.small
                : context.textStyles.titleSmall,
          ),
        ],
      ),
    );
  }
}
