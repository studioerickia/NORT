import 'package:flutter/material.dart';

/// Escala tipográfica bruta do NORT (ADR seção 5).
///
/// Escala modular 12/14/16/20/24/32/40 — nunca tamanhos "soltos" fora
/// desta lista. Peso concentrado em Regular/Medium/Semibold; **Bold
/// pesado nunca é usado** — foge do tom "dashboard" que o produto
/// evita deliberadamente.
///
/// Família tipográfica: nesta etapa usamos a fonte padrão da
/// plataforma (San Francisco no iOS, Roboto no Android) — nenhuma
/// fonte custom foi definida ainda. Quando uma família própria for
/// escolhida (etapa de Assets), basta preencher `fontFamily` aqui;
/// nenhuma tela ou componente precisa mudar, pois todos consomem
/// `TextTheme`/`NortNumericStyles`, nunca `TextStyle` cru.
abstract final class NortTypeScale {
  /// `null` = fonte padrão da plataforma. Ver docstring da classe.
  static const String? fontFamily = null;

  // Tamanhos (px / logical pixels)
  static const double sizeXs = 12;
  static const double sizeSm = 14;
  static const double sizeBase = 16;
  static const double sizeMd = 20;
  static const double sizeLg = 24;
  static const double sizeXl = 32;
  static const double sizeDisplay = 40;

  // Pesos — só estes três em todo o app.
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;

  // Alturas de linha (multiplicador sobre o tamanho da fonte) —
  // textos maiores recebem line-height mais apertado (padrão Apple),
  // textos pequenos recebem mais respiro para legibilidade.
  static const double lineHeightTight = 1.15;
  static const double lineHeightSnug = 1.3;
  static const double lineHeightRelaxed = 1.5;

  // Tracking (letter-spacing) — negativo sutil em títulos grandes,
  // levemente positivo em labels pequenos (legibilidade em caixa alta
  // ou tamanhos reduzidos).
  static const double trackingTight = -0.5;
  static const double trackingSnug = -0.2;
  static const double trackingNormal = 0.0;
  static const double trackingWide = 0.1;
}
