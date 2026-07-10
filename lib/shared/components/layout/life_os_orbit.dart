import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

class LifeOSAreaItem {
  const LifeOSAreaItem({
    required this.icon,
    required this.label,
    required this.status,
  });

  final IconData icon;
  final String label;
  final String status;
}

class LifeOSOrbit extends StatelessWidget {
  const LifeOSOrbit({
    super.key,
    required this.center,
    required this.areas,
    this.size = 320,
    this.centerSize = 140,
  });

  final Widget center;
  final List<LifeOSAreaItem> areas;
  final double size;
  final double centerSize;

  @override
  Widget build(BuildContext context) {
    final radius = (size - centerSize) / 2.4;
    final middle = size / 2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SizedBox(width: centerSize, height: centerSize, child: center),
          ),
          for (int i = 0; i < areas.length; i++)
            _positioned(
              index: i,
              total: areas.length,
              radius: radius,
              middle: middle,
              child: _AreaBadge(item: areas[i]),
            ),
        ],
      ),
    );
  }

  Widget _positioned({
    required int index,
    required int total,
    required double radius,
    required double middle,
    required Widget child,
  }) {
    final angle = (2 * math.pi * index / total) - (math.pi / 2);
    final dx = middle + radius * math.cos(angle);
    final dy = middle + radius * math.sin(angle);

    return Positioned(
      left: dx - 32,
      top: dy - 32,
      child: child,
    );
  }
}

class _AreaBadge extends StatelessWidget {
  const _AreaBadge({required this.item});

  final LifeOSAreaItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
              boxShadow: context.shadows.low,
            ),
            child: Icon(item.icon, size: 20, color: colors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: context.textStyles.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item.status,
            style: context.textStyles.bodySmall?.copyWith(
              color: colors.positive.defaultColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}