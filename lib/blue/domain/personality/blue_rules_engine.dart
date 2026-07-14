import '../entities/blue_greeting.dart';
import '../entities/blue_message.dart';

enum BlueEmptyStateKind { noActiveGoals, noTransactions }

abstract class BlueRulesEngine {
  BlueGreeting greeting({required DateTime now, String? firstName});

  BlueMessage goalObservation({
    required double progress,
    required double remainingAmount,
    required bool isCompleted,
    String? goalTitle,
  });

  BlueMessage balanceObservation({required double balance});

  BlueMessage emptyStateMessage(BlueEmptyStateKind kind);
}