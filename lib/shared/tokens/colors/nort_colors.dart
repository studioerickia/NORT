import 'package:flutter/material.dart';

import 'nort_palette.dart';

/// Um papel de cor interativa, com os 4 estados exigidos pelo ADR
/// (seção 5): `default / hover / pressed / disabled`.
///
/// Usado para as duas únicas cores do sistema que carregam significado
/// de ação — marca (Blue) e positivo — e que por isso precisam de
/// resposta visual consistente em toda a Component Library.
@immutable
class NortInteractiveColor {
  const NortInteractiveColor({
    required this.defaultColor,
    required this.hover,
    required this.pressed,
    required this.disabled,
  });

  final Color defaultColor;
  final Color hover;
  final Color pressed;
  final Color disabled;

  static NortInteractiveColor lerp(
    NortInteractiveColor a,
    NortInteractiveColor b,
    double t,
  ) {
    return NortInteractiveColor(
      defaultColor: Color.lerp(a.defaultColor, b.defaultColor, t)!,
      hover: Color.lerp(a.hover, b.hover, t)!,
      pressed: Color.lerp(a.pressed, b.pressed, t)!,
      disabled: Color.lerp(a.disabled, b.disabled, t)!,
    );
  }
}

/// Tokens semânticos de cor do NORT — a única forma permitida de
/// consumir cor em telas e componentes.
///
/// Acesso em qualquer widget:
/// ```dart
/// final colors = Theme.of(context).extension<NortColors>()!;
/// // ou, preferencialmente, via context.colors (ver core/extensions)
/// ```
///
/// Cada campo aqui responde "para que serve essa cor", nunca "qual é
/// o hex" — isso é o que permite trocar toda a paleta (rebrand, tema
/// sazonal, tema premium) sem tocar em nenhuma tela, conforme ADR
/// seção 18.3.
@immutable
class NortColors extends ThemeExtension<NortColors> {
  const NortColors({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnBrand,
    required this.brand,
    required this.positive,
    required this.positiveSurface,
    required this.warning,
    required this.warningSurface,
    required this.danger,
    required this.dangerSurface,
    required this.chatBubbleUser,
    required this.chatBubbleUserText,
    required this.chatBubbleBlue,
    required this.chatBubbleBlueText,
    required this.oceanGradientStart,
    required this.oceanGradientEnd,
    required this.overlayGlass,
  });

  /// Fundo da tela — nunca branco/preto puro (ver ADR seção 6).
  final Color background;

  /// Fundo de cards e superfícies elevadas em repouso.
  final Color surface;

  /// Fundo de superfícies "flutuantes" (bottom sheets, dialogs) — no
  /// dark theme, é uma camada de cinza mais clara que `surface`
  /// (elevação por camada, não por sombra — ADR seção 6).
  final Color surfaceElevated;

  /// Bordas e divisores sutis.
  final Color border;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  /// Texto sobre uma superfície pintada com `brand.defaultColor`.
  final Color textOnBrand;

  /// Azul de marca — reservado para a Blue e ações primárias. Nunca
  /// usado para preencher grandes áreas (ADR seção 6).
  final NortInteractiveColor brand;

  /// Verde — positivo, progresso, conquista. Nunca decorativo.
  final NortInteractiveColor positive;
  final Color positiveSurface;

  final Color warning;
  final Color warningSurface;

  final Color danger;
  final Color dangerSurface;

  /// Bolha de chat do usuário (ver imagem de referência — tom verde
  /// muito claro, não neutro).
  final Color chatBubbleUser;
  final Color chatBubbleUserText;

  /// Bolha de chat da Blue.
  final Color chatBubbleBlue;
  final Color chatBubbleBlueText;

  /// Gradiente radial do "oceano" atrás da Blue — único uso de
  /// gradiente permitido no sistema (ADR seção 5).
  final Color oceanGradientStart;
  final Color oceanGradientEnd;

  /// Tint usado por baixo do efeito de blur/glass em overlays.
  final Color overlayGlass;

  factory NortColors.light() {
    return const NortColors(
      background: NortPalette.neutral50,
      surface: NortPalette.neutral0,
      surfaceElevated: NortPalette.neutral0,
      border: NortPalette.neutral200,
      textPrimary: NortPalette.neutral800,
      textSecondary: NortPalette.neutral600,
      textTertiary: NortPalette.neutral400,
      textOnBrand: NortPalette.neutral0,
      brand: NortInteractiveColor(
        defaultColor: NortPalette.blue500,
        hover: NortPalette.blue600,
        pressed: NortPalette.blue700,
        disabled: NortPalette.blue100,
      ),
      positive: NortInteractiveColor(
        defaultColor: NortPalette.green500,
        hover: NortPalette.green600,
        pressed: NortPalette.green700,
        disabled: NortPalette.green100,
      ),
      positiveSurface: NortPalette.green50,
      warning: NortPalette.amber500,
      warningSurface: NortPalette.amber50,
      danger: NortPalette.red500,
      dangerSurface: NortPalette.red50,
      chatBubbleUser: NortPalette.green50,
      chatBubbleUserText: NortPalette.neutral800,
      chatBubbleBlue: NortPalette.neutral0,
      chatBubbleBlueText: NortPalette.neutral800,
      oceanGradientStart: NortPalette.blue50,
      oceanGradientEnd: NortPalette.neutral0,
      overlayGlass: NortPalette.neutral0,
    );
  }

