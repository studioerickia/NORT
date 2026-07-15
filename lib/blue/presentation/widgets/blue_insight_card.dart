import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import '../../domain/entities/blue_decision.dart';
import '../blue_avatar.dart';
import '../blue_mood_mapper.dart';

class BlueInsightCard extends StatelessWidget {
  const BlueInsightCard({super.key, required this.decision});

  final BlueDecision decision;

  @override
  Widget build(BuildContext context) {
    if (!decision.shouldDisplay) return const SizedBox.shrink();

    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: context.radii.lgRadius,
        boxShadow: context.shadows.low,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlueAvatar(
            state: mapBlueMoodToState(decision.message.suggestedMood),
            size: 40,
            showGlow: false,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Text(
              decision.message.text,
              style: context.textStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
