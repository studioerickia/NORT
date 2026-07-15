import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nort/blue/presentation/blue_avatar.dart';
import 'package:nort/blue/presentation/blue_state.dart';
import 'package:nort/core/theme/nort_theme.dart';

Widget _wrap(
  Widget child, {
  Brightness brightness = Brightness.light,
  bool? disableAnimations,
}) {
  return MaterialApp(
    theme: brightness == Brightness.light ? NortTheme.light : NortTheme.dark,
    builder: disableAnimations == null
        ? null
        : (context, materialChild) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(disableAnimations: disableAnimations),
              child: materialChild!,
            );
          },
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('BlueAvatar — renderização por estado', () {
    for (final state in BlueState.values) {
      testWidgets('renderiza sem erro no estado $state', (tester) async {
        await tester.pumpWidget(_wrap(BlueAvatar(state: state, size: 64)));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.byType(BlueAvatar), findsOneWidget);
      });
    }
  });

  group('BlueAvatar — tamanho', () {
    testWidgets('aplica o size solicitado', (tester) async {
      const size = 96.0;
      await tester.pumpWidget(_wrap(const BlueAvatar(size: size)));
      await tester.pump();

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final matches =
          sizedBoxes.where((box) => box.width == size && box.height == size);
      expect(matches, isNotEmpty,
          reason: 'Esperava um SizedBox de ${size}x$size');
    });

    testWidgets(
        'tamanho pequeno (18px, usado em observações inline) não quebra',
        (tester) async {
      await tester
          .pumpWidget(_wrap(const BlueAvatar(size: 18, showGlow: false)));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('BlueAvatar — tema claro e escuro', () {
    testWidgets('renderiza sem erro no tema claro', (tester) async {
      await tester
          .pumpWidget(_wrap(const BlueAvatar(), brightness: Brightness.light));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza sem erro no tema escuro', (tester) async {
      await tester
          .pumpWidget(_wrap(const BlueAvatar(), brightness: Brightness.dark));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('BlueAvatar — acessibilidade', () {
    testWidgets('tem semanticLabel padrão quando nenhum é fornecido',
        (tester) async {
      await tester
          .pumpWidget(_wrap(const BlueAvatar(state: BlueState.celebrating)));
      await tester.pump();

      final semantics = tester.getSemantics(find.byType(BlueAvatar));
      expect(semantics.label, contains('Blue'));
      expect(semantics.label, contains('comemorando'));
    });

    testWidgets('respeita semanticLabel customizado', (tester) async {
      await tester.pumpWidget(
        _wrap(const BlueAvatar(semanticLabel: 'Rótulo customizado de teste')),
      );
      await tester.pump();

      final semantics = tester.getSemantics(find.byType(BlueAvatar));
      expect(semantics.label, 'Rótulo customizado de teste');
    });
  });

  group('BlueAvatar — animação e acessibilidade de movimento', () {
    testWidgets('animate: false não quebra e não anima', (tester) async {
      await tester.pumpWidget(_wrap(const BlueAvatar(animate: false)));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'respeita MediaQuery.disableAnimations (reduzir movimento do SO)',
        (tester) async {
      await tester
          .pumpWidget(_wrap(const BlueAvatar(), disableAnimations: true));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('BlueAvatar — heroTag', () {
    testWidgets('envolve em Hero quando heroTag é fornecido', (tester) async {
      await tester
          .pumpWidget(_wrap(const BlueAvatar(heroTag: 'blue-test-tag')));
      await tester.pump();
      expect(find.byType(Hero), findsOneWidget);
    });

    testWidgets('não envolve em Hero quando heroTag é nulo', (tester) async {
      await tester.pumpWidget(_wrap(const BlueAvatar()));
      await tester.pump();
      expect(find.byType(Hero), findsNothing);
    });
  });
}
