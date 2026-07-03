import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

/// Estado de autenticação consumido pelo guard de rota.
///
/// Hoje sempre `authenticated` — não existe login real nesta sprint.
/// Quando `features/auth` ganhar lógica de verdade, este enum passa a
/// refletir sessão real (via um provider Riverpod), e nada na
/// assinatura de [authRedirect] muda.
enum AuthStatus { authenticated, unauthenticated, unknown }

/// Guard de autenticação do GoRouter — a função `redirect` que decide
/// se a navegação pretendida deve ser desviada para `/login`.
///
/// **Sem lógica real nesta etapa**: sempre retorna `null` (não
/// redireciona nada), porque `AuthStatus` está hardcoded como
/// `authenticated`. O hook existe pronto — só falta trocar a origem
/// de `currentStatus` por um provider real de sessão quando a
/// feature `auth` for implementada (ver ADR seção 10: "guards de auth
/// já estruturados, mas sem lógica real de sessão ainda").
String? authRedirect(BuildContext context, GoRouterState state) {
  const currentStatus = AuthStatus.authenticated;

  final isGoingToAuthFlow = state.matchedLocation == AppRoutes.login ||
      state.matchedLocation == AppRoutes.onboarding ||
      state.matchedLocation == AppRoutes.splash;

  switch (currentStatus) {
    case AuthStatus.authenticated:
      // Usuário autenticado tentando abrir login/onboarding/splash de
      // novo — no futuro, redirecionar para /home. Não implementado
      // ainda para não forçar navegação nesta sprint sem telas reais.
      return null;
    case AuthStatus.unauthenticated:
      // Usuário não autenticado tentando abrir qualquer rota fora do
      // fluxo de auth — no futuro, redirecionar para /login.
      if (!isGoingToAuthFlow) {
        // Desligado nesta etapa (sempre null acima) — mantido aqui só
        // como o formato que a lógica real vai assumir.
        return null;
      }
      return null;
    case AuthStatus.unknown:
      return null;
  }
}
