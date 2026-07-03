import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Campo de busca — pílula arredondada, ícone de lupa fixo, sem
/// label (uso inline, ex.: busca em lista de transações).
///
/// Composição própria (não reaproveita `NortTextInput`) porque o
/// formato visual é bem diferente (pill vs. campo retangular com
/// label) — forçar herança aqui criaria mais parâmetros condicionais
/// do que reuso real.
///
/// Exemplo:
/// ```dart
/// SearchInput(placeholder: 'Buscar transação...', onChanged: (v) {})
/// ```
class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    this.placeholder = 'Buscar...',
    this.controller,
    this.onChanged,
  });

  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.pill),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: context.textStyles.bodyLarge,
        cursorColor: colors.brand.defaultColor,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: context.textStyles.bodyLarge?.copyWith(color: colors.textTertiary),
          prefixIcon: Icon(Icons.search, size: 20, color: colors.textSecondary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm + 2,
          ),
        ),
      ),
    );
  }
}
