import 'package:flutter_test/flutter_test.dart';
import 'package:nort/blue/domain/brain/deterministic_decision_engine.dart';
import 'package:nort/blue/domain/entities/blue_context.dart';
import 'package:nort/blue/domain/entities/blue_decision.dart';
import 'package:nort/blue/domain/entities/blue_message.dart';

const _bannedPhrases = [
  'gastar demais',
  'você deveria',
  'precisa urgentemente',
  'atenção!',
  'cuidado!',
  'erro',
  'você errou',
];

BlueContext _baseContext({
  double balance = 100,
  int activeGoalsCount = 0,
  BlueGoalSnapshot? mostRecentActiveGoal,
  int? daysSinceLastTransaction,
  int? daysSinceLastLogin,
  bool isFirstLoginEver = false,
  bool isFirstWeekOfUse = false,
  bool isFirstMonthOfUse = false,
  bool isFirstIncomeEver = false,
  bool isFirstExpenseEver = false,
  bool onboardingJustCompleted = false,
  String? goalJustCompletedTitle,
  String? goalJustCreatedTitle,
  bool manyExpensesThisMonth = false,
  bool significantBehaviorChangeDetected = false,
}) {
  return BlueContext(
    now: DateTime(2026, 1, 15),
    firstName: 'Erick',
    balance: balance,
    activeGoalsCount: activeGoalsCount,
    mostRecentActiveGoal: mostRecentActiveGoal,
    daysSinceLastTransaction: daysSinceLastTransaction,
    daysSinceLastLogin: daysSinceLastLogin,
    isFirstLoginEver: isFirstLoginEver,
    isFirstWeekOfUse: isFirstWeekOfUse,
    isFirstMonthOfUse: isFirstMonthOfUse,
    isFirstIncomeEver: isFirstIncomeEver,
    isFirstExpenseEver: isFirstExpenseEver,
    onboardingJustCompleted: onboardingJustCompleted,
    goalJustCompletedTitle: goalJustCompletedTitle,
    goalJustCreatedTitle: goalJustCreatedTitle,
    manyExpensesThisMonth: manyExpensesThisMonth,
    significantBehaviorChangeDetected: significantBehaviorChangeDetected,
  );
}

