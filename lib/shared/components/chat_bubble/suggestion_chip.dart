import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Pílula de sugestão de pergunta rápida — "Quais são minhas
/// prioridades?", "Como estou esta semana?" (ver imagens de
/// referência).
///
/// Exemplo:
/// ```dart
/// SuggestionChip(label: 'Quais são minhas prioridades?', onTap: () {})
/// ```
class SuggestionChip extends StatelessWidget {
  const SuggestionChip({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radii.pill),
          border: Border.all(color: colors.border),
        ),
        child: Text(label, style: context.textStyles.labelLarge),
      ),
    );
  }
}
