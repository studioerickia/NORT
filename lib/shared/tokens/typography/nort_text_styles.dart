import 'package:flutter/material.dart';

import 'nort_type_scale.dart';

/// Monta o `TextTheme` padrão do Flutter a partir de [NortTypeScale].
///
/// Isto é o único lugar do projeto que combina tamanho + peso +
/// altura de linha + tracking em um `TextStyle` de texto "normal"
/// (não-numérico — números financeiros usam `NortNumericStyles`).
///
/// Por que retornar `TextTheme` do Material em vez de uma classe
/// própria: widgets nativos do Flutter (`Text`, `AppBar`, `ListTile`
/// etc.) já sabem consumir `Theme.of(context).textTheme` — reaproveitar
/// esse mecanismo evita reinventar acesso a texto em toda a Component
/// Library.
TextTheme buildNortTextTheme({
  required Color primary,
  required Color secondary,
}) {
  TextStyle style({
    required double size,
    required FontWeight weight,
    required double height,
    required double tracking,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: NortTypeScale.fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: tracking,
      color: color,
    );
  }

  return TextTheme(
    displayLarge: style(
      size: NortTypeScale.sizeDisplay,
      weight: NortTypeScale.semibold,
      height: NortTypeScale.lineHeightTight,
      tracking: NortTypeScale.trackingTight,
      color: primary,
    ),
    headlineLarge: style(
      size: NortTypeScale.sizeXl,
      weight: NortTypeScale.semibold,
      height: NortTypeScale.lineHeightTight,
      tracking: NortTypeScale.trackingTight,
      color: primary,
    ),
    headlineMedium: style(
      size: NortTypeScale.sizeLg,
      weight: NortTypeScale.semibold,
      height: NortTypeScale.lineHeightSnug,
      tracking: NortTypeScale.trackingSnug,
      color: primary,
    ),
    headlineSmall: style(
      size: NortTypeScale.sizeMd,
      weight: NortTypeScale.semibold,
      height: NortTypeScale.lineHeightSnug,
      tracking: NortTypeScale.trackingSnug,
      color: primary,
    ),
    titleLarge: style(
      size: NortTypeScale.sizeMd,
      weight: NortTypeScale.medium,
      height: NortTypeScale.lineHeightSnug,
      tracking: NortTypeScale.trackingNormal,
      color: primary,
    ),
    titleMedium: style(
      size: NortTypeScale.sizeBase,
      weight: NortTypeScale.medium,
      height: NortTypeScale.lineHeightSnug,
      tracking: NortTypeScale.trackingNormal,
      color: primary,
    ),
    titleSmall: style(
      size: NortTypeScale.sizeSm,
      weight: NortTypeScale.medium,
      height: NortTypeScale.lineHeightSnug,
      tracking: NortTypeScale.trackingNormal,
      color: primary,
    ),
    bodyLarge: style(
      size: NortTypeScale.sizeBase,
      weight: NortTypeScale.regular,
      height: NortTypeScale.lineHeightRelaxed,
      tracking: NortTypeScale.trackingNormal,
      color: primary,
    ),
    bodyMedium: style(
      size: NortTypeScale.sizeSm,
      weight: NortTypeScale.regular,
      height: NortTypeScale.lineHeightRelaxed,
      tracking: NortTypeScale.trackingNormal,
      color: secondary,
    ),
    bodySmall: style(
      size: NortTypeScale.sizeXs,
      weight: NortTypeScale.regular,
      height: NortTypeScale.lineHeightRelaxed,
      tracking: NortTypeScale.trackingWide,
      color: secondary,
    ),
    labelLarge: style(
      size: NortTypeScale.sizeSm,
      weight: NortTypeScale.medium,
      height: NortTypeScale.lineHeightSnug,
      tracking: NortTypeScale.trackingWide,
      color: primary,
    ),
    labelMedium: style(
      size: NortTypeScale.sizeXs,
      weight: NortTypeScale.medium,
      height: NortTypeScale.lineHeightSnug,
      tracking: NortTypeScale.trackingWide,
      color: secondary,
    ),
    labelSmall: style(
      size: NortTypeScale.sizeXs,
      weight: NortTypeScale.regular,
      height: NortTypeScale.lineHeightSnug,
      tracking: NortTypeScale.trackingWide,
      color: secondary,
    ),
  );
}
