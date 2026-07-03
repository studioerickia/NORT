import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/nort_theme_context_x.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../shared/components/inputs/selection_controls.dart';
import '../../../../shared/components/layout/section_and_divider.dart';
import '../../../../shared/components/navigation/navigation_tile.dart';
import '../../../../shared/components/navigation/top_app_bar.dart';

/// Tela de Configurações — placeholder navegável.
///
/// Único ponto desta etapa que conecta a um provider "de verdade"
/// (`themeModeProvider`, da Etapa 2) — trocar o tema aqui já funciona
/// de ponta a ponta, é a prova viva de que o Design System está
/// completo, não só a navegação.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: NortTopAppBar(
        title: 'Configurações',
        onMenuTap: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: ListView(
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
            ],
          ),
        ),
      ),
    );
  }
}
