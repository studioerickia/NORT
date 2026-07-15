import 'package:flutter/material.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/hero_tags.dart';
import '../../../../shared/components/chat_bubble/blue_message_bubble.dart';
import '../../../../shared/components/chat_bubble/suggestion_chip.dart';
import '../../../../shared/components/chat_bubble/timestamp_and_status.dart';
import '../../../../shared/components/chat_bubble/typing_indicator.dart';
import '../../../../shared/components/chat_bubble/user_message_bubble.dart';
import '../../../../shared/components/inputs/chat_input.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

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
        showBackButton: true,
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: TypingIndicator(),
                  ),
                  SizedBox(height: spacing.md),
                  Wrap(
                    spacing: spacing.sm,
                    children: [
                      SuggestionChip(
                          label: 'Quais são minhas prioridades?', onTap: () {}),
                      SuggestionChip(
                          label: 'Como estou esta semana?', onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.md),
              child: ChatInput(
                controller: _controller,
                hasText: _hasText,
                onMicTap: () {},
                onSend: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
