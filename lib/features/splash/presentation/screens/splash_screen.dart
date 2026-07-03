import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';

/// Tela de splash — placeholder desta etapa. Sem redirecionamento
/// automático por tempo/sessão ainda (isso dependeria do guard de
/// auth ter estado real, ver `core/routing/auth_guard.dart`) — por
/// isso o avanço é por toque, não por timer, para o fluxo continuar
/// navegável mesmo sem lógica real por trás.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: GestureDetector(
        onTap: () => context.go(AppRoutes.onboarding),
        behavior: HitTestBehavior.opaque,
        child: const Center(
          child: BlueAvatar(state: BlueState.idle, size: 120),
        ),
      ),
    );
  }
}
