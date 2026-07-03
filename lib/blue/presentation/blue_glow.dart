import 'package:flutter/material.dart';

import '../../core/extensions/nort_theme_context_x.dart';

/// Halo radial "oceano" atrás da Blue — único uso de gradiente
/// permitido no sistema (ver ADR seção 5 e `NortColors.oceanGradientStart/End`).
///
/// Placeholder desta etapa: gradiente estático com uma pulsação
/// muito sutil de escala. Quando Lottie/Rive entrarem (ver ADR seção
/// 9), este widget continua existindo como o "fundo" atrás da
/// animação real — a API não muda.
///
/// Exemplo:
/// ```dart
/// BlueGlow(size: 200, child: BlueAvatar(state: BlueState.idle))
/// ```
class BlueGlow extends StatefulWidget {
  const BlueGlow({super.key, required this.size, this.child});

  final double size;
  final Widget? child;

  @override
  State<BlueGlow> createState() => _BlueGlowState();
}

class _BlueGlowState extends State<BlueGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * 0.04);
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [colors.oceanGradientStart, colors.oceanGradientEnd],
          ),
        ),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
