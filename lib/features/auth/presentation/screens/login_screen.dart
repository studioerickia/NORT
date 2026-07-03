import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/buttons/primary_button.dart';
import '../../../../shared/components/inputs/text_input.dart';

/// Tela de login — placeholder. Campos e botão presentes, mas sem
/// nenhuma chamada a `core/services/supabase/auth_service` ainda
/// (interface existe desde a Sprint 0, implementação é sprint
/// futura).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Entrar', style: context.textStyles.headlineLarge),
              SizedBox(height: spacing.xl),
              const NortTextInput(label: 'E-mail', placeholder: 'voce@email.com'),
              SizedBox(height: spacing.md),
              const NortTextInput(label: 'Senha', obscureText: true),
              SizedBox(height: spacing.xl),
              PrimaryButton(
                label: 'Continuar',
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
