import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../buttons/nort_icon_button.dart';

class NortTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NortTopAppBar({
    super.key,
    this.title,
    this.onMenuTap,
    this.showBackButton = false,
    this.trailing = const [],
  });

  final String? title;
  final VoidCallback? onMenuTap;
  final bool showBackButton;
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
          if (showBackButton)
            NortIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: () => Navigator.of(context).maybePop(),
            )
          else if (onMenuTap != null)
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