  factory NortColors.dark() {
    return const NortColors(
      background: NortPalette.neutral900,
      surface: NortPalette.neutral850,
      surfaceElevated: NortPalette.neutral700,
      border: NortPalette.neutral700,
      textPrimary: NortPalette.neutral50,
      textSecondary: NortPalette.neutral300,
      textTertiary: NortPalette.neutral500,
      textOnBrand: NortPalette.neutral0,
      brand: NortInteractiveColor(
        // Mais luminoso que no light theme, para manter contraste AA
        // sobre fundo escuro (ADR seção 6).
        defaultColor: NortPalette.blue300,
        hover: NortPalette.blue100,
        pressed: NortPalette.blue500,
        disabled: NortPalette.blue700,
      ),
      positive: NortInteractiveColor(
        defaultColor: NortPalette.green300,
        hover: NortPalette.green100,
        pressed: NortPalette.green500,
        disabled: NortPalette.green700,
      ),
      positiveSurface: NortPalette.green700,
      warning: NortPalette.amber300,
      warningSurface: NortPalette.amber700,
      danger: NortPalette.red300,
      dangerSurface: NortPalette.red700,
      chatBubbleUser: NortPalette.green700,
      chatBubbleUserText: NortPalette.neutral50,
      chatBubbleBlue: NortPalette.neutral800,
      chatBubbleBlueText: NortPalette.neutral50,
      oceanGradientStart: NortPalette.blue700,
      oceanGradientEnd: NortPalette.neutral900,
      overlayGlass: NortPalette.neutral800,
    );
  }

  @override
  NortColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textOnBrand,
    NortInteractiveColor? brand,
    NortInteractiveColor? positive,
    Color? positiveSurface,
    Color? warning,
    Color? warningSurface,
    Color? danger,
    Color? dangerSurface,
    Color? chatBubbleUser,
    Color? chatBubbleUserText,
    Color? chatBubbleBlue,
    Color? chatBubbleBlueText,
    Color? oceanGradientStart,
    Color? oceanGradientEnd,
    Color? overlayGlass,
  }) {
    return NortColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnBrand: textOnBrand ?? this.textOnBrand,
      brand: brand ?? this.brand,
      positive: positive ?? this.positive,
      positiveSurface: positiveSurface ?? this.positiveSurface,
      warning: warning ?? this.warning,
      warningSurface: warningSurface ?? this.warningSurface,
      danger: danger ?? this.danger,
      dangerSurface: dangerSurface ?? this.dangerSurface,
      chatBubbleUser: chatBubbleUser ?? this.chatBubbleUser,
      chatBubbleUserText: chatBubbleUserText ?? this.chatBubbleUserText,
      chatBubbleBlue: chatBubbleBlue ?? this.chatBubbleBlue,
      chatBubbleBlueText: chatBubbleBlueText ?? this.chatBubbleBlueText,
      oceanGradientStart: oceanGradientStart ?? this.oceanGradientStart,
      oceanGradientEnd: oceanGradientEnd ?? this.oceanGradientEnd,
      overlayGlass: overlayGlass ?? this.overlayGlass,
    );
  }

  @override
  NortColors lerp(ThemeExtension<NortColors>? other, double t) {
    if (other is! NortColors) return this;
    return NortColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      brand: NortInteractiveColor.lerp(brand, other.brand, t),
      positive: NortInteractiveColor.lerp(positive, other.positive, t),
      positiveSurface: Color.lerp(positiveSurface, other.positiveSurface, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSurface: Color.lerp(warningSurface, other.warningSurface, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSurface: Color.lerp(dangerSurface, other.dangerSurface, t)!,
      chatBubbleUser: Color.lerp(chatBubbleUser, other.chatBubbleUser, t)!,
      chatBubbleUserText: Color.lerp(
        chatBubbleUserText,
        other.chatBubbleUserText,
        t,
      )!,
      chatBubbleBlue: Color.lerp(chatBubbleBlue, other.chatBubbleBlue, t)!,
      chatBubbleBlueText: Color.lerp(
        chatBubbleBlueText,
        other.chatBubbleBlueText,
        t,
      )!,
      oceanGradientStart: Color.lerp(
        oceanGradientStart,
        other.oceanGradientStart,
        t,
      )!,
      oceanGradientEnd: Color.lerp(
        oceanGradientEnd,
        other.oceanGradientEnd,
        t,
      )!,
      overlayGlass: Color.lerp(overlayGlass, other.overlayGlass, t)!,
    );
  }
}
