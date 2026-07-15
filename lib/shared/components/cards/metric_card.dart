import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import 'base_card.dart';

/// Card de métrica com tendência — ex.: "Gastos desta semana: R\$620
/// de R\$1.400 (44%)" com indicador de variação frente ao período
/// anterior.
///
/// Diferente de `SummaryCard` (compacto, em grade), `MetricCard` é
/// usado sozinho, ocupando a largura da tela, geralmente com um
/// gráfico ou barra de progresso abaixo (injetado via `chart`).
///
/// Exemplo:
/// ```dart
/// MetricCard(
///   title: 'Gastos desta semana',
///   value: 'R\$620 de R\$1.400',
///   deltaLabel: '44%',
///   deltaPositive: false,
/// )
/// ```
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.deltaLabel,
    this.deltaPositive = true,
    this.chart,
  });

  final String title;
  final String value;
  final String? deltaLabel;
  final bool deltaPositive;
  final Widget? chart;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    final deltaColor =
        deltaPositive ? colors.positive.defaultColor : colors.warning;

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: context.textStyles.titleSmall),
              ),
              if (deltaLabel != null)
                Text(
                  deltaLabel!,
                  style: context.textStyles.labelMedium?.copyWith(
                    color: deltaColor,
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(value, style: context.numericStyles.medium),
          if (chart != null) ...[
            SizedBox(height: spacing.md),
            chart!,
          ],
        ],
      ),
    );
  }
}
