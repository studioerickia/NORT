import 'package:flutter/material.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/skeleton/skeleton.dart';

class TransactionRowSkeleton extends StatelessWidget {
  const TransactionRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      child: Row(
        children: [
          const NortSkeleton.circle(size: 36),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NortSkeleton(width: 120, height: 14),
                SizedBox(height: spacing.xs),
                const NortSkeleton(width: 60, height: 12),
              ],
            ),
          ),
          const NortSkeleton(width: 56, height: 14),
        ],
      ),
    );
  }
}