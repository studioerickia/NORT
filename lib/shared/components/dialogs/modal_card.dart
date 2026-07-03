import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/nort_icon_button.dart';

/// Card modal — para conteúdo mais rico que um `AlertDialog` simples
/// (ex.: detalhe de uma sugestão da Blue, preview de uma decisão),
/// com botão de fechar explícito no canto.
///
/// Exemplo:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => ModalCard(
///     title: 'Detalhe da decisão',
///     onClose: () => Navigator.pop(context),
///     child: Text('Conteúdo customizado aqui.'),
///   ),
/// );
/// ```
class ModalCard extends StatelessWidget {
  const ModalCard({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  final String title;
  final Widget child;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Dialog(
      backgroundColor: colors.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: radii.xlRadius),
      insetPadding: EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.xxl),
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: context.textStyles.headlineSmall),
                ),
                if (onClose != null)
                  NortIconButton(icon: Icons.close, onPressed: onClose, size: 32),
              ],
            ),
            SizedBox(height: spacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
