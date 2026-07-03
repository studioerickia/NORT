import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/components/bottom_bar/bottom_nav_bar.dart';
import 'app_routes.dart';

/// Casca visual persistente das 4 abas principais (Home, Transações,
/// Metas, Life OS) — a `NortBottomNavBar` e o `NortFab` nunca são
/// reconstruídos ao trocar de aba, só o conteúdo interno troca.
///
/// Implementado sobre `StatefulShellRoute.indexedStack` (ver
/// `app_router.dart`) em vez de um `ShellRoute` simples — a diferença
/// prática é que cada aba mantém sua própria pilha de navegação e
/// estado de scroll ao trocar de volta para ela, o que um `ShellRoute`
/// comum não garante. É um refinamento sobre a redação literal do
/// ADR ("ShellRoute do GoRouter"), documentado aqui pelo mesmo motivo
/// que os desvios das etapas anteriores: escolha técnica que cumpre
/// melhor a intenção do ADR, não uma mudança de intenção.
///
/// FAB central abre `/chat` — a conversa com a Blue é a ação primária
/// de "criar/perguntar algo", não uma aba fixa (ver decisão de design
/// já registrada em `NortFab`).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _items = [
    NortNavItem(icon: Icons.home_outlined, label: 'Início'),
    NortNavItem(icon: Icons.swap_horiz, label: 'Transações'),
    NortNavItem(icon: Icons.check_circle_outline, label: 'Metas'),
    NortNavItem(icon: Icons.grid_view_outlined, label: 'Life OS'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NortBottomNavBar(
        items: _items,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Reentrar na mesma aba volta ao topo da pilha dela, em vez
          // de empilhar mais uma instância — comportamento padrão
          // esperado de bottom navigation.
          initialLocation: index == navigationShell.currentIndex,
        ),
        onFabTap: () => context.push(AppRoutes.chat),
      ),
    );
  }
}
