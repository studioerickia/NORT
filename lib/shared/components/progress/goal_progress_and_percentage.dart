import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import 'progress_bar.dart';

/// Composição de progresso de meta — barra linear + rótulo de valor
/// atual/alvo + percentual, empacotados juntos para reuso fora de
/// `GoalCard` (ex.: dentro de uma tela de detalhe de meta).
///
/// Exemplo:
/// ```dart
/// GoalProgress(
///   currentAmountLabel: 'R\$8.450',
///   targetAmountLabel: 'R\$15.000',
///   progress: 0.56,
/// )
/// ```
class GoalProgress extends StatelessWidget {
  const GoalProgress({
    super.key,
    required this.currentAmountLabel,
    required this.targetAmountLabel,
    required this.progress,
  });

  final String currentAmountLabel;
  final String targetAmountLabel;

  /// 0.0–1.0
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(currentAmountLabel, style: context.numericStyles.small),
            Text(' de $targetAmountLabel',
                style: context.textStyles.bodyMedium),
            const Spacer(),
            Text(
              '${(progress.clamp(0.0, 1.0) * 100).round()}%',
              style: context.textStyles.labelMedium?.copyWith(
                color: colors.positive.defaultColor,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.sm),
        NortProgressBar(progress: progress),
      ],
    );
  }
}

/// Badge textual de percentual — usado quando só o número importa,
/// sem barra visual (ex.: dentro de uma linha de lista compacta).
///
/// Exemplo:
/// ```dart
/// PercentageBadge(value: 0.44, positive: false)
/// ```
class PercentageBadge extends StatelessWidget {
  const PercentageBadge({super.key, required this.value, this.positive = true});

  /// 0.0–1.0
  final double value;

  /// Controla a cor semântica — `true` usa `positive`, `false` usa
  /// `warning`. Não há terceiro estado aqui de propósito: um
  /// percentual é ou está indo bem, ou merece atenção.
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;
    final color = positive ? colors.positive.defaultColor : colors.warning;
    final background =
        positive ? colors.positiveSurface : colors.warningSurface;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: spacing.sm, vertical: spacing.xs / 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radii.pill),
      ),
      child: Text(
        '${(value.clamp(0.0, 1.0) * 100).round()}%',
        style: context.textStyles.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
