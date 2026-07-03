import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Floating Action Button no estilo NORT — círculo central da
/// `BottomNavigation` (ver imagens de referência).
///
/// Cor: usa `colors.brand`, não `colors.positive`. Decisão deliberada:
/// a ação do FAB (abrir criação rápida) não é semanticamente
/// "positiva/progresso" — é uma ação primária de navegação. Nas
/// imagens de referência o círculo aparece em verde, mas seguir a cor
/// literal da imagem ali violaria a própria regra Calm UI que
/// definimos ("cor com função, nunca decoração") — então priorizamos
/// consistência semântica sobre réplica pixel-a-pixel.
///
/// Exemplo:
/// ```dart
/// NortFab(icon: Icons.add, onPressed: () {})
/// ```
class NortFab extends StatelessWidget {
  const NortFab({super.key, this.icon = Icons.add, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shadows = context.shadows;

    return PressableScale(
      enabled: onPressed != null,
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.brand.defaultColor,
          // Único botão do sistema que justifica sombra `medium` em
          // repouso — é um elemento genuinamente flutuante sobre a
          // bottom bar, não um card de conteúdo.
          boxShadow: shadows.medium,
        ),
        child: Icon(icon, color: colors.textOnBrand, size: 26),
      ),
    );
  }
}