void main() {
  const engine = DeterministicDecisionEngine();

  group('Contexto neutro', () {
    test('saldo positivo, nada de especial -> silêncio (positiveBalance)', () {
      final decision = engine.decide(_baseContext());
      expect(decision.shouldDisplay, isFalse);
      expect(decision.trigger, BlueTrigger.positiveBalance);
      expect(decision.priority, BluePriority.none);
    });
  });

  group('Prioridade alta', () {
    test('meta concluída -> celebração, cita o nome', () {
      final decision = engine.decide(_baseContext(goalJustCompletedTitle: 'Viagem pro Japão'));
      expect(decision.trigger, BlueTrigger.goalCompleted);
      expect(decision.priority, BluePriority.high);
      expect(decision.type, BlueDecisionType.goal);
      expect(decision.message.tone, BlueTone.celebratory);
      expect(decision.message.suggestedMood, BlueMood.celebrating);
      expect(decision.message.text, contains('Viagem pro Japão'));
      expect(decision.shouldDisplay, isTrue);
    });

    test('saldo negativo -> tranquilizador, nunca alarmista', () {
      final decision = engine.decide(_baseContext(balance: -500));
      expect(decision.trigger, BlueTrigger.negativeBalance);
      expect(decision.priority, BluePriority.high);
      expect(decision.message.tone, BlueTone.reassuring);
    });

    test('meta concluída tem prioridade sobre saldo negativo (ordem de avaliação)', () {
      final decision = engine.decide(_baseContext(
        balance: -500,
        goalJustCompletedTitle: 'Reserva de emergência',
      ));
      expect(decision.trigger, BlueTrigger.goalCompleted);
    });
  });

  group('Prioridade média', () {
    test('meta quase concluída (progresso >= 80%) -> cita valor restante', () {
      final decision = engine.decide(_baseContext(
        mostRecentActiveGoal: const BlueGoalSnapshot(
          title: 'Carro novo',
          progress: 0.85,
          remainingAmount: 3000,
        ),
      ));
      expect(decision.trigger, BlueTrigger.goalNearCompletion);
      expect(decision.priority, BluePriority.medium);
      expect(decision.message.text, contains('R\$3.000,00'));
      expect(decision.message.text, contains('Carro novo'));
    });

    test('meta com progresso exatamente 79% não dispara "quase concluída"', () {
      final decision = engine.decide(_baseContext(
        mostRecentActiveGoal: const BlueGoalSnapshot(
          title: 'Carro novo',
          progress: 0.79,
          remainingAmount: 3000,
        ),
      ));
      expect(decision.trigger, isNot(BlueTrigger.goalNearCompletion));
    });

    test('meta com progresso 100% não dispara "quase concluída" (é goalCompleted, outro sinal)', () {
      final decision = engine.decide(_baseContext(
        mostRecentActiveGoal: const BlueGoalSnapshot(
          title: 'Carro novo',
          progress: 1.0,
          remainingAmount: 0,
        ),
      ));
      expect(decision.trigger, isNot(BlueTrigger.goalNearCompletion));
    });

    test('onboarding recém concluído', () {
      final decision = engine.decide(_baseContext(onboardingJustCompleted: true));
      expect(decision.trigger, BlueTrigger.onboardingJustCompleted);
      expect(decision.priority, BluePriority.medium);
      expect(decision.type, BlueDecisionType.onboarding);
    });

    test('retornou após 7 dias de ausência -> dispara', () {
      final decision = engine.decide(_baseContext(daysSinceLastLogin: 7));
      expect(decision.trigger, BlueTrigger.returnedAfterAbsence);
    });

    test('retornou após 6 dias -> não dispara ainda', () {
      final decision = engine.decide(_baseContext(daysSinceLastLogin: 6));
      expect(decision.trigger, isNot(BlueTrigger.returnedAfterAbsence));
    });

    test('primeiro mês de uso', () {
      final decision = engine.decide(_baseContext(isFirstMonthOfUse: true));
      expect(decision.trigger, BlueTrigger.firstMonthOfUse);
      expect(decision.message.tone, BlueTone.celebratory);
    });

    test('mudança significativa de comportamento -> tom curioso, nunca julgador', () {
      final decision = engine.decide(_baseContext(significantBehaviorChangeDetected: true));
      expect(decision.trigger, BlueTrigger.significantBehaviorChange);
      expect(decision.message.tone, BlueTone.curious);
    });

    test('muitas despesas no mês -> tom neutro, descreve sem julgar', () {
      final decision = engine.decide(_baseContext(manyExpensesThisMonth: true));
      expect(decision.trigger, BlueTrigger.manyExpensesThisMonth);
      expect(decision.message.tone, BlueTone.neutral);
    });

    test('primeira receita da vida', () {
      final decision = engine.decide(_baseContext(isFirstIncomeEver: true));
      expect(decision.trigger, BlueTrigger.firstIncome);
      expect(decision.priority, BluePriority.medium);
    });
  });

  group('Prioridade baixa', () {
    test('meta criada -> cita o nome, tom curioso', () {
      final decision = engine.decide(_baseContext(goalJustCreatedTitle: 'Casa própria'));
      expect(decision.trigger, BlueTrigger.goalCreated);
      expect(decision.priority, BluePriority.low);
      expect(decision.message.text, contains('Casa própria'));
    });

    test('primeiro login de sempre', () {
      final decision = engine.decide(_baseContext(isFirstLoginEver: true));
      expect(decision.trigger, BlueTrigger.firstLogin);
    });

    test('primeira semana de uso', () {
      final decision = engine.decide(_baseContext(isFirstWeekOfUse: true));
      expect(decision.trigger, BlueTrigger.firstWeekOfUse);
    });

    test('primeira despesa da vida', () {
      final decision = engine.decide(_baseContext(isFirstExpenseEver: true));
      expect(decision.trigger, BlueTrigger.firstExpense);
    });

    test('14 dias sem transação -> dispara', () {
      final decision = engine.decide(_baseContext(daysSinceLastTransaction: 14));
      expect(decision.trigger, BlueTrigger.noTransactionsInDays);
    });

    test('13 dias sem transação -> não dispara ainda', () {
      final decision = engine.decide(_baseContext(daysSinceLastTransaction: 13));
      expect(decision.trigger, isNot(BlueTrigger.noTransactionsInDays));
    });
  });

  group('Resolução de prioridade entre múltiplos sinais simultâneos', () {
    test('alta prioridade sempre vence sobre média', () {
      final decision = engine.decide(_baseContext(
        balance: -500,
        onboardingJustCompleted: true,
      ));
      expect(decision.trigger, BlueTrigger.negativeBalance);
    });

    test('média prioridade sempre vence sobre baixa', () {
      final decision = engine.decide(_baseContext(
        isFirstMonthOfUse: true,
        isFirstLoginEver: true,
      ));
      expect(decision.trigger, BlueTrigger.firstMonthOfUse);
    });

    test('dentro da mesma prioridade, a ordem de avaliação decide (goalNearCompletion antes de onboarding)', () {
      final decision = engine.decide(_baseContext(
        mostRecentActiveGoal: const BlueGoalSnapshot(
          title: 'Meta X',
          progress: 0.9,
          remainingAmount: 100,
        ),
        onboardingJustCompleted: true,
      ));
      expect(decision.trigger, BlueTrigger.goalNearCompletion);
    });
  });

  group('displayDuration por prioridade', () {
    test('alta prioridade -> 8 segundos', () {
      final decision = engine.decide(_baseContext(balance: -1));
      expect(decision.displayDuration, const Duration(seconds: 8));
    });

    test('média prioridade -> 5 segundos', () {
      final decision = engine.decide(_baseContext(onboardingJustCompleted: true));
      expect(decision.displayDuration, const Duration(seconds: 5));
    });

    test('baixa prioridade -> 3 segundos', () {
      final decision = engine.decide(_baseContext(isFirstLoginEver: true));
      expect(decision.displayDuration, const Duration(seconds: 3));
    });

    test('silêncio -> duração zero', () {
      final decision = engine.decide(_baseContext());
      expect(decision.displayDuration, Duration.zero);
    });
  });

  group('BlueDecision.shouldDisplay', () {
    test('decisão real -> shouldDisplay true', () {
      final decision = engine.decide(_baseContext(isFirstLoginEver: true));
      expect(decision.shouldDisplay, isTrue);
    });

    test('decisão de silêncio -> shouldDisplay false', () {
      final decision = engine.decide(_baseContext());
      expect(decision.shouldDisplay, isFalse);
    });
  });

  group('Determinismo', () {
    test('o mesmo contexto sempre produz a mesma decisão', () {
      final context = _baseContext(isFirstWeekOfUse: true);
      final first = engine.decide(context);
      final second = engine.decide(context);
      expect(first.trigger, second.trigger);
      expect(first.message.text, second.message.text);
      expect(first.priority, second.priority);
    });
  });

  group('Blue Personality Guide — nenhuma decisão usa linguagem julgadora', () {
    final contexts = <String, BlueContext>{
      'goalCompleted': _baseContext(goalJustCompletedTitle: 'Teste'),
      'negativeBalance': _baseContext(balance: -500),
      'goalNearCompletion': _baseContext(
        mostRecentActiveGoal: const BlueGoalSnapshot(title: 'Teste', progress: 0.9, remainingAmount: 50),
      ),
      'onboardingJustCompleted': _baseContext(onboardingJustCompleted: true),
      'returnedAfterAbsence': _baseContext(daysSinceLastLogin: 10),
      'firstMonthOfUse': _baseContext(isFirstMonthOfUse: true),
      'significantBehaviorChange': _baseContext(significantBehaviorChangeDetected: true),
      'manyExpensesThisMonth': _baseContext(manyExpensesThisMonth: true),
      'firstIncome': _baseContext(isFirstIncomeEver: true),
      'goalCreated': _baseContext(goalJustCreatedTitle: 'Teste'),
      'firstLogin': _baseContext(isFirstLoginEver: true),
      'firstWeekOfUse': _baseContext(isFirstWeekOfUse: true),
      'firstExpense': _baseContext(isFirstExpenseEver: true),
      'noTransactionsInDays': _baseContext(daysSinceLastTransaction: 20),
    };

    contexts.forEach((label, context) {
      test('"$label" não contém linguagem banida', () {
        final decision = engine.decide(context);
        final lowerText = decision.message.text.toLowerCase();
        for (final banned in _bannedPhrases) {
          expect(
            lowerText.contains(banned.toLowerCase()),
            isFalse,
            reason: '"$label" contém a expressão banida "$banned": "${decision.message.text}"',
          );
        }
      });
    });
  });
}