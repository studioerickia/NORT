import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';
import 'state_placeholder_base.dart';

/// Estado vazio — "Nova meta", lista de transações sem itens, etc.
/// Tom neutro/convidativo, nunca de erro.
///
/// Exemplo:
/// ```dart
/// EmptyState(
///   icon: Icons.flag_outlined,
///   title: 'Nova meta',
///   description: 'Comece a construir seu próximo sonho.',
///   actionLabel: 'Criar meta',
///   onAction: () {},
/// )
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return StatePlaceholderBase(
      icon: icon,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// Estado de erro — algo falhou e precisa de nova tentativa. Tom
/// `warning`, nunca `danger` puro — mesmo um erro, no NORT, não deve
/// parecer alarmante (Calm UI).
///
/// Exemplo:
/// ```dart
/// ErrorState(title: 'Algo não saiu como esperado', actionLabel: 'Tentar de novo', onAction: () {})
/// ```
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title = 'Algo não saiu como esperado',
    this.description,
    this.actionLabel = 'Tentar de novo',
    this.onAction,
  });

  final String title;
  final String? description;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return StatePlaceholderBase(
      icon: Icons.refresh_rounded,
      iconColor: context.colors.warning,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// Estado offline — sem conexão. Tom neutro, nunca vermelho — falta
/// de internet não é um erro do usuário.
///
/// Exemplo:
/// ```dart
/// OfflineState(onAction: () {})
/// ```
class OfflineState extends StatelessWidget {
  const OfflineState({
    super.key,
    this.title = 'Você está offline',
    this.description = 'Verifique sua conexão para continuar.',
    this.actionLabel = 'Tentar novamente',
    this.onAction,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return StatePlaceholderBase(
      icon: Icons.wifi_off_rounded,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
