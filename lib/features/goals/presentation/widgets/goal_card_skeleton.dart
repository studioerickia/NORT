import 'package:flutter/material.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/skeleton/skeleton.dart';

class GoalCardSkeleton extends StatelessWidget {
  const GoalCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: radii.lgRadius,
        boxShadow: context.shadows.low,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NortSkeleton(width: 56, height: 56, radius: radii.md),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NortSkeleton(width: 140, height: 16),
                SizedBox(height: spacing.sm),
                const NortSkeleton(width: double.infinity, height: 12),
                SizedBox(height: spacing.xs),
                const NortSkeleton(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
