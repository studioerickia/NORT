import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import 'base_card.dart';
import '../progress/progress_bar.dart';

/// Card de meta financeira — imagem, título, progresso e data de
/// conclusão (ver imagens de referência: "Viagem para o Japão",
/// "Entrada do apartamento").
///
/// `imageBuilder` é injetado em vez de receber uma `String url`
/// diretamente — a feature `goals` decide se a imagem vem de rede,
/// asset local ou placeholder; este componente não sabe a origem.
///
/// Exemplo:
/// ```dart
/// GoalCard(
///   title: 'Viagem para o Japão ✈️',
///   currentAmountLabel: 'R\$8.450',
///   targetAmountLabel: 'R\$15.000',
///   progress: 0.56,
///   dateLabel: 'Conclusão: Dez 2025',
///   imageBuilder: (context) => Image.asset('assets/images/japan.png', fit: BoxFit.cover),
/// )
/// ```
class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.title,
    required this.currentAmountLabel,
    required this.targetAmountLabel,
    required this.progress,
    required this.dateLabel,
    this.imageBuilder,
    this.onTap,
  });

  final String title;
  final String currentAmountLabel;
  final String targetAmountLabel;

  /// 0.0–1.0
  final double progress;
  final String dateLabel;
  final WidgetBuilder? imageBuilder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return BaseCard(
      onTap: onTap,
      padding: EdgeInsets.all(spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageBuilder != null) ...[
            ClipRRect(
              borderRadius: radii.mdRadius,
              child: SizedBox(
                width: 56,
                height: 56,
                child: imageBuilder!(context),
              ),
            ),
            SizedBox(width: spacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: spacing.sm),
                Row(
                  children: [
                    Text(currentAmountLabel,
                        style: context.numericStyles.small),
                    Text(
                      ' de $targetAmountLabel',
                      style: context.textStyles.bodyMedium,
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).round()}%',
                      style: context.textStyles.labelMedium?.copyWith(
                        color: colors.positive.defaultColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.sm),
                NortProgressBar(progress: progress),
                SizedBox(height: spacing.xs),
                Text(dateLabel, style: context.textStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
