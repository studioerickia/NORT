import 'package:flutter_test/flutter_test.dart';
import 'package:nort/blue/domain/entities/blue_message.dart';
import 'package:nort/blue/domain/personality/blue_rules_engine.dart';
import 'package:nort/blue/domain/personality/deterministic_blue_rules_engine.dart';

const _bannedPhrases = [
  'gastar demais',
  'você deveria',
  'precisa urgentemente',
  'atenção!',
  'cuidado!',
  'erro',
  'você errou',
];

void main() {
  const engine = DeterministicBlueRulesEngine();

  group('greeting — horários (Guide, seção 5)', () {
    test('05:00 é manhã (limite inferior)', () {
      final result = engine.greeting(now: DateTime(2026, 1, 1, 5, 0), firstName: 'Erick');
      expect(result.salutation, 'Bom dia, Erick');
    });

    test('11:59 ainda é manhã', () {
      final result = engine.greeting(now: DateTime(2026, 1, 1, 11, 59));
      expect(result.salutation, 'Bom dia');
    });

    test('12:00 é tarde (limite inferior)', () {
      final result = engine.greeting(now: DateTime(2026, 1, 1, 12, 0));
      expect(result.salutation, 'Boa tarde');
    });

    test('17:59 ainda é tarde', () {
      final result = engine.greeting(now: DateTime(2026, 1, 1, 17, 59));
      expect(result.salutation, 'Boa tarde');
    });

    test('18:00 é noite (limite inferior)', () {
      final result = engine.greeting(now: DateTime(2026, 1, 1, 18, 0));
      expect(result.salutation, 'Boa noite');
    });

    test('04:59 ainda é noite (antes do corte da manhã)', () {
      final result = engine.greeting(now: DateTime(2026, 1, 1, 4, 59));
      expect(result.salutation, 'Boa noite');
    });

    test('sem nome, saudação não deixa vírgula solta', () {
      final result = engine.greeting(now: DateTime(2026, 1, 1, 9, 0));
      expect(result.salutation, 'Bom dia');
      expect(result.salutation.contains(','), isFalse);
    });

    test('reassurance sempre é exibida (não é silêncio)', () {
      final result = engine.greeting(now: DateTime(2026, 1, 1, 9, 0));
      expect(result.reassurance.shouldDisplay, isTrue);
      expect(result.reassurance.text, isNotEmpty);
    });
  });

  group('goalObservation — progresso (Guide, seções 6 e 7)', () {
    test('sem progresso (0%) -> silêncio deliberado', () {
      final result = engine.goalObservation(progress: 0, remainingAmount: 1000, isCompleted: false);
      expect(result.shouldDisplay, isFalse);
      expect(result.ruleId, 'goal.no_progress');
    });

    test('em andamento inicial (< 40%) -> incentivo neutro', () {
      final result = engine.goalObservation(progress: 0.2, remainingAmount: 800, isCompleted: false);
      expect(result.shouldDisplay, isTrue);
      expect(result.text, 'Continue assim.');
    });

    test('em andamento avançado (40%–79%) -> "mais perto do que imagina"', () {
      final result = engine.goalObservation(progress: 0.5, remainingAmount: 500, isCompleted: false);
      expect(result.text, contains('mais perto'));
    });

    test('quase concluída (>= 80%) -> cita o valor restante formatado', () {
      final result = engine.goalObservation(progress: 0.85, remainingAmount: 230, isCompleted: false);
      expect(result.text, contains('R\$230,00'));
      expect(result.tone, BlueTone.reassuring);
    });

    test('concluída -> celebração, cita o nome da meta', () {
      final result = engine.goalObservation(
        progress: 1.0,
        remainingAmount: 0,
        isCompleted: true,
        goalTitle: 'Viagem pro Japão',
      );
      expect(result.tone, BlueTone.celebratory);
      expect(result.suggestedMood, BlueMood.celebrating);
      expect(result.text, contains('Viagem pro Japão'));
    });

    test('concluída sem nome da meta não quebra', () {
      final result = engine.goalObservation(progress: 1.0, remainingAmount: 0, isCompleted: true);
      expect(result.shouldDisplay, isTrue);
      expect(result.text, isNotEmpty);
    });
  });

  group('balanceObservation — limites de saldo (Guide, seção 7)', () {
    test('saldo positivo -> silêncio (o número já fala por si)', () {
      final result = engine.balanceObservation(balance: 5450);
      expect(result.shouldDisplay, isFalse);
    });

    test('saldo exatamente zero -> silêncio (não é negativo)', () {
      final result = engine.balanceObservation(balance: 0);
      expect(result.shouldDisplay, isFalse);
    });

    test('saldo levemente negativo -> mensagem tranquilizadora', () {
      final result = engine.balanceObservation(balance: -0.01);
      expect(result.shouldDisplay, isTrue);
      expect(result.tone, BlueTone.reassuring);
    });

    test('saldo bem negativo -> tom continua tranquilizador, nunca escala pra alarme', () {
      final result = engine.balanceObservation(balance: -10000);
      expect(result.tone, BlueTone.reassuring);
      expect(result.suggestedMood, BlueMood.reassuring);
    });
  });

  group('emptyStateMessage', () {
    test('sem metas ativas', () {
      final result = engine.emptyStateMessage(BlueEmptyStateKind.noActiveGoals);
      expect(result.shouldDisplay, isTrue);
      expect(result.text, isNotEmpty);
    });

    test('sem transações', () {
      final result = engine.emptyStateMessage(BlueEmptyStateKind.noTransactions);
      expect(result.shouldDisplay, isTrue);
      expect(result.text, isNotEmpty);
    });
  });

  group('Blue Personality Guide — nenhuma mensagem usa linguagem julgadora', () {
    final allMessages = <BlueMessage>[
      engine.greeting(now: DateTime(2026, 1, 1, 8, 0), firstName: 'Erick').reassurance,
      engine.greeting(now: DateTime(2026, 1, 1, 14, 0)).reassurance,
      engine.greeting(now: DateTime(2026, 1, 1, 22, 0)).reassurance,
      engine.goalObservation(progress: 0.2, remainingAmount: 800, isCompleted: false),
      engine.goalObservation(progress: 0.5, remainingAmount: 500, isCompleted: false),
      engine.goalObservation(progress: 0.9, remainingAmount: 100, isCompleted: false),
      engine.goalObservation(progress: 1.0, remainingAmount: 0, isCompleted: true, goalTitle: 'Teste'),
      engine.balanceObservation(balance: -500),
      engine.emptyStateMessage(BlueEmptyStateKind.noActiveGoals),
      engine.emptyStateMessage(BlueEmptyStateKind.noTransactions),
    ];

    for (final message in allMessages) {
      test('"${message.ruleId}" não contém linguagem banida', () {
        final lowerText = message.text.toLowerCase();
        for (final banned in _bannedPhrases) {
          expect(
            lowerText.contains(banned.toLowerCase()),
            isFalse,
            reason: '"${message.ruleId}" contém a expressão banida "$banned": "${message.text}"',
          );
        }
      });
    }
  });
}