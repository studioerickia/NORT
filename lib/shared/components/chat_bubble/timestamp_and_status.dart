import 'package:flutter/material.dart';

import '../../../core/extensions/nort_theme_context_x.dart';

/// Rótulo de horário de uma mensagem — texto pequeno e discreto.
///
/// Exemplo:
/// ```dart
/// Timestamp(label: '09:41')
/// ```
class Timestamp extends StatelessWidget {
  const Timestamp({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textStyles.bodySmall?.copyWith(
        color: color ?? context.colors.textTertiary,
      ),
    );
  }
}

/// Estado de entrega/leitura de uma mensagem do usuário (padrão
/// "check" duplo, como na imagem de referência).
enum NortMessageDeliveryStatus { sent, delivered, read }

/// Indicador de status de mensagem — só faz sentido em mensagens do
/// usuário (a Blue não precisa de confirmação de leitura).
///
/// Exemplo:
/// ```dart
/// MessageStatus(status: NortMessageDeliveryStatus.read)
/// ```
class MessageStatus extends StatelessWidget {
  const MessageStatus({super.key, required this.status});

  final NortMessageDeliveryStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = status == NortMessageDeliveryStatus.read
        ? colors.brand.defaultColor
        : colors.textTertiary;

    final icon = status == NortMessageDeliveryStatus.sent
        ? Icons.check
        : Icons.done_all;

    return Icon(icon, size: 14, color: color);
  }
}
