import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Item de lista genérico — leading opcional, título, subtítulo,
/// trailing opcional. Mais neutro que `NavigationTile` (que sempre
/// tem ícone + chevron); use `NortListTile` quando o conteúdo variar
/// mais (ex.: lista de transações, onde o trailing é um valor
/// monetário, não uma seta).
///
/// Exemplo:
/// ```dart
/// NortListTile(
///   title: 'Supermercado',
///   subtitle: 'Hoje, 14:32',
///   trailing: Text('-R\$120,00'),
/// )
/// ```
class NortListTile extends StatelessWidget {
  const NortListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.sm + 2),
        child: Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: spacing.md)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.titleSmall),
                  if (subtitle != null)
                    Text(subtitle!, style: context.textStyles.bodySmall),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
