import '../../../blue/domain/entities/blue_context.dart';
import '../../../core/utils/period.dart';
import '../../goals/domain/entities/goal.dart';
import '../../transactions/domain/entities/transaction.dart';

const _manyExpensesThreshold = 15;

BlueContext buildHomeBlueContext({
  required DateTime now,
  String? firstName,
  required double balance,
  required List<Goal> goals,
  required List<Transaction> transactions,
  required PeriodSelection period,
}) {
  final activeGoals =
      goals.where((g) => g.status == GoalStatus.active).toList();

  final mostRecentGoal = activeGoals.isEmpty
      ? null
      : BlueGoalSnapshot(
          title: activeGoals.first.title,
          progress: activeGoals.first.progress,
          remainingAmount:
              (activeGoals.first.targetAmount - activeGoals.first.currentAmount)
                  .clamp(0, double.infinity)
                  .toDouble(),
        );

  final periodTransactions = transactions
      .where((t) => period.contains(t.occurredAt, now: now))
      .toList();
  final periodExpenseCount =
      periodTransactions.where((t) => t.type == TransactionType.expense).length;

  DateTime? mostRecentTransactionAt;
  for (final t in transactions) {
    if (mostRecentTransactionAt == null ||
        t.occurredAt.isAfter(mostRecentTransactionAt)) {
      mostRecentTransactionAt = t.occurredAt;
    }
  }
  final daysSinceLastTransaction = mostRecentTransactionAt != null
      ? now.difference(mostRecentTransactionAt).inDays
      : null;

  return BlueContext(
    now: now,
    firstName: firstName,
    balance: balance,
    activeGoalsCount: activeGoals.length,
    mostRecentActiveGoal: mostRecentGoal,
    transactionCountThisMonth: periodTransactions.length,
    daysSinceLastTransaction: daysSinceLastTransaction,
    manyExpensesThisMonth: periodExpenseCount > _manyExpensesThreshold,
  );
}
