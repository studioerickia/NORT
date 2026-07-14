import 'package:flutter/material.dart';

import '../../core/extensions/nort_theme_context_x.dart';

class BlueGlow extends StatefulWidget {
  const BlueGlow({super.key, required this.size, this.child, this.animate = true});

  final double size;
  final Widget? child;
  final bool animate;

  @override
  State<BlueGlow> createState() => _BlueGlowState();
}

class _BlueGlowState extends State<BlueGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimating();
  }

  @override
  void didUpdateWidget(covariant BlueGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimating();
  }

  void _syncAnimating() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final shouldAnimate = widget.animate && !reduceMotion;

    if (shouldAnimate && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!shouldAnimate && _controller.isAnimating) {
      _controller.stop();
    }
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
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * 0.04);
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [colors.oceanGradientStart, colors.oceanGradientEnd],
          ),
        ),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}