import 'package:flutter/material.dart';

import '../../shared/tokens/tokens.dart';

/// Acesso ergonômico aos tokens do Design System via `BuildContext`.
///
/// Esta é a API que toda a Component Library (próxima etapa) e todas
/// as `features/*/presentation` devem usar — nunca
/// `Theme.of(context).extension<T>()` espalhado pelo código, e nunca
/// import direto de `NortPalette`.
///
/// Uso:
/// ```dart
/// Container(
///   padding: EdgeInsets.all(context.spacing.md),
///   decoration: BoxDecoration(
///     color: context.colors.surface,
///     borderRadius: context.radii.mdRadius,
///     boxShadow: context.shadows.low,
///   ),
///   child: Text('R\$84', style: context.numericStyles.large),
/// )
/// ```
extension NortThemeContextX on BuildContext {
  NortColors get colors => Theme.of(this).extension<NortColors>()!;

  NortSpacing get spacing => Theme.of(this).extension<NortSpacing>()!;

  NortRadii get radii => Theme.of(this).extension<NortRadii>()!;

  NortShadows get shadows => Theme.of(this).extension<NortShadows>()!;

  NortMotion get motion => Theme.of(this).extension<NortMotion>()!;

  NortNumericStyles get numericStyles =>
      Theme.of(this).extension<NortNumericStyles>()!;

  /// Atalho para o `TextTheme` padrão (títulos, corpo, labels).
  TextTheme get textStyles => Theme.of(this).textTheme;
}
