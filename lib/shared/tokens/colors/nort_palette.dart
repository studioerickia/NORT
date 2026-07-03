import 'package:flutter/material.dart';

/// Paleta bruta de cores do NORT — os "swatches" fonte da verdade.
///
/// **Nunca usar esta classe diretamente em telas ou componentes.**
/// Ela existe só para alimentar [NortColors] (tokens semânticos).
/// Nenhum widget deve importar `NortPalette` — se isso acontecer em
/// code review, é sinal de que falta um token semântico, não uma
/// desculpa para usar a cor crua.
///
/// Critérios de escolha (ver ADR Sprint 0, seções 5 e 6):
/// - Neutros com leve subtom azulado — nunca cinza puro, para casar
///   com o "oceano" da Blue e evitar frieza de dashboard.
/// - Azul de marca único, reservado para a Blue e ações primárias.
/// - Verde reservado exclusivamente para positivo/progresso.
/// - Âmbar e vermelho propositalmente dessaturados — o NORT nunca
///   deve parecer um app bancário alarmista.
abstract final class NortPalette {
  // ---------------------------------------------------------------------
  // Neutros — subtom azulado muito sutil (não são cinzas "frios")
  // ---------------------------------------------------------------------
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF7F8FA);
  static const Color neutral100 = Color(0xFFEEF1F4);
  static const Color neutral200 = Color(0xFFE3E7EC);
  static const Color neutral300 = Color(0xFFCBD2DA);
  static const Color neutral400 = Color(0xFF9AA5B1);
  static const Color neutral500 = Color(0xFF6B7684);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF333E4C);
  static const Color neutral800 = Color(0xFF1F2733);
  static const Color neutral850 = Color(0xFF171D26);
  static const Color neutral900 = Color(0xFF12161C);

  // ---------------------------------------------------------------------
  // Azul de marca — a cor da Blue. Único azul do sistema.
  // ---------------------------------------------------------------------
  static const Color blue50 = Color(0xFFEAF1FF);
  static const Color blue100 = Color(0xFFD2E2FF);
  static const Color blue300 = Color(0xFF8FB4FF);
  static const Color blue500 = Color(0xFF4F7FFF);
  static const Color blue600 = Color(0xFF3D68E0);
  static const Color blue700 = Color(0xFF2E51B3);

  // ---------------------------------------------------------------------
  // Verde — positivo / progresso / conquista. Nunca decorativo.
  // ---------------------------------------------------------------------
  static const Color green50 = Color(0xFFE8F5EE);
  static const Color green100 = Color(0xFFC9E9D7);
  static const Color green300 = Color(0xFF7FC9A0);
  static const Color green500 = Color(0xFF3E9C6C);
  static const Color green600 = Color(0xFF2F7D55);
  static const Color green700 = Color(0xFF235E40);

  // ---------------------------------------------------------------------
  // Âmbar — atenção leve. Nunca "alerta bancário".
  // ---------------------------------------------------------------------
  static const Color amber50 = Color(0xFFFFF6E6);
  static const Color amber300 = Color(0xFFFFD98F);
  static const Color amber500 = Color(0xFFF2A93C);
  static const Color amber700 = Color(0xFFB97815);

  // ---------------------------------------------------------------------
  // Vermelho — erro/destrutivo. Dessaturado de propósito.
  // ---------------------------------------------------------------------
  static const Color red50 = Color(0xFFFDECEC);
  static const Color red300 = Color(0xFFF1A9A9);
  static const Color red500 = Color(0xFFE0615F);
  static const Color red700 = Color(0xFFA83E3D);
}
