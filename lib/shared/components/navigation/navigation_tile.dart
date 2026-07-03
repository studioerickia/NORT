import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Item de navegação em lista — ícone, título, subtítulo opcional e
/// chevron (ex.: itens de um menu lateral ou tela de Configurações).
///
/// Exemplo:
/// ```dart
/// NavigationTile(icon: Icons.person_outline, title: 'Perfil', onTap: () {})
/// ```
class NavigationTile extends StatelessWidget {
  const NavigationTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        child: Row(
          children: [
            Icon(icon, size: 22, color: colors.textSecondary),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.titleMedium),
                  if (subtitle != null)
                    Text(subtitle!, style: context.textStyles.bodySmall),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right, size: 20, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}
