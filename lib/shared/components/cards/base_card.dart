import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../common/pressable_scale.dart';

/// Card base do NORT — fundação visual para `SummaryCard`, `GoalCard`,
/// `InfoCard`, `StatusCard`, `MetricCard` e `NotificationCard`.
///
/// Calm UI aplicado aqui: radius generoso (`lg` por padrão), sombra
/// `low` (nunca `medium`/`high` em repouso), sem borda por padrão.
///
/// Exemplo:
/// ```dart
/// BaseCard(
///   onTap: () {},
///   child: Text('Conteúdo do card'),
/// )
/// ```
class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.elevated = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  /// Quando `false`, remove a sombra — útil para cards dentro de
  /// outro card, onde uma segunda sombra criaria ruído visual.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;
    final shadows = context.shadows;

    final content = Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: radii.lgRadius,
        boxShadow: elevated ? shadows.low : shadows.none,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return PressableScale(onTap: onTap, child: content);
  }
}
