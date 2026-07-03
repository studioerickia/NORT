import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../../tokens/colors/nort_colors.dart';
import 'base_card.dart';

/// Tom semântico de um `StatusCard` — define a cor do indicador,
/// nunca do fundo do card (fundo permanece sempre neutro, Calm UI).
enum NortStatusTone { positive, warning, danger, neutral }

/// Card de status — comunica uma condição atual em uma frase curta
/// (ex.: "Tudo certo · Sem alertas", "Seu dia financeiro está
/// tranquilo"). Usa um pequeno indicador de cor, nunca preenche o
/// card inteiro com a cor semântica.
///
/// Exemplo:
/// ```dart
/// StatusCard(tone: NortStatusTone.positive, title: 'Tudo certo', description: 'Sem alertas')
/// ```
class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.tone,
    required this.title,
    this.description,
  });

  final NortStatusTone tone;
  final String title;
  final String? description;

  Color _toneColor(NortColors colors) {
    switch (tone) {
      case NortStatusTone.positive:
        return colors.positive.defaultColor;
      case NortStatusTone.warning:
        return colors.warning;
      case NortStatusTone.danger:
        return colors.danger;
      case NortStatusTone.neutral:
        return colors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final toneColor = _toneColor(colors);

    return BaseCard(
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: toneColor, shape: BoxShape.circle),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.titleSmall),
                if (description != null)
                  Text(description!, style: context.textStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
