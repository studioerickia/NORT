import '../../../core/utils/formatters.dart';
import '../entities/blue_context.dart';
import '../entities/blue_decision.dart';
import '../entities/blue_message.dart';
import 'blue_decision_engine.dart';

class DeterministicDecisionEngine implements BlueDecisionEngine {
  const DeterministicDecisionEngine();

  static const _noTransactionsThresholdDays = 14;
  static const _returnedAfterAbsenceThresholdDays = 7;

  @override
  BlueDecision decide(BlueContext context) {
    final evaluators = <BlueDecision? Function(BlueContext)>[
      _goalCompleted,
      _negativeBalance,
      _goalNearCompletion,
      _onboardingJustCompleted,
      _returnedAfterAbsence,
      _firstMonthOfUse,
      _significantBehaviorChange,
      _manyExpensesThisMonth,
      _firstIncome,
      _goalCreated,
      _firstLogin,
      _firstWeekOfUse,
      _firstExpense,
      _noTransactionsInDays,
      _positiveBalance,
    ];

    for (final evaluate in evaluators) {
      final decision = evaluate(context);
      if (decision != null) return decision;
    }

    return BlueDecision.silence();
  }

  BlueDecision? _goalCompleted(BlueContext c) {
    if (c.goalJustCompletedTitle == null) return null;
    return _build(
      trigger: BlueTrigger.goalCompleted,
      type: BlueDecisionType.goal,
      priority: BluePriority.high,
      tone: BlueTone.celebratory,
      mood: BlueMood.celebrating,
      ruleId: 'decision.goal_completed',
      text:
          'Você concluiu a meta "${c.goalJustCompletedTitle}". Isso é resultado de constância.',
    );
  }

  BlueDecision? _negativeBalance(BlueContext c) {
    if (c.balance >= 0) return null;
    return _build(
      trigger: BlueTrigger.negativeBalance,
      type: BlueDecisionType.financial,
      priority: BluePriority.high,
      tone: BlueTone.reassuring,
      mood: BlueMood.reassuring,
      ruleId: 'decision.negative_balance',
      text:
          'Seu saldo está negativo esse mês. Sem alarme — quando quiser, a gente organiza isso com calma.',
    );
  }

  BlueDecision? _goalNearCompletion(BlueContext c) {
    final goal = c.mostRecentActiveGoal;
    if (goal == null || goal.progress < 0.8 || goal.progress >= 1.0) {
      return null;
    }
    return _build(
      trigger: BlueTrigger.goalNearCompletion,
      type: BlueDecisionType.goal,
      priority: BluePriority.medium,
      tone: BlueTone.reassuring,
      mood: BlueMood.idle,
      ruleId: 'decision.goal_near_completion',
      text:
          'Faltam apenas ${formatCurrencyBRL(goal.remainingAmount)} pra "${goal.title}".',
    );
  }

  BlueDecision? _onboardingJustCompleted(BlueContext c) {
    if (!c.onboardingJustCompleted) return null;
    return _build(
      trigger: BlueTrigger.onboardingJustCompleted,
      type: BlueDecisionType.onboarding,
      priority: BluePriority.medium,
      tone: BlueTone.reassuring,
      mood: BlueMood.idle,
      ruleId: 'decision.onboarding_completed',
      text: 'Que bom ter você aqui. Vamos construir isso juntos, no seu ritmo.',
    );
  }

  BlueDecision? _returnedAfterAbsence(BlueContext c) {
    final days = c.daysSinceLastLogin;
    if (days == null || days < _returnedAfterAbsenceThresholdDays) return null;
    return _build(
      trigger: BlueTrigger.returnedAfterAbsence,
      type: BlueDecisionType.engagement,
      priority: BluePriority.medium,
      tone: BlueTone.reassuring,
      mood: BlueMood.idle,
      ruleId: 'decision.returned_after_absence',
      text:
          'Que bom te ver de novo. Nada acumulou de errado — só o de sempre esperando você.',
    );
  }

  BlueDecision? _firstMonthOfUse(BlueContext c) {
    if (!c.isFirstMonthOfUse) return null;
    return _build(
      trigger: BlueTrigger.firstMonthOfUse,
      type: BlueDecisionType.milestone,
      priority: BluePriority.medium,
      tone: BlueTone.celebratory,
      mood: BlueMood.celebrating,
      ruleId: 'decision.first_month',
      text: 'Já faz um mês que a gente está nessa juntos.',
    );
  }

  BlueDecision? _significantBehaviorChange(BlueContext c) {
    if (!c.significantBehaviorChangeDetected) return null;
    return _build(
      trigger: BlueTrigger.significantBehaviorChange,
      type: BlueDecisionType.financial,
      priority: BluePriority.medium,
      tone: BlueTone.curious,
      mood: BlueMood.curious,
      ruleId: 'decision.behavior_change',
      text:
          'Percebi uma mudança no seu padrão esse mês. Só quis registrar — sem nenhum julgamento nisso.',
    );
  }

