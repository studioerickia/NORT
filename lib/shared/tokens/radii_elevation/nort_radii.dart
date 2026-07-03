import 'package:flutter/material.dart';

/// Escala de border radius do NORT (ADR seção 5).
///
/// Cards recebem radius generoso (16–24) — reforça a sensação
/// "app de bem-estar". Inputs e botões recebem radius menor (12) —
/// mantém a interação legível sem parecer "pilulado" demais.
/// `pill` existe só para chips/badges totalmente arredondados
/// (ex.: `SuggestionChip` da Blue).
@immutable
class NortRadii extends ThemeExtension<NortRadii> {
  const NortRadii({
    this.sm = 12,
    this.md = 16,
    this.lg = 20,
    this.xl = 24,
    this.pill = 999,
  });

  /// Botões, inputs, chips retangulares.
  final double sm;

  /// Cards padrão.
  final double md;

  /// Cards de destaque (ex.: card de limite diário).
  final double lg;

  /// Superfícies grandes (bottom sheets, dialogs).
  final double xl;

  /// Totalmente arredondado — chips/badges tipo pílula.
  final double pill;

  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get mdRadius => BorderRadius.circular(md);
  BorderRadius get lgRadius => BorderRadius.circular(lg);
  BorderRadius get xlRadius => BorderRadius.circular(xl);
  BorderRadius get pillRadius => BorderRadius.circular(pill);

  @override
  NortRadii copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? pill,
  }) {
    return NortRadii(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      pill: pill ?? this.pill,
    );
  }

  // Radius não varia entre temas.
  @override
  NortRadii lerp(ThemeExtension<NortRadii>? other, double t) => this;
}
