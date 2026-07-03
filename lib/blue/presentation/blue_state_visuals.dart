import 'package:flutter/material.dart';

import '../../core/extensions/nort_theme_context_x.dart';

/// Placeholder visual do estado `idle` — forma estática simples.
/// Substituído por ilustração/Lottie real quando a Blue ganhar arte
/// definitiva (ver ADR seção 9 e 12 — `assets/lottie/` já reservado).
class BlueIdle extends StatelessWidget {
  const BlueIdle({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Icon(
      Icons.water_drop_outlined,
      size: size * 0.5,
      color: colors.brand.defaultColor,
    );
  }
}

/// Placeholder visual do estado `thinking` — três pontos pulsando.
/// Reaproveita a mesma ideia de `TypingIndicator`, mas centrada no
/// próprio avatar (sem bolha de chat ao redor).
class BlueThinking extends StatefulWidget {
  const BlueThinking({super.key, required this.size});

  final double size;

  @override
  State<BlueThinking> createState() => _BlueThinkingState();
}

class _BlueThinkingState extends State<BlueThinking>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (t + i * 0.33) % 1.0;
            final scale = 0.6 + 0.4 * (0.5 - (phase - 0.5).abs()) * 2;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale.clamp(0.6, 1.0),
                child: Container(
                  width: widget.size * 0.12,
                  height: widget.size * 0.12,
                  decoration: BoxDecoration(
                    color: colors.brand.defaultColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Placeholder visual do estado `listening` — anel pulsando ao redor
/// de um ponto central (sugere captação de áudio).
class BlueListening extends StatefulWidget {
  const BlueListening({super.key, required this.size});

  final double size;

  @override
  State<BlueListening> createState() => _BlueListeningState();
}

class _BlueListeningState extends State<BlueListening>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final ringScale = 0.6 + _controller.value * 0.4;
        final ringOpacity = 1 - _controller.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: ringScale,
              child: Opacity(
                opacity: ringOpacity,
                child: Container(
                  width: widget.size * 0.7,
                  height: widget.size * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.brand.defaultColor, width: 2),
                  ),
                ),
              ),
            ),
            Icon(Icons.mic_none, size: widget.size * 0.4, color: colors.brand.defaultColor),
          ],
        );
      },
    );
  }
}

/// Placeholder visual do estado `celebrating` — pequeno "pulo" de
/// escala com ícone de conquista. Curva com leve overshoot é a única
/// exceção deliberada à regra "sem bounce" do Motion System — reservada
/// só para o instante de celebração (ex.: meta concluída), nunca para
/// interações comuns.
class BlueCelebrating extends StatefulWidget {
  const BlueCelebrating({super.key, required this.size});

  final double size;

  @override
  State<BlueCelebrating> createState() => _BlueCelebratingState();
}

class _BlueCelebratingState extends State<BlueCelebrating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ScaleTransition(
      scale: _scale,
      child: Icon(Icons.celebration_outlined, size: widget.size * 0.5, color: colors.positive.defaultColor),
    );
  }
}
