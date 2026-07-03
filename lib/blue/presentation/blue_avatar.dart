import 'package:flutter/material.dart';

import '../../core/extensions/nort_theme_context_x.dart';
import 'blue_glow.dart';
import 'blue_state.dart';
import 'blue_state_visuals.dart';

/// Avatar da Blue — widget central que qualquer feature usa para
/// "mostrar a Blue" em algum lugar (bolha de chat, header da Home,
/// tela de Life OS).
///
/// Recebe um [BlueState] e delega para o visual placeholder
/// correspondente. Nenhuma feature deve construir `BlueIdle`,
/// `BlueThinking` etc. diretamente — sempre via `BlueAvatar`, para
/// que a troca de estado no futuro (governada por `blue/domain/brain`)
/// tenha um único ponto de entrada visual.
///
/// `heroTag`: quando fornecido, envolve o avatar em um `Hero` — usado
/// na transição Home → Chat (ADR seção 8: "ela é a mesma 'entidade'
/// atravessando telas"). Ambas as telas devem usar a mesma tag para o
/// Hero funcionar; ver `core/routing` para a constante compartilhada.
///
/// Exemplo:
/// ```dart
/// BlueAvatar(state: BlueState.idle, size: 160)
/// BlueAvatar(state: BlueState.idle, size: 40, heroTag: 'blue-avatar')
/// ```
class BlueAvatar extends StatelessWidget {
  const BlueAvatar({
    super.key,
    required this.state,
    this.size = 64,
    this.showGlow = true,
    this.heroTag,
  });

  final BlueState state;
  final double size;

  /// Em contextos compactos (ex.: avatar dentro de uma bolha de chat
  /// pequena), o halo do oceano é dispensável — só o ícone/estado.
  final bool showGlow;

  /// Tag do `Hero` para transição entre telas. `null` = sem Hero.
  final Object? heroTag;

  Widget _visualForState(BuildContext context) {
    switch (state) {
      case BlueState.idle:
        return BlueIdle(size: size);
      case BlueState.thinking:
        return BlueThinking(size: size);
      case BlueState.listening:
        return BlueListening(size: size);
      case BlueState.celebrating:
        return BlueCelebrating(size: size);
      case BlueState.speaking:
        // Placeholder desta etapa: mesmo visual de "idle", levemente
        // realçado — sem lógica de fala real ainda.
        return BlueIdle(size: size);
      case BlueState.concerned:
        return Icon(
          Icons.info_outline,
          size: size * 0.45,
          color: context.colors.warning,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visual = _visualForState(context);

    final content = !showGlow
        ? SizedBox(width: size, height: size, child: Center(child: visual))
        : BlueGlow(size: size, child: visual);

    if (heroTag == null) return content;

    return Hero(tag: heroTag!, child: content);
  }
}
