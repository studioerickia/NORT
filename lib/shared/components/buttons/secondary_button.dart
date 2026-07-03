import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Botão de ação secundária — usado ao lado de um [PrimaryButton]
/// quando há uma segunda ação de menor peso (ex.: "Cancelar",
/// "Ver detalhes"). Sem preenchimento — só contorno sutil, para não
/// competir visualmente com a ação primária.
///
/// Exemplo:
/// ```dart
/// SecondaryButton(label: 'Ver detalhes', onPressed: () {})
/// ```
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    final borderColor = _enabled ? colors.border : colors.border.withOpacity(0.5);
    final textColor = _enabled ? colors.textPrimary : colors.textTertiary;

    return PressableScale(
      enabled: _enabled,
      onTap: onPressed,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.xl,
          vertical: spacing.md + 2,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radii.smRadius,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: textColor),
              SizedBox(width: spacing.sm),
            ],
            Text(
              label,
              style: context.textStyles.titleMedium?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
