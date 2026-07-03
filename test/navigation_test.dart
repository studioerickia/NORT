import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nort/app.dart';
import 'package:nort/features/chat/presentation/screens/chat_screen.dart';
import 'package:nort/features/goals/presentation/screens/goals_screen.dart';
import 'package:nort/features/home/presentation/screens/home_screen.dart';
import 'package:nort/features/life_os/presentation/screens/life_os_screen.dart';
import 'package:nort/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:nort/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:nort/shared/components/bottom_bar/bottom_nav_bar.dart';

void main() {
  testWidgets('Fluxo completo: splash → onboarding → login → home', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: NortApp()));
    await tester.pump();

    // Splash → Onboarding (toque)
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);

    // Onboarding → Login
    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();
    expect(find.text('Entrar'), findsOneWidget);

    // Login → Home
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Bottom navigation troca entre as 4 abas do Shell', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: NortApp()));
    await tester.pump();
    await tester.tap(find.byType(GestureDetector).first); // splash
    await tester.pumpAndSettle();
    await tester.tap(find.text('Começar')); // onboarding
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar')); // login
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();
    expect(find.byType(TransactionsScreen), findsOneWidget);

    await tester.tap(find.text('Metas'));
    await tester.pumpAndSettle();
    expect(find.byType(GoalsScreen), findsOneWidget);

    await tester.tap(find.text('Life OS'));
    await tester.pumpAndSettle();
    expect(find.byType(LifeOsScreen), findsOneWidget);

    await tester.tap(find.text('Início'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('FAB abre a tela de Chat por cima do Shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NortApp()));
    await tester.pump();
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    // NortFab não expõe label — localiza pelo ícone padrão (Icons.add).
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byType(ChatScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('NortBottomNavBar mantém currentIndex sincronizado com a aba',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NortApp()));
    await tester.pump();
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Metas'));
    await tester.pumpAndSettle();

    final navBar = tester.widget<NortBottomNavBar>(
      find.byType(NortBottomNavBar),
    );
    expect(navBar.currentIndex, 2); // Início(0) Transações(1) Metas(2) LifeOS(3)
  });
}
