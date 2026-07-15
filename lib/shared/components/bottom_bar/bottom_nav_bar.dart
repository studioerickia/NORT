import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/fab.dart';

/// Item de destino da bottom navigation.
class NortNavItem {
  const NortNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Barra de navegação inferior com FAB central (ver imagens de
/// referência: Início, Transações, [+], Metas, Life OS).
///
/// Não sabe nada sobre rotas — recebe `items`, `currentIndex` e
/// `onTap`, quem decide navegação real é a camada de Navegação
/// (Etapa 5, GoRouter). Isso mantém o componente reutilizável mesmo
/// se o roteamento mudar de tecnologia no futuro.
///
/// Exemplo:
/// ```dart
/// NortBottomNavBar(
///   items: const [NortNavItem(icon: Icons.home_outlined, label: 'Início'), ...],
///   currentIndex: 0,
///   onTap: (i) {},
///   onFabTap: () {},
/// )
/// ```
class NortBottomNavBar extends StatelessWidget {
  const NortBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.onFabTap,
  });

  final List<NortNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onFabTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final shadows = context.shadows;

    // FAB entra no meio da lista de itens (posição fixa: metade).
    final midpoint = items.length ~/ 2;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: shadows.low,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i == midpoint) NortFab(onPressed: onFabTap),
              _NavDestination(
                item: items[i],
                selected: i == currentIndex,
                onTap: () => onTap(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavDestination extends StatelessWidget {
  const _NavDestination({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final NortNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.brand.defaultColor : colors.textTertiary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 22, color: color),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: context.textStyles.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
