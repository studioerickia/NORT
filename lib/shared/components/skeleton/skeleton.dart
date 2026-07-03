import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Bloco de skeleton — retângulo com shimmer sutil, usado para
/// representar conteúdo carregando (ex.: card de meta antes do dado
/// real chegar).
///
/// Shimmer deliberadamente discreto (baixa amplitude de opacidade) —
/// skeletons chamativos contradizem a filosofia Calm UI.
///
/// Exemplo:
/// ```dart
/// NortSkeleton(width: double.infinity, height: 16)
/// NortSkeleton.circle(size: 40)
/// ```
class NortSkeleton extends StatefulWidget {
  const NortSkeleton({super.key, this.width, required this.height, this.radius})
      : shape = BoxShape.rectangle;

  const NortSkeleton.circle({super.key, required double size})
      : width = size,
        height = size,
        radius = null,
        shape = BoxShape.circle;

  final double? width;
  final double height;
  final double? radius;
  final BoxShape shape;

  @override
  State<NortSkeleton> createState() => _NortSkeletonState();
}

class _NortSkeletonState extends State<NortSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.6 + (_controller.value * 0.2);
        return Opacity(
          opacity: opacity,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: colors.border,
              shape: widget.shape,
              borderRadius: widget.shape == BoxShape.rectangle
                  ? BorderRadius.circular(widget.radius ?? radii.sm)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
