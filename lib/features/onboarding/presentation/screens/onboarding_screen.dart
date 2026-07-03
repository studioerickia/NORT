import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/buttons/primary_button.dart';

/// Tela de onboarding — placeholder desta etapa, só com um botão que
/// avança para o login. Sem conteúdo/carrossel real ainda.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Bem-vindo ao NORT', style: context.textStyles.headlineLarge),
              SizedBox(height: spacing.sm),
              Text(
                'Sua plataforma de bem-estar financeiro.',
                style: context.textStyles.bodyLarge,
              ),
              SizedBox(height: spacing.xxl),
              PrimaryButton(
                label: 'Começar',
                onPressed: () => context.go(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
