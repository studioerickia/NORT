import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado global de `ThemeMode` (light/dark/system).
///
/// Este provider é infraestrutura de tema, não uma feature — não há
/// nenhuma tela de configurações ou toggle visual ainda (isso é
/// trabalho da Component Library / da feature `settings`, em etapas
/// futuras). Ele existe agora só para que o ADR Sprint 0 cumpra o
/// compromisso da seção 6: "ambos os temas são gerados a partir do
/// mesmo arquivo de tokens, então a Sprint 0 entrega troca de tema em
/// tempo real sem duplicar widgets" — o que exige que exista *algum*
/// estado observável para `MaterialApp.themeMode` consumir.
///
/// Default `ThemeMode.system`: o NORT respeita a preferência do
/// aparelho antes de qualquer escolha explícita do usuário.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
