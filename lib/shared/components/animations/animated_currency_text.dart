import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../../../core/utils/formatters.dart';

class AnimatedCurrencyText extends StatelessWidget {
  const AnimatedCurrencyText({super.key, required this.value, this.style});

  final double value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: motion.standard,
      curve: motion.enter,
      builder: (context, animatedValue, _) {
        return Text(formatCurrencyBRL(animatedValue), style: style);
      },
    );
  }
}
