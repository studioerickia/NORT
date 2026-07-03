import 'package:flutter/material.dart';

/// Tokens de sombra do NORT (ADR seção 5 e 6).
///
/// Light theme: sombras muito suaves e difusas — nunca sombra dura.
/// Dark theme: elevação é resolvida por **camadas de cinza**
/// (`NortColors.surfaceElevated` mais claro que `background`), não
/// por sombra — sombra praticamente some visualmente sobre fundo
/// escuro, então insistir nela é desperdício de render e imprecisão
/// visual. Por isso os níveis no dark ficam quase vazios.
@immutable
class NortShadows extends ThemeExtension<NortShadows> {
  const NortShadows({
    required this.none,
    required this.low,
    required this.medium,
    required this.high,
  });

  /// Sem elevação — superfícies "no nível do fundo".
  final List<BoxShadow> none;

  /// Cards em repouso.
  final List<BoxShadow> low;

  /// Cards em destaque / hover.
  final List<BoxShadow> medium;

  /// Elementos flutuantes (FAB, sheets abrindo).
  final List<BoxShadow> high;

  factory NortShadows.light() {
    return const NortShadows(
      none: [],
      low: [
        BoxShadow(
          color: Color(0x0A1F2733), // neutral800 a ~4% de opacidade
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
      medium: [
        BoxShadow(
          color: Color(0x0F1F2733), // ~6%
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
      high: [
        BoxShadow(
          color: Color(0x141F2733), // ~8%
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  factory NortShadows.dark() {
    return const NortShadows(
      none: [],
      low: [],
      medium: [],
      // Só o nível "high" (elementos flutuantes) recebe uma sombra
      // residual no dark — muito sutil, só para separar do fundo em
      // telas realmente sem contraste de camada suficiente.
      high: [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  @override
  NortShadows copyWith({
    List<BoxShadow>? none,
    List<BoxShadow>? low,
    List<BoxShadow>? medium,
    List<BoxShadow>? high,
  }) {
    return NortShadows(
      none: none ?? this.none,
      low: low ?? this.low,
      medium: medium ?? this.medium,
      high: high ?? this.high,
    );
  }

  @override
  NortShadows lerp(ThemeExtension<NortShadows>? other, double t) {
    if (other is! NortShadows) return this;
    // BoxShadow.lerpList lida com listas de tamanhos diferentes
    // (ex.: dark tem listas vazias) sem lançar exceção.
    return NortShadows(
      none: BoxShadow.lerpList(none, other.none, t) ?? const [],
      low: BoxShadow.lerpList(low, other.low, t) ?? const [],
      medium: BoxShadow.lerpList(medium, other.medium, t) ?? const [],
      high: BoxShadow.lerpList(high, other.high, t) ?? const [],
    );
  }
}
