import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';

/// Entry point do NORT.
///
/// `usePathUrlStrategy()` só roda em Flutter Web (`kIsWeb`) — troca as
/// URLs de `nort.app/#/goals` para `nort.app/goals`, essencial para a
/// fase atual do projeto (validação de UX em navegador, ver decisão
/// registrada em `app.dart`/`ResponsiveWebFrame`). Em mobile real,
/// esta chamada não tem efeito nenhum — é seguro deixá-la incondicional
/// no código-fonte, sem precisar de `#ifdef` nem build flavors.
///
/// `ProviderScope` é o único outro wrapper global permitido aqui —
/// nenhuma inicialização de serviço (Supabase, Analytics, Feature
/// Flags etc.) entra neste arquivo. Bootstrapping de serviços
/// concretos é responsabilidade de `core/services/*` e será conectado
/// nas etapas seguintes.
void main() {
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(const ProviderScope(child: NortApp()));
}
