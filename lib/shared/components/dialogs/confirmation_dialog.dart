import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

/// Dialog de confirmação — decisão binária (ex.: "Excluir meta?").
/// Retorna `true`/`false`/`null` via `Navigator.pop`; quem decide o
/// que fazer com a resposta é a feature que abriu o dialog — este
/// componente não executa nenhuma ação, só apresenta a escolha.
///
/// `destructive` marca a intenção da ação para o chamador estilizar
/// como quiser — este componente não força cor `danger` por conta
/// própria, pois nem toda confirmação "destrutiva" deve alarmar
/// visualmente (Calm UI).
///
/// Exemplo:
/// ```dart
/// final confirmed = await showDialog<bool>(
///   context: context,
///   builder: (_) => ConfirmationDialog(
///     title: 'Excluir meta?',
///     message: 'Essa ação não pode ser desfeita.',
///   ),
/// );
/// ```
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.destructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;

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
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: cancelLabel,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: PrimaryButton(
                    label: confirmLabel,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
