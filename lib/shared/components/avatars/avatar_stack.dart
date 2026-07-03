import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import 'user_avatar.dart';

/// Pilha de avatares sobrepostos — ex.: participantes de uma meta
/// compartilhada (futuro), lista de contatos recentes.
///
/// Exemplo:
/// ```dart
/// AvatarStack(avatars: [UserAvatar(initials: 'EM'), UserAvatar(initials: 'JS')])
/// ```
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.avatars,
    this.size = 32,
    this.maxVisible = 4,
  });

  final List<UserAvatar> avatars;
  final double size;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visible = avatars.take(maxVisible).toList();
    final overflow = avatars.length - visible.length;

    return SizedBox(
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * (size * 0.7),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.background, width: 2),
                ),
                child: visible[i],
              ),
            ),
          if (overflow > 0)
            Positioned(
              left: visible.length * (size * 0.7),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surface,
                  border: Border.all(color: colors.background, width: 2),
                ),
                alignment: Alignment.center,
                child: Text('+$overflow', style: context.textStyles.labelSmall),
              ),
            ),
        ],
      ),
    );
  }
}
