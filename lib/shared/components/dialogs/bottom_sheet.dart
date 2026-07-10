import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

class NortBottomSheet extends StatelessWidget {
  const NortBottomSheet({super.key, required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(spacing.lg, spacing.sm, spacing.lg, spacing.xl),
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radii.xl),
            topRight: Radius.circular(radii.xl),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: EdgeInsets.only(bottom: spacing.md),
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(radii.pill),
                  ),
                ),
              ),
              if (title != null) ...[
                Text(title!, style: context.textStyles.headlineSmall),
                SizedBox(height: spacing.md),
              ],
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}