import 'package:flutter/material.dart';

/// Tokens de movimento do NORT (ADR seção 8 — Motion System).
///
/// Regra dura: nenhuma animação no app deve passar de 400ms — acima
/// disso o produto "parece pesado" e quebra a sensação de leveza que
/// é o diferencial de marca do NORT frente a apps bancários.
///
/// Curvas propositalmente sem "bounce": `easeOutCubic`/`easeInCubic`
/// em vez das curvas padrão do Material, para um feel mais
/// Apple/Calm do que "app de produtividade genérico".
///
/// Mesmos valores em light e dark — movimento não é uma propriedade
/// visual de tema.
@immutable
class NortMotion extends ThemeExtension<NortMotion> {
  const NortMotion({
    this.micro = const Duration(milliseconds: 120),
    this.standard = const Duration(milliseconds: 240),
    this.screen = const Duration(milliseconds: 360),
    this.enter = Curves.easeOutCubic,
    this.exit = Curves.easeInCubic,
  });

  /// Microinterações — toque em ícone, troca de estado de um chip.
  final Duration micro;

  /// Padrão — a maioria das transições de componente (fade+scale de
  /// card, abertura de dialog).
  final Duration standard;

  /// Transições de tela inteira.
  final Duration screen;

  /// Curva de entrada — elementos aparecendo.
  final Curve enter;

  /// Curva de saída — elementos desaparecendo.
  final Curve exit;

  @override
  NortMotion copyWith({
    Duration? micro,
    Duration? standard,
    Duration? screen,
    Curve? enter,
    Curve? exit,
  }) {
    return NortMotion(
      micro: micro ?? this.micro,
      standard: standard ?? this.standard,
      screen: screen ?? this.screen,
      enter: enter ?? this.enter,
      exit: exit ?? this.exit,
    );
  }

  // Movimento não varia entre temas.
  @override
  NortMotion lerp(ThemeExtension<NortMotion>? other, double t) => this;
}
