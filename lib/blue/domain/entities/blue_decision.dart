import 'blue_message.dart';

enum BlueDecisionType { financial, goal, engagement, onboarding, milestone }

enum BluePriority { high, medium, low, none }

enum BlueTrigger {
  positiveBalance,
  negativeBalance,
  firstIncome,
  firstExpense,
  goalCreated,
  goalCompleted,
  goalNearCompletion,
  manyExpensesThisMonth,
  noTransactionsInDays,
  firstLogin,
  firstWeekOfUse,
  firstMonthOfUse,
  significantBehaviorChange,
  onboardingJustCompleted,
  returnedAfterAbsence,
  none,
}

class BlueDecision {
  const BlueDecision({
    required this.trigger,
    required this.type,
    required this.priority,
    required this.message,
    required this.displayDuration,
  });

  final BlueTrigger trigger;
  final BlueDecisionType type;
  final BluePriority priority;
  final BlueMessage message;
  final Duration displayDuration;

  bool get shouldDisplay =>
      priority != BluePriority.none && message.shouldDisplay;

  static BlueDecision silence({BlueTrigger trigger = BlueTrigger.none}) {
    return BlueDecision(
      trigger: trigger,
      type: BlueDecisionType.engagement,
      priority: BluePriority.none,
      message: BlueMessage.silence(ruleId: 'decision.${trigger.name}'),
      displayDuration: Duration.zero,
    );
  }
}
