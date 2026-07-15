import '../../../core/utils/formatters.dart';
import '../entities/blue_greeting.dart';
import '../entities/blue_message.dart';
import 'blue_rules_engine.dart';

class DeterministicBlueRulesEngine implements BlueRulesEngine {
  const DeterministicBlueRulesEngine();

  static const List<String> _reassurances = [
    'Nada para se preocupar agora.',
    'Hoje está tudo sob controle.',
    'Você está indo muito bem.',
    'Um passo de cada vez, no seu ritmo.',
  ];

  @override
  BlueGreeting greeting({required DateTime now, String? firstName}) {
    final hour = now.hour;
    final String salutationWord;
    if (hour >= 5 && hour < 12) {
      salutationWord = 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      salutationWord = 'Boa tarde';
    } else {
      salutationWord = 'Boa noite';
    }

    final salutation = (firstName != null && firstName.isNotEmpty)
        ? '$salutationWord, $firstName'
        : salutationWord;

    final reassuranceText = _reassurances[now.day % _reassurances.length];

    return BlueGreeting(
      salutation: salutation,
      reassurance: BlueMessage(
        text: reassuranceText,
        tone: BlueTone.reassuring,
        ruleId: 'greeting.reassurance',
        suggestedMood: BlueMood.idle,
      ),
    );
  }

  @override
  BlueMessage goalObservation({
    required double progress,
    required double remainingAmount,
    required bool isCompleted,
    String? goalTitle,
  }) {
    if (isCompleted) {
      final title =
          (goalTitle != null && goalTitle.isNotEmpty) ? ' "$goalTitle"' : '';
      return BlueMessage(
        text: 'Você concluiu a meta$title. Isso é resultado de constância.',
        tone: BlueTone.celebratory,
        ruleId: 'goal.completed',
        suggestedMood: BlueMood.celebrating,
      );
    }

    if (progress >= 0.8) {
      return BlueMessage(
        text: 'Faltam apenas ${formatCurrencyBRL(remainingAmount)}.',
        tone: BlueTone.reassuring,
        ruleId: 'goal.near_complete',
        suggestedMood: BlueMood.idle,
      );
    }

    if (progress >= 0.4) {
      return const BlueMessage(
        text: 'Você está mais perto do que imagina.',
        tone: BlueTone.reassuring,
        ruleId: 'goal.in_progress',
        suggestedMood: BlueMood.idle,
      );
    }

    if (progress > 0) {
      return const BlueMessage(
        text: 'Continue assim.',
        tone: BlueTone.neutral,
        ruleId: 'goal.early_progress',
        suggestedMood: BlueMood.idle,
      );
    }

    return const BlueMessage.silence(ruleId: 'goal.no_progress');
  }

  @override
  BlueMessage balanceObservation({required double balance}) {
    if (balance < 0) {
      return const BlueMessage(
        text:
            'Seu saldo está negativo esse mês. Sem alarme — quando quiser, a gente organiza isso com calma.',
        tone: BlueTone.reassuring,
        ruleId: 'balance.negative',
        suggestedMood: BlueMood.reassuring,
      );
    }
    return const BlueMessage.silence(ruleId: 'balance.non_negative');
  }

  @override
  BlueMessage emptyStateMessage(BlueEmptyStateKind kind) {
    switch (kind) {
      case BlueEmptyStateKind.noActiveGoals:
        return const BlueMessage(
          text: 'Sua próxima conquista começa aqui.',
          tone: BlueTone.reassuring,
          ruleId: 'empty.no_active_goals',
          suggestedMood: BlueMood.idle,
        );
      case BlueEmptyStateKind.noTransactions:
        return const BlueMessage(
          text: 'Suas transações vão aparecer aqui, sem pressa pra começar.',
          tone: BlueTone.reassuring,
          ruleId: 'empty.no_transactions',
          suggestedMood: BlueMood.idle,
        );
    }
  }
}
