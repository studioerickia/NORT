import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Wrapper de toque com feedback visual sutil (escala), substituindo o
/// ripple padrão do Material — alinhado à filosofia Calm UI: feedback
/// tátil discreto, nunca chamativo (ver `CALM_UI_GUIDELINES.md`).
///
/// Bloco de construção interno da Component Library — usado por
/// botões, cards tocáveis e tiles de navegação. Não deve ser
/// consumido diretamente por telas de feature.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.scaleFactor = 0.97,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final double scaleFactor;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.enabled && widget.onTap != null && mounted) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    return GestureDetector(
      onTap: widget.enabled ? widget.onTap : null,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scaleFactor : 1.0,
        duration: motion.micro,
        curve: motion.enter,
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          duration: motion.micro,
          child: widget.child,
        ),
      ),
    );
  }
}
