import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Seletor de opção única — visual consistente com `NortTextInput`,
/// usando o `DropdownButton` nativo por baixo (evita reimplementar
/// overlay/posicionamento, que o Flutter já resolve bem) mas com
/// decoração 100% NORT por cima.
///
/// Exemplo:
/// ```dart
/// Dropdown<String>(
///   label: 'Categoria',
///   value: 'Alimentação',
///   items: const ['Alimentação', 'Transporte', 'Lazer'],
///   itemLabel: (v) => v,
///   onChanged: (v) {},
/// )
/// ```
class Dropdown<T> extends StatelessWidget {
  const Dropdown({
    super.key,
    this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
  });

  final String? label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: context.textStyles.labelLarge),
          SizedBox(height: spacing.xs),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: radii.smRadius,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: colors.textSecondary),
              style: context.textStyles.bodyLarge,
              dropdownColor: colors.surfaceElevated,
              borderRadius: radii.mdRadius,
              onChanged: onChanged,
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(itemLabel(item)),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
