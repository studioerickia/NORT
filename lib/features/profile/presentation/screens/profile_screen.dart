import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../shared/components/avatars/user_avatar.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/loading/loading_state.dart';
import '../../../../shared/components/navigation/navigation_tile.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Perfil', showBackButton: true),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.xxxl,
          ),
          children: [
            profileAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: LoadingState(),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'Não foi possível carregar seu perfil.',
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodyMedium,
                ),
              ),
              data: (profile) {
                final name = profile?.displayNameOrFallback ?? 'Você';
                final email = profile?.email ?? '';
                final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

                return Center(
                  child: Column(
                    children: [
                      UserAvatar(initials: initials, size: 72),
                      SizedBox(height: spacing.md),
                      Text(name, style: context.textStyles.titleLarge),
                      SizedBox(height: spacing.xs / 2),
                      Text(email, style: context.textStyles.bodyMedium),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: spacing.xxl),
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
            const NortDivider(),
            NavigationTile(
              icon: Icons.logout,
              title: 'Sair',
              onTap: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) context.go(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}