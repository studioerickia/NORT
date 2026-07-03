import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nort/core/theme/nort_theme.dart';
import 'package:nort/shared/component_preview/component_preview_screen.dart';

void main() {
  for (final entry in {
    'light': NortTheme.light,
    'dark': NortTheme.dark,
  }.entries) {
    testWidgets(
      'ComponentPreviewScreen renderiza sem erros no tema ${entry.key}',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: entry.value,
            home: const ComponentPreviewScreen(),
          ),
        );

        // Primeiro frame: cobre todos os widgets estáticos.
        await tester.pump();

        // Mais alguns frames: cobre os componentes com
        // AnimationController em loop (TypingIndicator, BlueGlow,
        // BlueThinking, BlueListening, BlueCelebrating, NortSkeleton)
        // sem cair no erro "pending timers" do pumpAndSettle, que
        // nunca convergiria com animações em `repeat()`.
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        expect(find.byType(ComponentPreviewScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
