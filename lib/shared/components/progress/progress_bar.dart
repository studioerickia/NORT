import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Barra de progresso linear — usada em `GoalCard`, `GoalProgress` e
/// em qualquer indicador de "quanto falta".
///
/// Sem cantos retos (Calm UI): trilho e preenchimento sempre com
/// `radii.pill`. Cor de preenchimento configurável — default
/// `colors.positive`, mas aceita override (ex.: `colors.warning`
/// quando o progresso indica atenção, não conquista).
///
/// Exemplo:
/// ```dart
/// NortProgressBar(progress: 0.56)
/// ```
class NortProgressBar extends StatelessWidget {
  const NortProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.height = 6,
  });

  /// 0.0–1.0. Valores fora do intervalo são recortados (`clamp`).
  final double progress;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final motion = context.motion;
    final clamped = progress.clamp(0.0, 1.0);
    final fillColor = color ?? colors.positive.defaultColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radii.pill),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                height: height,
                width: constraints.maxWidth,
                color: colors.border,
              ),
              AnimatedContainer(
                duration: motion.standard,
                curve: motion.enter,
                height: height,
                width: constraints.maxWidth * clamped,
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(radii.pill),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
