import 'package:flutter/material.dart';

class BreathingScale extends StatefulWidget {
  const BreathingScale({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 2400),
    this.amplitude = 0.02,
  });

  final Widget child;
  final Duration duration;
  final double amplitude;

  @override
  State<BreathingScale> createState() => _BreathingScaleState();
}

class _BreathingScaleState extends State<BreathingScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.0 + widget.amplitude).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}