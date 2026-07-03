import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/nort_icon_button.dart';

/// Barra superior — logo/título central, ação à esquerda (menu) e
/// ações à direita (sino + avatar), como nas imagens de referência.
///
/// Implementa `PreferredSizeWidget` para poder ser usada diretamente
/// em `Scaffold.appBar` quando a Navegação (Etapa 5) precisar, mas
/// não depende de `Scaffold` — pode ser usada solta em qualquer
/// `Column`.
///
/// Exemplo:
/// ```dart
/// NortTopAppBar(
///   title: 'NORT',
///   onMenuTap: () {},
///   trailing: [NortIconButton(icon: Icons.notifications_outlined, onPressed: () {})],
/// )
/// ```
class NortTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NortTopAppBar({
    super.key,
    this.title,
    this.onMenuTap,
    this.trailing = const [],
  });

  final String? title;
  final VoidCallback? onMenuTap;
  final List<Widget> trailing;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      color: colors.background,
      child: Row(
        children: [
          if (onMenuTap != null)
            NortIconButton(icon: Icons.menu, onPressed: onMenuTap)
          else
            const SizedBox(width: 40),
          Expanded(
            child: Center(
              child: title != null
                  ? Text(title!, style: context.textStyles.titleLarge)
                  : const SizedBox.shrink(),
            ),
          ),
          Row(mainAxisSize: MainAxisSize.min, children: trailing),
        ],
      ),
    );
  }
}
