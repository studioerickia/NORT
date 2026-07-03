import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Tag — rótulo curto, sem interação, usado para categorizar (ex.:
/// categoria de uma transação). Diferente de `Badge`, não carrega
/// significado semântico de estado — é só um rótulo.
///
/// Exemplo:
/// ```dart
/// Tag(label: 'Alimentação')
/// ```
class Tag extends StatelessWidget {
  const Tag({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs / 2),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.sm),
      ),
      child: Text(label, style: context.textStyles.labelSmall),
    );
  }
}

/// Pill — mesma função de `Tag`, mas totalmente arredondada e com
/// borda; usada quando o fundo por trás não garante contraste
/// suficiente para uma tag sem borda (ex.: sobre uma foto).
///
/// Exemplo:
/// ```dart
/// Pill(label: 'Concluída')
/// ```
class Pill extends StatelessWidget {
  const Pill({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radii.pill),
        border: Border.all(color: colors.border),
      ),
      child: Text(label, style: context.textStyles.labelMedium),
    );
  }
}

/// Chip — como `Pill`, mas tocável e com opção de remoção (`onDelete`),
/// usado em seletores multi-escolha (ex.: filtros de transação).
///
/// Exemplo:
/// ```dart
/// NortChip(label: 'Últimos 7 dias', selected: true, onTap: () {})
/// ```
class NortChip extends StatelessWidget {
  const NortChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.onDelete,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    final background = selected ? colors.brand.disabled : colors.surface;
    final textColor = selected ? colors.brand.defaultColor : colors.textPrimary;

    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.xs),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: context.textStyles.labelMedium?.copyWith(color: textColor)),
            if (onDelete != null) ...[
              SizedBox(width: spacing.xs),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.close, size: 14, color: textColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
