import 'package:flutter/material.dart';

import '../../core/extensions/nort_theme_context_x.dart';

enum WhaleLabsSignatureVariant {
  caption,
  footer,
}

class WhaleLabsSignature extends StatelessWidget {
  const WhaleLabsSignature({
    super.key,
    this.variant = WhaleLabsSignatureVariant.caption,
    this.version = 'v0.1',
  });

  final WhaleLabsSignatureVariant variant;
  final String version;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    final style =
        context.textStyles.bodySmall?.copyWith(color: colors.textTertiary);

    if (variant == WhaleLabsSignatureVariant.caption) {
      return Text('by Whale Labs', style: style, textAlign: TextAlign.center);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('NORT $version', style: style, textAlign: TextAlign.center),
        SizedBox(height: spacing.xs / 2),
        Text('Crafted by Whale Labs',
            style: style, textAlign: TextAlign.center),
      ],
    );
  }
}
