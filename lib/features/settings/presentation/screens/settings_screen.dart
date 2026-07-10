import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../shared/components/whale_labs_signature.dart';
import '../../../../shared/components/inputs/selection_controls.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/navigation/navigation_tile.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const NortTopAppBar(title: 'Configurações', showBackButton: true),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.xxxl,
          ),
          children: [
            NavigationTile(
              icon: Icons.dark_mode_outlined,
              title: 'Tema escuro',
              trailing: NortSwitch(
                value: themeMode == ThemeMode.dark,
                onChanged: (isDark) {
                  ref.read(themeModeProvider.notifier).state =
                      isDark ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
            const NortDivider(),
            NavigationTile(
              icon: Icons.notifications_outlined,
              title: 'Notificações',
              onTap: () {},
            ),
            const NortDivider(),
            NavigationTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacidade',
              onTap: () {},
            ),
            const NortDivider(),
            NavigationTile(
              icon: Icons.info_outline,
              title: 'Sobre o NORT',
              onTap: () => context.push(AppRoutes.about),
            ),
            SizedBox(height: spacing.xxxl),
            const Center(
              child: WhaleLabsSignature(
                variant: WhaleLabsSignatureVariant.footer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}