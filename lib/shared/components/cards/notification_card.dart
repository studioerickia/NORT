import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Item da central de notificações (`features/notifications`).
///
/// Não usa `BaseCard` diretamente — notificações aparecem em lista
/// contínua (separadas por `NortDivider`), não em cards flutuantes
/// isolados; usar `BaseCard` aqui duplicaria sombra/radius numa
/// lista, o que viola Calm UI ("sombra é exceção").
///
/// Exemplo:
/// ```dart
/// NotificationCard(
///   title: 'Meta quase lá!',
///   description: 'Sua reserva de emergência está em 62%.',
///   timeLabel: '2h atrás',
///   unread: true,
///   onTap: () {},
/// )
/// ```
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.timeLabel,
    this.unread = false,
    this.leading,
    this.onTap,
  });

  final String title;
  final String description;
  final String timeLabel;
  final bool unread;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return PressableScale(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: spacing.md, horizontal: spacing.lg),
        color: unread
            ? colors.positiveSurface.withOpacity(0.4)
            : Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[leading!, SizedBox(width: spacing.md)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.titleSmall),
                  SizedBox(height: spacing.xs / 2),
                  Text(description, style: context.textStyles.bodySmall),
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeLabel, style: context.textStyles.bodySmall),
                if (unread) ...[
                  SizedBox(height: spacing.xs),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.brand.defaultColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
