import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Avatar de usuário — imagem circular com fallback de iniciais.
///
/// `imageBuilder` segue o mesmo padrão de `GoalCard`: este componente
/// não sabe se a imagem vem de rede, asset ou cache — só reserva o
/// círculo e delega o conteúdo.
///
/// Exemplo:
/// ```dart
/// UserAvatar(initials: 'EM', size: 40)
/// UserAvatar(size: 40, imageBuilder: (context) => Image.network(url, fit: BoxFit.cover))
/// ```
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.initials,
    this.imageBuilder,
    this.size = 40,
  });

  final String? initials;
  final WidgetBuilder? imageBuilder;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: colors.brand.disabled,
        alignment: Alignment.center,
        child: imageBuilder != null
            ? imageBuilder!(context)
            : Text(
                initials ?? '',
                style: context.textStyles.labelLarge?.copyWith(
                  color: colors.brand.pressed,
                ),
              ),
      ),
    );
  }
}
