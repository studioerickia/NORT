import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/nort_theme.dart';
import 'core/theme/responsive_web_frame.dart';
import 'core/theme/theme_mode_provider.dart';

/// Raiz do app NORT.
///
/// A partir da Etapa 5, este widget monta o app "de verdade":
/// `MaterialApp.router` consumindo o `GoRouter` (`appRouterProvider`)
/// e os dois temas (`NortTheme.light`/`.dark`), com `themeMode`
/// observando `themeModeProvider` para trocar de tema em tempo real
/// (compromisso da Etapa 2, seção 6 do ADR).
///
/// `builder: ResponsiveWebFrame` — decisão de fase de projeto: o foco
/// atual é validar UX/navegação em Flutter Web, então o app é
/// enquadrado num frame de celular quando visto em tela larga, em vez
/// de esticar. Não afeta build mobile real (frame só ativa acima do
/// breakpoint, ver `responsive_web_frame.dart`).
///
/// Continua sem nenhuma lógica de negócio, sem dado real, sem sessão
/// de auth de verdade — só a fundação de navegação e tema conectadas.
class NortApp extends ConsumerWidget {
  const NortApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'NORT',
      debugShowCheckedModeBanner: false,
      theme: NortTheme.light,
      darkTheme: NortTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) => ResponsiveWebFrame(child: child!),
    );
  }
}
