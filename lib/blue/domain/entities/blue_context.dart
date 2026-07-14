class BlueGoalSnapshot {
  const BlueGoalSnapshot({
    required this.title,
    required this.progress,
    required this.remainingAmount,
  });

  final String title;
  final double progress;
  final double remainingAmount;
}

class BlueContext {
  const BlueContext({
    required this.now,
    this.firstName,
    required this.balance,
    this.activeGoalsCount = 0,
    this.mostRecentActiveGoal,
    this.daysSinceLastTransaction,
    this.daysSinceLastLogin,
    this.isFirstLoginEver = false,
    this.isFirstWeekOfUse = false,
    this.isFirstMonthOfUse = false,
    this.isFirstIncomeEver = false,
    this.isFirstExpenseEver = false,
    this.onboardingJustCompleted = false,
    this.goalJustCompletedTitle,
    this.goalJustCreatedTitle,
    this.manyExpensesThisMonth = false,
    this.significantBehaviorChangeDetected = false,
  });

  final DateTime now;
  final String? firstName;

  final double balance;
  final int activeGoalsCount;
  final BlueGoalSnapshot? mostRecentActiveGoal;

  final int? daysSinceLastTransaction;
  final int? daysSinceLastLogin;

  final bool isFirstLoginEver;
  final bool isFirstWeekOfUse;
  final bool isFirstMonthOfUse;
  final bool isFirstIncomeEver;
  final bool isFirstExpenseEver;

  final bool onboardingJustCompleted;
  final String? goalJustCompletedTitle;
  final String? goalJustCreatedTitle;

  final bool manyExpensesThisMonth;
  final bool significantBehaviorChangeDetected;
}