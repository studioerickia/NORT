import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/goals/presentation/screens/goals_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/life_os/presentation/screens/life_os_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import 'app_routes.dart';
import 'app_shell.dart';
import 'auth_guard.dart';
import 'page_transitions.dart';

/// Provider do `GoRouter` — ponto único de construção do roteador,
/// consumido por `app.dart` via `MaterialApp.router`.
///
/// `Provider` (não `StateProvider`): o roteador em si não deve ser
/// recriado a cada rebuild — GoRouter mantém seu próprio estado
/// interno de navegação. Se `authRedirect` ganhar dependência de um
/// provider real de sessão no futuro, este provider passa a observar
/// aquele (`ref.watch`) e o GoRouter é reconstruído só quando a
/// sessão muda — não a cada frame.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: authRedirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => buildNortPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => buildNortPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => buildNortPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      // Rotas de tela cheia — empilhadas por cima do Shell, não
      // fazem parte da bottom navigation (ver ADR seção 10: Chat,
      // Profile e Settings não estão entre os "5 destinos + FAB").
      GoRoute(
        path: AppRoutes.chat,
        pageBuilder: (context, state) => buildNortPage(
          key: state.pageKey,
          child: const ChatScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) => buildNortPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => buildNortPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),

      // Shell principal — bottom nav + FAB persistentes, 4 abas com
      // pilha de navegação independente cada uma.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => buildNortPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                pageBuilder: (context, state) => buildNortPage(
                  key: state.pageKey,
                  child: const TransactionsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.goals,
                pageBuilder: (context, state) => buildNortPage(
                  key: state.pageKey,
                  child: const GoalsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.lifeOs,
                pageBuilder: (context, state) => buildNortPage(
                  key: state.pageKey,
                  child: const LifeOsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],

    // Placeholder de tela de erro de rota — nenhuma feature de
    // "página não encontrada" foi pedida nesta etapa, mas o GoRouter
    // exige algum tratamento; um `Scaffold` mínimo evita crash em
    // deep link malformado.
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Rota não encontrada: ${state.uri}')),
    ),
  );
});
