import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import 'timestamp_and_status.dart';

/// Bolha de mensagem do usuário — alinhada à direita, fundo
/// `chatBubbleUser` (verde muito claro, ver imagens de referência),
/// com timestamp e status de leitura opcionais.
///
/// Exemplo:
/// ```dart
/// UserMessageBubble(
///   text: 'Posso comprar esse tênis de R\$899?',
///   time: '09:41',
///   status: NortMessageDeliveryStatus.read,
/// )
/// ```
class UserMessageBubble extends StatelessWidget {
  const UserMessageBubble({
    super.key,
    required this.text,
    this.time,
    this.status,
  });

  final String text;
  final String? time;
  final NortMessageDeliveryStatus? status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: colors.chatBubbleUser,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radii.lg),
              topRight: Radius.circular(radii.lg),
              bottomLeft: Radius.circular(radii.lg),
              bottomRight: Radius.circular(radii.sm / 2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colors.chatBubbleUserText,
                ),
              ),
              if (time != null) ...[
                SizedBox(height: spacing.xs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Timestamp(label: time!),
                    if (status != null) ...[
                      SizedBox(width: spacing.xs),
                      MessageStatus(status: status!),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
