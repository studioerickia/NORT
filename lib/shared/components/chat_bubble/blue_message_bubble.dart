import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import 'timestamp_and_status.dart';

/// Bolha de mensagem da Blue — alinhada à esquerda, fundo `surface`
/// (branco no light, cinza-camada no dark), sem status de leitura
/// (só o usuário lê a Blue, não o contrário).
///
/// `avatar` é injetado (não construído aqui) porque este componente
/// não conhece `BlueAvatar` — ele vive em `lib/blue/presentation`,
/// uma camada diferente (ver ADR seção 13, regra de dependência 4:
/// `features/chat` fala com `blue/presentation`, não o contrário).
///
/// Exemplo:
/// ```dart
/// BlueMessageBubble(
///   text: 'Essa compra cabe, mas reduziria seu limite diário.',
///   time: '09:41',
///   avatar: BlueAvatar(state: BlueState.speaking, size: 28),
/// )
/// ```
class BlueMessageBubble extends StatelessWidget {
  const BlueMessageBubble({
    super.key,
    required this.text,
    this.time,
    this.avatar,
  });

  final String text;
  final String? time;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;
    final shadows = context.shadows;

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avatar != null) ...[avatar!, SizedBox(width: spacing.sm)],
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm + 2,
              ),
              decoration: BoxDecoration(
                color: colors.chatBubbleBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radii.lg),
                  topRight: Radius.circular(radii.lg),
                  bottomRight: Radius.circular(radii.lg),
                  bottomLeft: Radius.circular(radii.sm / 2),
                ),
                boxShadow: shadows.low,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: context.textStyles.bodyLarge?.copyWith(
                      color: colors.chatBubbleBlueText,
                    ),
                  ),
                  if (time != null) ...[
                    SizedBox(height: spacing.xs),
                    Timestamp(label: time!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
