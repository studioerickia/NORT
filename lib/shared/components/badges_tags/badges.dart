import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../../tokens/colors/nort_colors.dart';

/// Base interna compartilhada pelos 4 badges — mesma anatomia (fundo
/// suave + texto colorido + `radii.pill`), só muda a paleta.
class _NortBadgeBase extends StatelessWidget {
  const _NortBadgeBase({
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radii = context.radii;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: spacing.sm, vertical: spacing.xs / 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            SizedBox(width: spacing.xs / 2),
          ],
          Text(label,
              style: context.textStyles.labelSmall?.copyWith(color: color)),
        ],
      ),
    );
  }
}

/// Badge de sucesso/positivo (ex.: "Meta concluída").
class SuccessBadge extends StatelessWidget {
  const SuccessBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _NortBadgeBase(
      label: label,
      color: colors.positive.defaultColor,
      background: colors.positiveSurface,
      icon: Icons.check_circle_outline,
    );
  }
}

/// Badge de atenção leve (ex.: "Perto do limite").
class WarningBadge extends StatelessWidget {
  const WarningBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _NortBadgeBase(
      label: label,
      color: colors.warning,
      background: colors.warningSurface,
      icon: Icons.info_outline,
    );
  }
}

/// Badge informativo neutro-azul (ex.: "Novo").
class InfoBadge extends StatelessWidget {
  const InfoBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final NortColors colors = context.colors;
    return _NortBadgeBase(
      label: label,
      color: colors.brand.defaultColor,
      background: colors.brand.disabled,
      icon: Icons.auto_awesome_outlined,
    );
  }
}

/// Badge neutro, sem carga semântica (ex.: categoria/tag genérica).
class NeutralBadge extends StatelessWidget {
  const NeutralBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _NortBadgeBase(
      label: label,
      color: colors.textSecondary,
      background: colors.border,
    );
  }
}
