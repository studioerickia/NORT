import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/primary_button.dart';

/// Dialog de alerta simples — título, mensagem, um único botão de
/// confirmação. Uso: comunicar algo, sem decisão binária (para
/// decisão, ver `ConfirmationDialog`).
///
/// Exemplo:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => NortAlertDialog(
///     title: 'Limite atualizado',
///     message: 'Seu limite diário foi ajustado para R\$32.',
///     confirmLabel: 'Entendi',
///   ),
/// );
/// ```
class NortAlertDialog extends StatelessWidget {
  const NortAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Entendi',
  });

  final String title;
  final String message;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Dialog(
      backgroundColor: colors.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: radii.xlRadius),
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.textStyles.headlineSmall),
            SizedBox(height: spacing.sm),
            Text(message, style: context.textStyles.bodyMedium),
            SizedBox(height: spacing.xl),
            PrimaryButton(
              label: confirmLabel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
