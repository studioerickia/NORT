import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Botão de ação primária — uma única ação principal por tela ou
/// seção (ex.: "Continuar", "Confirmar").
///
/// Estados: normal, pressed (escala sutil), disabled (opacidade +
/// cor neutralizada), loading (spinner substitui o label).
///
/// Exemplo:
/// ```dart
/// PrimaryButton(label: 'Continuar', onPressed: () {})
/// PrimaryButton(label: 'Salvando...', loading: true, onPressed: null)
/// ```
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    final background =
        _enabled ? colors.brand.defaultColor : colors.brand.disabled;

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
          color: background,
          borderRadius: radii.smRadius,
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(colors.textOnBrand),
                ),
              ),
              SizedBox(width: spacing.sm),
            ] else if (icon != null) ...[
              Icon(icon, size: 18, color: colors.textOnBrand),
              SizedBox(width: spacing.sm),
            ],
            Text(
              label,
              style: context.textStyles.titleMedium?.copyWith(
                color: colors.textOnBrand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
