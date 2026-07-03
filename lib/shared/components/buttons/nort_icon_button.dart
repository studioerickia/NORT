import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Botão circular de ícone — usado em app bars, cards de ação rápida
/// e controles compactos (ex.: ícone de menu, sino de notificação).
///
/// Exemplo:
/// ```dart
/// NortIconButton(icon: Icons.notifications_outlined, onPressed: () {})
/// ```
class NortIconButton extends StatelessWidget {
  const NortIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  /// Diâmetro total do botão (não o tamanho do ícone).
  final double size;

  /// Quando `true`, usa fundo `surface` — útil sobre imagens/gradientes
  /// onde o ícone precisa de contraste garantido.
  final bool filled;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final iconColor = _enabled ? colors.textPrimary : colors.textTertiary;

    return PressableScale(
      enabled: _enabled,
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? colors.surface : Colors.transparent,
        ),
        child: Icon(icon, size: size * 0.5, color: iconColor),
      ),
    );
  }
}
