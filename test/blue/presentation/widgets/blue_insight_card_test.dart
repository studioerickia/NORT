import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nort/blue/domain/entities/blue_decision.dart';
import 'package:nort/blue/domain/entities/blue_message.dart';
import 'package:nort/blue/presentation/blue_avatar.dart';
import 'package:nort/blue/presentation/widgets/blue_insight_card.dart';
import 'package:nort/core/theme/nort_theme.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: NortTheme.light,
    home: Scaffold(body: Center(child: child)),
  );
}

BlueDecision _realDecision({BlueTone tone = BlueTone.reassuring, BlueMood mood = BlueMood.idle}) {
  return BlueDecision(
    trigger: BlueTrigger.negativeBalance,
    type: BlueDecisionType.financial,
    priority: BluePriority.high,
    message: BlueMessage(
      text: 'Mensagem de teste da Blue.',
      tone: tone,
      ruleId: 'test.rule',
      suggestedMood: mood,
    ),
    displayDuration: const Duration(seconds: 8),
  );
}

void main() {
  group('BlueInsightCard — decisão real', () {
    testWidgets('renderiza o texto da decisão', (tester) async {
      await tester.pumpWidget(_wrap(BlueInsightCard(decision: _realDecision())));
      await tester.pump();
      expect(find.text('Mensagem de teste da Blue.'), findsOneWidget);
    });

    testWidgets('mostra a Blue com o estado sugerido', (tester) async {
      await tester.pumpWidget(
        _wrap(BlueInsightCard(decision: _realDecision(mood: BlueMood.celebrating))),
      );
      await tester.pump();
      expect(find.byType(BlueAvatar), findsOneWidget);
    });
  });

  group('BlueInsightCard — silêncio', () {
    testWidgets('não renderiza nada quando shouldDisplay é false', (tester) async {
      await tester.pumpWidget(_wrap(BlueInsightCard(decision: BlueDecision.silence())));
      await tester.pump();
      expect(find.byType(Container), findsNothing);
      expect(find.byType(BlueAvatar), findsNothing);
      expect(find.text('Mensagem de teste da Blue.'), findsNothing);
    });
  });
}