  BlueDecision? _manyExpensesThisMonth(BlueContext c) {
    if (!c.manyExpensesThisMonth) return null;
    return _build(
      trigger: BlueTrigger.manyExpensesThisMonth,
      type: BlueDecisionType.financial,
      priority: BluePriority.medium,
      tone: BlueTone.neutral,
      mood: BlueMood.idle,
      ruleId: 'decision.many_expenses',
      text:
          'Notei bastante movimento nas despesas esse mês. Sem problema — só quis te avisar.',
    );
  }

  BlueDecision? _firstIncome(BlueContext c) {
    if (!c.isFirstIncomeEver) return null;
    return _build(
      trigger: BlueTrigger.firstIncome,
      type: BlueDecisionType.milestone,
      priority: BluePriority.medium,
      tone: BlueTone.celebratory,
      mood: BlueMood.celebrating,
      ruleId: 'decision.first_income',
      text: 'Sua primeira receita registrada. Um começo real.',
    );
  }

  BlueDecision? _goalCreated(BlueContext c) {
    if (c.goalJustCreatedTitle == null) return null;
    return _build(
      trigger: BlueTrigger.goalCreated,
      type: BlueDecisionType.goal,
      priority: BluePriority.low,
      tone: BlueTone.curious,
      mood: BlueMood.curious,
      ruleId: 'decision.goal_created',
      text:
          'Vi que você criou "${c.goalJustCreatedTitle}". Vou acompanhar isso com você.',
    );
  }

  BlueDecision? _firstLogin(BlueContext c) {
    if (!c.isFirstLoginEver) return null;
    return _build(
      trigger: BlueTrigger.firstLogin,
      type: BlueDecisionType.onboarding,
      priority: BluePriority.low,
      tone: BlueTone.reassuring,
      mood: BlueMood.idle,
      ruleId: 'decision.first_login',
      text: 'Que bom ter você aqui.',
    );
  }

  BlueDecision? _firstWeekOfUse(BlueContext c) {
    if (!c.isFirstWeekOfUse) return null;
    return _build(
      trigger: BlueTrigger.firstWeekOfUse,
      type: BlueDecisionType.milestone,
      priority: BluePriority.low,
      tone: BlueTone.curious,
      mood: BlueMood.idle,
      ruleId: 'decision.first_week',
      text: 'Uma semana com a gente. Como está sendo até aqui?',
    );
  }

  BlueDecision? _firstExpense(BlueContext c) {
    if (!c.isFirstExpenseEver) return null;
    return _build(
      trigger: BlueTrigger.firstExpense,
      type: BlueDecisionType.milestone,
      priority: BluePriority.low,
      tone: BlueTone.neutral,
      mood: BlueMood.idle,
      ruleId: 'decision.first_expense',
      text:
          'Primeira despesa registrada. Assim você começa a enxergar seu padrão.',
    );
  }

  BlueDecision? _noTransactionsInDays(BlueContext c) {
    final days = c.daysSinceLastTransaction;
    if (days == null || days < _noTransactionsThresholdDays) return null;
    return _build(
      trigger: BlueTrigger.noTransactionsInDays,
      type: BlueDecisionType.engagement,
      priority: BluePriority.low,
      tone: BlueTone.reassuring,
      mood: BlueMood.idle,
      ruleId: 'decision.no_transactions',
      text:
          'Faz um tempo que não aparece nenhuma transação por aqui. Sem pressa — só passando.',
    );
  }

  BlueDecision? _positiveBalance(BlueContext c) {
    if (c.balance < 0) return null;
    return BlueDecision.silence(trigger: BlueTrigger.positiveBalance);
  }

  BlueDecision _build({
    required BlueTrigger trigger,
    required BlueDecisionType type,
    required BluePriority priority,
    required BlueTone tone,
    required BlueMood mood,
    required String ruleId,
    required String text,
  }) {
    return BlueDecision(
      trigger: trigger,
      type: type,
      priority: priority,
      message: BlueMessage(
        text: text,
        tone: tone,
        ruleId: ruleId,
        suggestedMood: mood,
      ),
      displayDuration: _durationFor(priority),
    );
  }

  Duration _durationFor(BluePriority priority) {
    switch (priority) {
      case BluePriority.high:
        return const Duration(seconds: 8);
      case BluePriority.medium:
        return const Duration(seconds: 5);
      case BluePriority.low:
        return const Duration(seconds: 3);
      case BluePriority.none:
        return Duration.zero;
    }
  }
}
