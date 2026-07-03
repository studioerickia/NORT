import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Indicador de "Blue está digitando" — 3 pontos com pulso suave e
/// defasado. Único componente da Etapa 3 com `AnimationController`
/// contínuo (os demais são reativos a estado, não em loop).
///
/// Exemplo:
/// ```dart
/// TypingIndicator()
/// ```
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm + 2),
      decoration: BoxDecoration(
        color: colors.chatBubbleBlue,
        borderRadius: radii.lgRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Cada ponto tem uma defasagem de 1/3 do ciclo — cria a
              // sensação de "onda" sem qualquer bounce agressivo.
              final t = (_controller.value + (index * 0.33)) % 1.0;
              final opacity = 0.3 + 0.7 * (0.5 - (t - 0.5).abs()) * 2;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.xs / 2),
                child: Opacity(
                  opacity: opacity.clamp(0.3, 1.0),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colors.textTertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
