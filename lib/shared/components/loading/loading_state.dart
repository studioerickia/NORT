import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Estado de carregamento em tela cheia/seção — spinner discreto,
/// sem texto por padrão (Calm UI: não anunciar o óbvio). `message` é
/// opcional para casos onde o carregamento é longo o suficiente para
/// justificar contexto.
///
/// Exemplo:
/// ```dart
/// LoadingState()
/// LoadingState(message: 'Carregando suas metas...')
/// ```
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(colors.brand.defaultColor),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: spacing.md),
            Text(message!, style: context.textStyles.bodyMedium),
          ],
        ],
      ),
    );
  }
}
