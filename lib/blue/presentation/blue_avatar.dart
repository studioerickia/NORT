import 'package:flutter/material.dart';

import '../../core/extensions/nort_theme_context_x.dart';
import 'blue_assets.dart';
import 'blue_glow.dart';
import 'blue_state.dart';

class BlueAvatar extends StatelessWidget {
  const BlueAvatar({
    super.key,
    this.state = BlueState.idle,
    this.size = 64,
    this.showGlow = true,
    this.animate = true,
    this.semanticLabel,
    this.heroTag,
  });

  final BlueState state;
  final double size;
  final bool showGlow;
  final bool animate;
  final String? semanticLabel;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    Widget avatar = _BlueIllustration(
      state: state,
      size: size,
      animate: animate,
      showGlow: showGlow,
    );

    if (showGlow) {
      avatar = BlueGlow(size: size * 1.35, animate: animate, child: avatar);
    }

    if (heroTag != null) {
      avatar = Hero(tag: heroTag!, child: avatar);
    }

    return Semantics(
      label: semanticLabel ?? _defaultSemanticLabel(state),
      image: true,
      child: avatar,
    );
  }

  String _defaultSemanticLabel(BlueState state) {
    switch (state) {
      case BlueState.idle:
        return 'Blue, sua companheira financeira';
      case BlueState.calm:
        return 'Blue, tranquila';
      case BlueState.listening:
        return 'Blue, ouvindo você';
      case BlueState.thinking:
        return 'Blue, pensando';
      case BlueState.speaking:
        return 'Blue, falando';
      case BlueState.celebrating:
        return 'Blue, comemorando com você';
      case BlueState.reassuring:
        return 'Blue, tranquilizando você';
      case BlueState.curious:
        return 'Blue, curiosa';
      case BlueState.concerned:
        return 'Blue, atenta';
      case BlueState.sleeping:
        return 'Blue, em repouso';
    }
  }
}

class _BlueIllustration extends StatefulWidget {
  const _BlueIllustration({
    required this.state,
    required this.size,
    required this.animate,
    required this.showGlow,
  });

  final BlueState state;
  final double size;
  final bool animate;
  final bool showGlow;

  @override
  State<_BlueIllustration> createState() => _BlueIllustrationState();
}

class _BlueIllustrationState extends State<_BlueIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: _durationFor(widget.state));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimating();
  }

  @override
  void didUpdateWidget(covariant _BlueIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _controller.duration = _durationFor(widget.state);
    }
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

  Duration _durationFor(BlueState state) {
    switch (state) {
      case BlueState.thinking:
        return const Duration(milliseconds: 900);
      case BlueState.celebrating:
        return const Duration(milliseconds: 500);
      case BlueState.sleeping:
        return const Duration(milliseconds: 3400);
      default:
        return const Duration(milliseconds: 2400);
    }
  }

  double _scaleAmplitudeFor(BlueState state) {
    switch (state) {
      case BlueState.celebrating:
        return 0.06;
      case BlueState.thinking:
        return 0.015;
      case BlueState.sleeping:
        return 0.008;
      case BlueState.concerned:
        return 0.01;
      default:
        return 0.02;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amplitude = _scaleAmplitudeFor(widget.state);
    final colors = context.colors;

    final clippedImage = ClipOval(
      child: Image.asset(
        BlueAssets.main,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
      ),
    );

    final composed = widget.showGlow
        ? clippedImage
        : DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors.brand.defaultColor.withOpacity(0.10),
                  blurRadius: widget.size * 0.25,
                  spreadRadius: widget.size * 0.02,
                ),
              ],
            ),
            child: clippedImage,
          );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * amplitude);
        return Transform.scale(scale: scale, child: child);
      },
      child: SizedBox(width: widget.size, height: widget.size, child: composed),
    );
  }
}
