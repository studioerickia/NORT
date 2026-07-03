import 'package:flutter/material.dart';

import '../extensions/nort_theme_context_x.dart';

/// Enquadra o app num frame de largura fixa (estilo celular) quando a
/// viewport é mais larga que um celular — ou seja, sempre que o NORT
/// está sendo visto no navegador em desktop.
///
/// Existe por decisão explícita de fase de projeto: enquanto o foco é
/// validar UX/design/navegação em Flutter Web (não em dispositivo
/// físico), o app **não deve esticar para preencher a tela toda** —
/// isso quebraria toda a linguagem visual "app mobile" que construímos
/// desde a Etapa 2. Em telas estreitas (mobile real, ou janela do
/// navegador redimensionada), o frame desaparece e o conteúdo ocupa a
/// largura inteira normalmente — nenhum comportamento muda em mobile.
///
/// Aplicado uma única vez, em `app.dart` via `MaterialApp.builder` —
/// nenhuma tela precisa saber que isso existe.
class ResponsiveWebFrame extends StatelessWidget {
  const ResponsiveWebFrame({super.key, required this.child});

  final Widget child;

  /// Acima disso, consideramos "não é mais um celular" e ativamos o
  /// frame. Alinhado ao breakpoint `compact` do Material 3 (ADR
  /// seção 11) — mantém consistência com o resto do sistema de
  /// responsividade quando ele for expandido em etapas futuras.
  static const double _mobileBreakpoint = 600;

  /// Largura do frame — próxima de um iPhone padrão, para a Blue e a
  /// Component Library serem vistas do jeito que foram desenhadas.
  static const double _frameWidth = 430;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _mobileBreakpoint) {
          return child;
        }

        final colors = context.colors;
        return ColoredBox(
          // Fundo neutro atrás do frame — nunca a cor de marca (Calm
          // UI: cor com função, não decoração), só um contraste sutil
          // pra separar "app" de "resto da tela do navegador".
          color: colors.border,
          child: Center(
            child: SizedBox(
              width: _frameWidth,
              child: ClipRect(child: child),
            ),
          ),
        );
      },
    );
  }
}
