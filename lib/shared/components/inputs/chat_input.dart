import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/nort_icon_button.dart';

/// Campo "Fale com a Blue..." — pílula com ícone de sugestão à
/// esquerda e botão de enviar/microfone à direita (ver imagens de
/// referência).
///
/// Exemplo:
/// ```dart
/// ChatInput(
///   controller: controller,
///   onSend: () {},
///   hasText: controller.text.isNotEmpty,
/// )
/// ```
class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.controller,
    required this.hasText,
    this.onSend,
    this.onMicTap,
    this.placeholder = 'Fale com a Blue...',
  });

  final TextEditingController controller;
  final bool hasText;
  final VoidCallback? onSend;
  final VoidCallback? onMicTap;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;
    final shadows = context.shadows;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.pill),
        boxShadow: shadows.low,
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, size: 18, color: colors.brand.defaultColor),
          SizedBox(width: spacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              style: context.textStyles.bodyLarge,
              cursorColor: colors.brand.defaultColor,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: context.textStyles.bodyLarge
                    ?.copyWith(color: colors.textTertiary),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          NortIconButton(
            icon: hasText ? Icons.arrow_upward : Icons.mic_none,
            filled: true,
            onPressed: hasText ? onSend : onMicTap,
            size: 36,
          ),
        ],
      ),
    );
  }
}
