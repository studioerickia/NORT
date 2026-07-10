import 'package:flutter/material.dart';

import '../../../../blue/presentation/blue_avatar.dart';
import '../../../../blue/presentation/blue_state.dart';
import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../shared/components/cards/info_card.dart';
import '../../../../shared/components/layout/life_os_orbit.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

class LifeOsScreen extends StatelessWidget {
  const LifeOsScreen({super.key});

  static const _areas = [
    LifeOSAreaItem(icon: Icons.account_balance_wallet_outlined, label: 'Finanças', status: 'Bem'),
    LifeOSAreaItem(icon: Icons.favorite_border, label: 'Saúde', status: 'Ótimo'),
    LifeOSAreaItem(icon: Icons.person_outline, label: 'Pessoal', status: 'Bem'),
    LifeOSAreaItem(icon: Icons.groups_outlined, label: 'Relações', status: 'Bem'),
    LifeOSAreaItem(icon: Icons.star_outline, label: 'Propósito', status: 'Em foco'),
    LifeOSAreaItem(icon: Icons.trending_up, label: 'Crescimento', status: 'Evoluindo'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Life OS'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.md,
            spacing.lg,
            spacing.xxxl,
          ),
          children: [
            Text('Sua vida em equilíbrio', style: context.textStyles.headlineMedium),
            SizedBox(height: spacing.xs),
            Text(
              'Acompanhe todas as áreas que importam para você.',
              style: context.textStyles.bodyMedium,
            ),
            SizedBox(height: spacing.xl),
            Center(
              child: LifeOSOrbit(
                areas: _areas,
                center: const BlueAvatar(state: BlueState.idle, size: 140),
              ),
            ),
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