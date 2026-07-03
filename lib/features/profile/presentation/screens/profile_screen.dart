import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/components/avatars/user_avatar.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/navigation/navigation_tile.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

/// Tela de Perfil — placeholder navegável, empilhada por cima do
/// Shell (fora da bottom navigation).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: NortTopAppBar(
        title: 'Perfil',
        onMenuTap: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    const UserAvatar(initials: 'EM', size: 72),
                    SizedBox(height: spacing.md),
                    Text('Erick Medeiros', style: context.textStyles.titleLarge),
                  ],
                ),
              ),
              SizedBox(height: spacing.xl),
              NavigationTile(
                icon: Icons.settings_outlined,
                title: 'Configurações',
                onTap: () => context.push(AppRoutes.settings),
              ),
              const NortDivider(),
              NavigationTile(
                icon: Icons.help_outline,
                title: 'Ajuda',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
