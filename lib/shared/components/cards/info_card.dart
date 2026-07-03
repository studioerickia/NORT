import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';
import 'base_card.dart';

/// Card informativo genérico — título, descrição curta e uma ação
/// opcional. Uso: "Insights da Blue", dicas, avisos suaves não
/// urgentes.
///
/// Exemplo:
/// ```dart
/// InfoCard(
///   title: 'Insights da Blue',
///   description: 'Sua vida está em harmonia.',
///   actionLabel: 'Explorar áreas',
///   onAction: () {},
/// )
/// ```
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.leading,
  });

  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[leading!, SizedBox(width: spacing.md)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textStyles.titleMedium),
                    SizedBox(height: spacing.xs),
                    Text(description, style: context.textStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: spacing.md),
            _InfoCardAction(label: actionLabel!, onTap: onAction!),
          ],
        ],
      ),
    );
  }
}

class _InfoCardAction extends StatelessWidget {
  const _InfoCardAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return PressableScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        decoration: BoxDecoration(
          color: colors.positive.defaultColor,
          borderRadius: radii.smRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: context.textStyles.titleMedium?.copyWith(
                color: colors.textOnBrand,
              ),
            ),
            SizedBox(width: spacing.xs),
            Icon(Icons.arrow_forward, size: 16, color: colors.textOnBrand),
          ],
        ),
      ),
    );
  }
}
