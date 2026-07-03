import 'package:flutter/material.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/cards/info_card.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

/// Tela de Life OS — placeholder navegável. O componente radial
/// (`LifeOSOrbit`, ver ADR seção 7) ainda não existe na Component
/// Library — fica para uma etapa futura, quando `features/life_os`
/// ganhar lógica; aqui só a `BlueAvatar` central e um `InfoCard`
/// representam o conceito.
class LifeOsScreen extends StatelessWidget {
  const LifeOsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Life OS'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Text('Sua vida em equilíbrio', style: context.textStyles.headlineMedium),
            SizedBox(height: spacing.xs),
            Text(
              'Acompanhe todas as áreas que importam para você.',
              style: context.textStyles.bodyMedium,
            ),
            SizedBox(height: spacing.xl),
            const Center(child: BlueAvatar(state: BlueState.idle, size: 140)),
            SizedBox(height: spacing.xl),
            InfoCard(
              title: 'Insights da Blue',
              description: 'Sua vida está em harmonia.',
              actionLabel: 'Explorar áreas',
              onAction: () {},
            ),
          ],
        ),
      ),
    );
  }
}
