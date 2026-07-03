import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Progresso circular — usado quando o espaço é compacto (ex.: dentro
/// de um `SummaryCard` pequeno) ou quando o formato circular comunica
/// melhor "ciclo completo" (ex.: meta anual).
///
/// Exemplo:
/// ```dart
/// NortCircularProgress(progress: 0.62, size: 48)
/// ```
class NortCircularProgress extends StatelessWidget {
  const NortCircularProgress({
    super.key,
    required this.progress,
    this.size = 48,
    this.strokeWidth = 4,
    this.color,
    this.centerLabel,
  });

  /// 0.0–1.0
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;

  /// Texto opcional no centro (ex.: "62%").
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fillColor = color ?? colors.positive.defaultColor;
    final clamped = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation(colors.border),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: clamped),
              duration: context.motion.standard,
              curve: context.motion.enter,
              builder: (context, value, _) => CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation(fillColor),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          if (centerLabel != null)
            Text(centerLabel!, style: context.textStyles.labelMedium),
        ],
      ),
    );
  }
}
