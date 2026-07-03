import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/nort_text_button.dart';

/// Cabeçalho de seção — título + ação opcional "Ver tudo" (ver
/// imagens de referência: "Resumo do dia · Ver tudo").
///
/// Exemplo:
/// ```dart
/// SectionHeader(title: 'Resumo do dia', actionLabel: 'Ver tudo', onAction: () {})
/// ```
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.textStyles.titleLarge),
        if (actionLabel != null && onAction != null)
          NortTextButton(label: actionLabel!, onPressed: onAction),
      ],
    );
  }
}
