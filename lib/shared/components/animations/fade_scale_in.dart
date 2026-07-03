import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Wrapper de entrada padrão para cards e elementos aparecendo —
/// fade + scale sutil (ADR seção 8: "nunca slide agressivo").
///
/// Único wrapper de motion desta etapa; outros (`HeroWrap`,
/// `BlurTransition`) ficam para quando a Navegação (Etapa 5) e os
/// Dialogs precisarem deles de fato, para não criar abstração sem uso
/// real ainda.
///
/// Exemplo:
/// ```dart
/// FadeScaleIn(child: GoalCard(...))
/// ```
class FadeScaleIn extends StatefulWidget {
  const FadeScaleIn({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<FadeScaleIn> createState() => _FadeScaleInState();
}

class _FadeScaleInState extends State<FadeScaleIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    // Duração inicial literal — igual ao valor padrão de
    // `NortMotion.standard`. Não podemos ler `context.motion` aqui:
    // `Theme.of(context)` não está disponível em `initState()`, só a
    // partir de `didChangeDependencies()`/`build()`.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = context.motion.standard;
    if (!_started) {
      _started = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: context.motion.enter);
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
        child: widget.child,
      ),
    );
  }
}
