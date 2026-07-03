import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Botão de texto — ação de menor hierarquia, sem contorno nem
/// preenchimento (ex.: "Pular", "Já tenho uma conta").
///
/// Nomeado `NortTextButton` para não colidir com o `TextButton`
/// nativo do Material.
///
/// Exemplo:
/// ```dart
/// NortTextButton(label: 'Pular', onPressed: () {})
/// ```
class NortTextButton extends StatelessWidget {
  const NortTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    final textColor = _enabled ? colors.brand.defaultColor : colors.textTertiary;

    return PressableScale(
      enabled: _enabled,
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              SizedBox(width: spacing.xs),
            ],
            Text(
              label,
              style: context.textStyles.titleSmall?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
