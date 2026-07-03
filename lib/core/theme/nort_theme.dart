import 'package:flutter/material.dart';

import '../../shared/tokens/tokens.dart';

/// Ponto único de montagem dos temas do NORT.
///
/// Nenhuma tela ou componente deve construir `ThemeData` manualmente
/// — tudo passa por `NortTheme.light` / `NortTheme.dark`, injetados
/// em `MaterialApp` (etapa de Navegação).
///
/// A montagem tem dois objetivos simultâneos:
/// 1. Popular o `ColorScheme` nativo do Material, para que widgets
///    padrão do Flutter (e pacotes de terceiros) se comportem bem
///    mesmo sem conhecer os tokens do NORT.
/// 2. Registrar os `ThemeExtension`s do NORT (`NortColors`,
///    `NortSpacing`, `NortRadii`, `NortShadows`, `NortMotion`,
///    `NortNumericStyles`) — a fonte da verdade real para a
///    Component Library.
abstract final class NortTheme {
  static ThemeData get light => _build(
    brightness: Brightness.light,
    colors: NortColors.light(),
    shadows: NortShadows.light(),
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    colors: NortColors.dark(),
    shadows: NortShadows.dark(),
  );

  static ThemeData _build({
    required Brightness brightness,
    required NortColors colors,
    required NortShadows shadows,
  }) {
    final textTheme = buildNortTextTheme(
      primary: colors.textPrimary,
      secondary: colors.textSecondary,
    );

    final numericStyles = NortNumericStyles.from(colors.textPrimary);

    // Usamos as factories `ColorScheme.light()`/`.dark()` — não o
    // construtor "cru" — porque elas já vêm com valores default
    // sensatos para todos os campos que o NORT não customiza
    // (primaryContainer, outlineVariant, scrim etc.), evitando ter
    // que preencher manualmente uma lista grande de parâmetros só
    // para satisfazer o compilador.
    final colorSchemeBase = brightness == Brightness.light
        ? const ColorScheme.light()
        : const ColorScheme.dark();

    final colorScheme = colorSchemeBase.copyWith(
      primary: colors.brand.defaultColor,
      onPrimary: colors.textOnBrand,
      secondary: colors.positive.defaultColor,
      onSecondary: colors.textOnBrand,
      error: colors.danger,
      onError: colors.textOnBrand,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      outline: colors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      textTheme: textTheme,
      fontFamily: NortTypeScale.fontFamily,

      // Sensação Apple/Calm: sem ripple do Material, sem highlight
      // agressivo — feedback tátil vem de Haptics (Motion System),
      // não de tinta se espalhando na tela.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,

      dividerColor: colors.border,

      extensions: <ThemeExtension<dynamic>>[
        colors,
        const NortSpacing(),
        const NortRadii(),
        shadows,
        const NortMotion(),
        numericStyles,
      ],
    );
  }
}
