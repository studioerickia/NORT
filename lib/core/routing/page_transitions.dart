import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/tokens/motion/nort_motion.dart';

/// Constrói uma `Page` com a transição padrão do NORT — fade + scale
/// sutil, nunca slide agressivo (ADR seção 8, mesma regra aplicada em
/// `FadeScaleIn` na Component Library).
///
/// Usado em todo `GoRoute`/`ShellRoute` no lugar do `MaterialPage`
/// default, para que a navegação inteira do app respeite o Motion
/// System — não só componentes isolados.
CustomTransitionPage<void> buildNortPage({
  required LocalKey key,
  required Widget child,
}) {
  const motion = NortMotion();

  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: motion.screen,
    reverseTransitionDuration: motion.screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: motion.enter);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}
