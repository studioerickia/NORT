import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Switch (toggle) do NORT — usa `colors.positive`, não `colors.brand`:
/// um switch "ligado" comunica um estado ativo/positivo, não uma ação
/// de marca.
///
/// Exemplo:
/// ```dart
/// NortSwitch(value: true, onChanged: (v) {})
/// ```
class NortSwitch extends StatelessWidget {
  const NortSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: colors.textOnBrand,
      activeTrackColor: colors.positive.defaultColor,
      inactiveThumbColor: colors.textOnBrand,
      inactiveTrackColor: colors.border,
      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
    );
  }
}

/// Checkbox do NORT — cantos arredondados (nunca quadrado vivo),
/// consistente com `radii.sm` do resto do sistema.
///
/// Exemplo:
/// ```dart
/// NortCheckbox(value: false, onChanged: (v) {})
/// ```
class NortCheckbox extends StatelessWidget {
  const NortCheckbox({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: colors.brand.defaultColor,
      checkColor: colors.textOnBrand,
      side: BorderSide(color: colors.border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}

/// Radio button do NORT — usado em grupos de escolha única visíveis
/// simultaneamente (diferente de `Dropdown`, que esconde as opções).
///
/// Exemplo:
/// ```dart
/// NortRadio<String>(value: 'a', groupValue: selected, onChanged: (v) {})
/// ```
class NortRadio<T> extends StatelessWidget {
  const NortRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: colors.brand.defaultColor,
    );
  }
}
