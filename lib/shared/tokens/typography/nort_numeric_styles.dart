import 'package:flutter/material.dart';

import 'nort_type_scale.dart';

/// Estilos de texto exclusivos para **números financeiros** (saldo,
/// valores de meta, limites) — separados do `TextTheme` padrão porque
/// carregam uma exigência que texto comum não tem: `tabularFigures`,
/// para os dígitos não "pularem" de largura quando um saldo atualiza
/// (ADR seção 5).
///
/// Uso: qualquer widget que exiba um valor monetário usa
/// `context.numericStyles.large/medium/small` — nunca `TextTheme`
/// comum para esse fim.
@immutable
class NortNumericStyles extends ThemeExtension<NortNumericStyles> {
  const NortNumericStyles({
    required this.large,
    required this.medium,
    required this.small,
  });

  /// Ex.: "R$84" em destaque no card de limite diário.
  final TextStyle large;

  /// Ex.: valores em `SummaryStatCard`.
  final TextStyle medium;

  /// Ex.: valores inline em listas de transação.
  final TextStyle small;

  factory NortNumericStyles.from(Color color) {
    TextStyle style(double size, FontWeight weight) {
      return TextStyle(
        fontFamily: NortTypeScale.fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: NortTypeScale.lineHeightTight,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
    }

    return NortNumericStyles(
      large: style(NortTypeScale.sizeXl, NortTypeScale.semibold),
      medium: style(NortTypeScale.sizeLg, NortTypeScale.semibold),
      small: style(NortTypeScale.sizeBase, NortTypeScale.medium),
    );
  }

  @override
  NortNumericStyles copyWith({
    TextStyle? large,
    TextStyle? medium,
    TextStyle? small,
  }) {
    return NortNumericStyles(
      large: large ?? this.large,
      medium: medium ?? this.medium,
      small: small ?? this.small,
    );
  }

  @override
  NortNumericStyles lerp(ThemeExtension<NortNumericStyles>? other, double t) {
    if (other is! NortNumericStyles) return this;
    return NortNumericStyles(
      large: TextStyle.lerp(large, other.large, t)!,
      medium: TextStyle.lerp(medium, other.medium, t)!,
      small: TextStyle.lerp(small, other.small, t)!,
    );
  }
}
