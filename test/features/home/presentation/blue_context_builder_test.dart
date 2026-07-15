import 'package:flutter_test/flutter_test.dart';
import 'package:nort/blue/domain/brain/deterministic_decision_engine.dart';
import 'package:nort/blue/domain/entities/blue_decision.dart';
import 'package:nort/core/utils/period.dart';
import 'package:nort/features/goals/domain/entities/goal.dart';
import 'package:nort/features/home/presentation/blue_context_builder.dart';
import 'package:nort/features/transactions/domain/entities/transaction.dart';

void main() {
  const engine = DeterministicDecisionEngine();
  final now = DateTime(2026, 1, 15);

  Goal buildGoal({
    required String title,
    required double target,
    required double current,
    GoalStatus status = GoalStatus.active,
  }) {
    return Goal(
      id: 'goal-1',
      userId: 'user-1',
      title: title,
      targetAmount: target,
      currentAmount: current,
      status: status,
      sortOrder: 0,
      createdAt: now,
      updatedAt: now,
    );
  }

  Transaction buildTransaction({
    required double amount,
    required TransactionType type,
    required DateTime occurredAt,
  }) {
    return Transaction(
      id: 'tx-${occurredAt.millisecondsSinceEpoch}-$amount',
      userId: 'user-1',
      amount: amount,
      type: type,
      occurredAt: occurredAt,
      createdAt: occurredAt,
      updatedAt: occurredAt,
    );
  }

  group('Cenário: nada de especial', () {
    test('sem metas, sem transações, saldo zero -> silêncio', () {
      final context = buildHomeBlueContext(
        now: now,
        balance: 0,
        goals: const [],
        transactions: const [],
        period: PeriodSelection.thisMonth,
      );
      final decision = engine.decide(context);
      expect(decision.shouldDisplay, isFalse);
      expect(decision.trigger, BlueTrigger.positiveBalance);
    });
  });

  group('Cenário: saldo negativo (real, calculado das transações)', () {
    test('despesas maiores que receitas -> Insight de saldo negativo', () {
      final transactions = [
        buildTransaction(
            amount: 500, type: TransactionType.income, occurredAt: now),
        buildTransaction(
            amount: 1200, type: TransactionType.expense, occurredAt: now),
      ];
      final context = buildHomeBlueContext(
        now: now,
        balance: 500 - 1200,
        goals: const [],
        transactions: transactions,
        period: PeriodSelection.thisMonth,
      );
      final decision = engine.decide(context);
      expect(decision.shouldDisplay, isTrue);
      expect(decision.trigger, BlueTrigger.negativeBalance);
    });
  });

  group('Cenário: meta perto de concluir', () {
    test('meta ativa com 90% de progresso -> Insight cita a meta', () {
      final goals = [
        buildGoal(title: 'Viagem pro Japão', target: 10000, current: 9000)
      ];
      final context = buildHomeBlueContext(
        now: now,
        balance: 100,
        goals: goals,
        transactions: const [],
        period: PeriodSelection.thisMonth,
      );
      final decision = engine.decide(context);
      expect(decision.trigger, BlueTrigger.goalNearCompletion);
      expect(decision.message.text, contains('Viagem pro Japão'));
      expect(decision.message.text, contains('R\$1.000,00'));
    });

    test('meta arquivada (sonho) não conta como ativa, não dispara', () {
      final goals = [
        buildGoal(
            title: 'Sonho distante',
            target: 10000,
            current: 9500,
            status: GoalStatus.archived),
      ];
      final context = buildHomeBlueContext(
        now: now,
        balance: 100,
        goals: goals,
        transactions: const [],
        period: PeriodSelection.thisMonth,
      );
      final decision = engine.decide(context);
      expect(decision.trigger, isNot(BlueTrigger.goalNearCompletion));
    });
  });

  group('Cenário: muitas despesas no período', () {
    test('mais de 15 despesas no mês -> dispara manyExpensesThisMonth', () {
      final transactions = List.generate(
        16,
        (i) => buildTransaction(
          amount: 20,
          type: TransactionType.expense,
          occurredAt: DateTime(2026, 1, i + 1),
        ),
      );
      final context = buildHomeBlueContext(
        now: now,
        balance: -320,
        goals: const [],
        transactions: transactions,
        period: PeriodSelection.thisMonth,
      );
      expect(context.manyExpensesThisMonth, isTrue);
      final decision = engine.decide(context);
      expect(decision.trigger, BlueTrigger.negativeBalance);
    });

    test('15 despesas exatas não dispara (limite é "mais que 15")', () {
      final transactions = List.generate(
        15,
        (i) => buildTransaction(
          amount: 10,
          type: TransactionType.expense,
          occurredAt: DateTime(2026, 1, i + 1),
        ),
      );
      final context = buildHomeBlueContext(
        now: now,
        balance: 500,
        goals: const [],
        transactions: transactions,
        period: PeriodSelection.thisMonth,
      );
      expect(context.manyExpensesThisMonth, isFalse);
    });

    test(
        'saldo positivo + muitas despesas -> manyExpensesThisMonth aparece de verdade como decisão',
        () {
      final transactions = [
        buildTransaction(
            amount: 500, type: TransactionType.income, occurredAt: now),
        ...List.generate(
          16,
          (i) => buildTransaction(
            amount: 10,
            type: TransactionType.expense,
            occurredAt: DateTime(2026, 1, i + 1),
          ),
        ),
      ];
      final context = buildHomeBlueContext(
        now: now,
        balance: 500 - 160,
        goals: const [],
        transactions: transactions,
        period: PeriodSelection.thisMonth,
      );
      final decision = engine.decide(context);
      expect(decision.trigger, BlueTrigger.manyExpensesThisMonth);
      expect(decision.shouldDisplay, isTrue);
    });
  });

  group('Cenário: transações fora do período não contam pro resumo', () {
    test('transação de 2 meses atrás não entra em transactionCountThisMonth',
        () {
      final transactions = [
        buildTransaction(
            amount: 50,
            type: TransactionType.expense,
            occurredAt: DateTime(2025, 11, 1)),
        buildTransaction(
            amount: 50, type: TransactionType.expense, occurredAt: now),
      ];
      final context = buildHomeBlueContext(
        now: now,
        balance: -100,
        goals: const [],
        transactions: transactions,
        period: PeriodSelection.thisMonth,
      );
      expect(context.transactionCountThisMonth, 1);
    });
  });

  group('Cenário: dias desde a última transação', () {
    test(
        'última transação há 20 dias -> daysSinceLastTransaction calculado certo',
        () {
      final transactions = [
        buildTransaction(
          amount: 30,
          type: TransactionType.expense,
          occurredAt: now.subtract(const Duration(days: 20)),
        ),
      ];
      final context = buildHomeBlueContext(
        now: now,
        balance: 200,
        goals: const [],
        transactions: transactions,
        period: PeriodSelection.thisMonth,
      );
      expect(context.daysSinceLastTransaction, 20);

      final decision = engine.decide(context);
      expect(decision.trigger, BlueTrigger.noTransactionsInDays);
    });

    test('sem nenhuma transação -> daysSinceLastTransaction é nulo', () {
      final context = buildHomeBlueContext(
        now: now,
        balance: 0,
        goals: const [],
        transactions: const [],
        period: PeriodSelection.thisMonth,
      );
      expect(context.daysSinceLastTransaction, isNull);
    });
  });
}
