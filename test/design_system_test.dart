import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nort/core/extensions/nort_theme_context_x.dart';
import 'package:nort/core/theme/nort_theme.dart';

void main() {
  test('NortTheme.light monta um ThemeData com brightness correto', () {
    final theme = NortTheme.light;
    expect(theme.colorScheme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, isNotNull);
  });

  test('NortTheme.dark monta um ThemeData com todas as extensions', () {
    final theme = NortTheme.dark;
    expect(theme.colorScheme.brightness, Brightness.dark);
  });

  testWidgets('Tokens são recuperáveis via BuildContext em ambos os temas', (
    tester,
  ) async {
    for (final theme in [NortTheme.light, NortTheme.dark]) {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Todos os tokens devem resolver sem lançar (o `!` em cada
      // getter da extension falharia aqui se algum token não tivesse
      // sido registrado em `NortTheme._build`).
      expect(capturedContext.colors, isNotNull);
      expect(capturedContext.spacing.md, 12);
      expect(capturedContext.radii.md, 16);
      expect(capturedContext.shadows, isNotNull);
      expect(
          capturedContext.motion.standard, const Duration(milliseconds: 240));
      expect(capturedContext.numericStyles.large.fontFeatures, isNotEmpty);
    }
  });
}
