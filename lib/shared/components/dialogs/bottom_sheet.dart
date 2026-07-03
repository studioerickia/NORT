import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Wrapper de conteúdo para `showModalBottomSheet` — cantos superiores
/// arredondados, alça de arraste (grabber), padding consistente.
///
/// Não abre o bottom sheet sozinho — é o *conteúdo*, para manter a
/// decisão de "quando abrir" na feature, não no componente.
///
/// Exemplo:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   backgroundColor: Colors.transparent,
///   builder: (_) => NortBottomSheet(child: Text('Conteúdo')),
/// );
/// ```
class NortBottomSheet extends StatelessWidget {
  const NortBottomSheet({super.key, required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.radii;

    return Container(
      padding: EdgeInsets.fromLTRB(spacing.lg, spacing.sm, spacing.lg, spacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radii.xl),
          topRight: Radius.circular(radii.xl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: EdgeInsets.only(bottom: spacing.md),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(radii.pill),
                ),
              ),
            ),
            if (title != null) ...[
              Text(title!, style: context.textStyles.headlineSmall),
              SizedBox(height: spacing.md),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
