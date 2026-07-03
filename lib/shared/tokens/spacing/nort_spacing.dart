import 'package:flutter/material.dart';

/// Escala de espaçamento do NORT — base 4, idêntica em light e dark
/// (espaçamento não é uma propriedade visual que muda com o tema).
///
/// Modelada como `ThemeExtension` mesmo sendo estática, para que o
/// acesso na Component Library seja uniforme com os demais tokens:
/// `context.spacing.md`, no mesmo padrão de `context.colors.brand`.
///
/// Escala (ADR seção 5): 4, 8, 12, 16, 24, 32, 48, 64 — mesma lógica
/// do Apple HIG / Material 3, garante ritmo visual consistente entre
/// cards e telas.
@immutable
class NortSpacing extends ThemeExtension<NortSpacing> {
  const NortSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 24,
    this.xxl = 32,
    this.xxxl = 48,
    this.huge = 64,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double huge;

  @override
  NortSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? huge,
  }) {
    return NortSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      huge: huge ?? this.huge,
    );
  }

  // Sem interpolação real: espaçamento não varia entre light/dark,
  // então a troca de tema simplesmente mantém os valores atuais.
  @override
  NortSpacing lerp(ThemeExtension<NortSpacing>? other, double t) => this;
}
