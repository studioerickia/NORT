import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Item de linha do tempo — ponto + linha conectora + conteúdo.
/// Pensado para `features/life_moments` (timeline de marcos de vida),
/// mas genérico o bastante para qualquer sequência cronológica.
///
/// `isLast` controla se a linha conectora aparece abaixo do ponto —
/// o último item da lista não precisa dela.
///
/// Exemplo:
/// ```dart
/// TimelineItem(
///   dateLabel: 'Mar 2026',
///   title: 'Mudança de cidade',
///   isLast: false,
/// )
/// ```
class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.dateLabel,
    required this.title,
    this.description,
    this.isLast = false,
  });

  final String dateLabel;
  final String title;
  final String? description;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(top: spacing.xs),
                decoration: BoxDecoration(
                  color: colors.brand.defaultColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1, color: colors.border),
                ),
            ],
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateLabel, style: context.textStyles.bodySmall),
                  SizedBox(height: spacing.xs / 2),
                  Text(title, style: context.textStyles.titleSmall),
                  if (description != null)
                    Text(description!, style: context.textStyles.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
