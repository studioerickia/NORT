@Skip(
    'Pré-Sprint 1 — não configura sharedPreferencesProvider nem sessão Supabase. Precisa de infraestrutura de mock antes de reativar.')
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nort/app.dart';
import 'package:nort/blue/presentation/blue_avatar.dart';

void main() {
  testWidgets(
    'NortApp renderiza sem erros e abre em /splash (smoke test pós-Etapa 5)',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: NortApp()));
      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);
      // SplashScreen é a rota inicial (AppRoutes.splash) e renderiza
      // um BlueAvatar — prova de que o GoRouter resolveu a rota real,
      // não só que o MaterialApp existe.
      expect(find.byType(BlueAvatar), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
