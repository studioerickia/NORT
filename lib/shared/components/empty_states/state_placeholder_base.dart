import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/primary_button.dart';

/// Base visual compartilhada por `EmptyState`, `ErrorState` e
/// `OfflineState` — os três têm a mesma anatomia (ícone, título,
/// descrição, ação opcional), só mudam o tom/ícone. Consolidar aqui
/// evita divergência visual entre os três com o tempo.
class StatePlaceholderBase extends StatelessWidget {
  const StatePlaceholderBase({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: iconColor ?? colors.textTertiary),
            SizedBox(height: spacing.lg),
            Text(
              title,
              style: context.textStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              SizedBox(height: spacing.sm),
              Text(
                description!,
                style: context.textStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: spacing.xl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
