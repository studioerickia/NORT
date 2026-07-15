import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Seletor de abas simples — texto + sublinhado sutil no item ativo
/// (ver imagens de referência: "Ativas · Concluídas · Sonhos" em
/// Metas). Sem indicador de fundo colorido — Calm UI.
///
/// Exemplo:
/// ```dart
/// NortTabBar(tabs: const ['Ativas', 'Concluídas', 'Sonhos'], selectedIndex: 0, onChanged: (i) {})
/// ```
class NortTabBar extends StatelessWidget {
  const NortTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final motion = context.motion;

    return Row(
      children: [
        for (int i = 0; i < tabs.length; i++)
          Padding(
            padding: EdgeInsets.only(right: spacing.lg),
            child: GestureDetector(
              onTap: () => onChanged(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedDefaultTextStyle(
                duration: motion.micro,
                style: (i == selectedIndex
                        ? context.textStyles.titleSmall
                        : context.textStyles.bodyMedium)!
                    .copyWith(
                  color: i == selectedIndex
                      ? colors.textPrimary
                      : colors.textTertiary,
                ),
                child: Column(
                  children: [
                    Text(tabs[i]),
                    SizedBox(height: spacing.xs),
                    AnimatedContainer(
                      duration: motion.micro,
                      height: 2,
                      width: 20,
                      color: i == selectedIndex
                          ? colors.brand.defaultColor
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
