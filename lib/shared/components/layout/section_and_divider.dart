import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Bloco estrutural — agrupa um cabeçalho opcional (`header`, ex.:
/// `SectionHeader`) com o conteúdo, aplicando o espaçamento vertical
/// padrão entre seções em toda tela do NORT.
///
/// Existe para que nenhuma tela precise decidir "quanto espaço entre
/// seções" na mão — é sempre `spacing.xl`.
///
/// Exemplo:
/// ```dart
/// Section(header: SectionHeader(title: 'Resumo do dia'), child: Row(...))
/// ```
class Section extends StatelessWidget {
  const Section({super.key, this.header, required this.child});

  final Widget? header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[header!, SizedBox(height: spacing.md)],
          child,
        ],
      ),
    );
  }
}

/// Divisor — linha de 1px na cor `border`. Usado com moderação: Calm
/// UI prioriza espaço em branco sobre linha divisória sempre que os
/// dois cumprem a mesma função de separação.
///
/// Exemplo:
/// ```dart
/// NortDivider()
/// ```
class NortDivider extends StatelessWidget {
  const NortDivider({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      color: context.colors.border,
    );
  }
}
