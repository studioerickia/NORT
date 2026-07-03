import 'package:flutter/material.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/hero_tags.dart';
import '../../../../shared/components/chat_bubble/blue_message_bubble.dart';
import '../../../../shared/components/chat_bubble/suggestion_chip.dart';
import '../../../../shared/components/chat_bubble/user_message_bubble.dart';
import '../../../../shared/components/inputs/chat_input.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

/// Tela de conversa com a Blue — placeholder navegável, com mensagens
/// mockadas fixas (sem `ChatInput` funcional, sem `blue/domain/brain`
/// conectado ainda).
///
/// A `BlueAvatar` no topo usa a mesma `heroTag` da Home — é isso que
/// produz a transição Hero ao navegar Home → Chat (ADR seção 8).
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: NortTopAppBar(
        title: 'Conversa com a Blue',
        trailing: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: BlueAvatar(
              state: BlueState.idle,
              size: 32,
              showGlow: false,
              heroTag: NortHeroTags.blueAvatar,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(spacing.lg),
                children: [
                  BlueMessageBubble(
                    text: 'Bom dia, Erick! Como posso te ajudar hoje?',
                    time: '09:41',
                  ),
                  SizedBox(height: spacing.sm),
                  UserMessageBubble(
                    text: 'Posso comprar esse tênis de R\$899?',
                    time: '09:41',
                    status: NortMessageDeliveryStatus.read,
                  ),
                  SizedBox(height: spacing.sm),
                  BlueMessageBubble(
                    text:
                        'Essa compra cabe, mas reduziria seu limite diário para R\$32 pelos próximos 7 dias. Ainda faz sentido para você?',
                    time: '09:41',
                  ),
                  SizedBox(height: spacing.md),
                  Wrap(
                    spacing: spacing.sm,
                    children: [
                      SuggestionChip(label: 'Quais são minhas prioridades?', onTap: () {}),
                      SuggestionChip(label: 'Como estou esta semana?', onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.md),
              child: ChatInput(controller: _controller, hasText: false, onMicTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
