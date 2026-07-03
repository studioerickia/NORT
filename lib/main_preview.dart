import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/nort_theme.dart';
import 'shared/component_preview/component_preview_screen.dart';

/// Entry point alternativo — roda só o Storybook interno, sem
/// depender de `app.dart`/navegação real (que ainda não existe até a
/// Etapa 5).
///
/// Uso local:
/// ```
/// flutter run -t lib/main_preview.dart
/// ```
void main() {
  runApp(const ProviderScope(child: _PreviewApp()));
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NORT — Component Catalog',
      debugShowCheckedModeBanner: false,
      theme: NortTheme.light,
      darkTheme: NortTheme.dark,
      home: const ComponentPreviewScreen(),
    );
  }
}
