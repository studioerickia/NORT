import 'formatters.dart';

class BlueGreeting {
  const BlueGreeting({required this.salutation, required this.reassurance});

  final String salutation;
  final String reassurance;
}

BlueGreeting buildBlueGreeting({required DateTime now, String? firstName}) {
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

  const reassurances = [
    'Nada para se preocupar agora.',
    'Hoje está tudo sob controle.',
    'Você está indo muito bem.',
    'Um passo de cada vez, no seu ritmo.',
  ];
  final reassurance = reassurances[now.day % reassurances.length];

  return BlueGreeting(salutation: salutation, reassurance: reassurance);
}

String buildGoalObservation({
  required double progress,
  required double remainingAmount,
}) {
  if (progress >= 0.8) {
    return 'Faltam apenas ${formatCurrencyBRL(remainingAmount)}.';
  }
  if (progress >= 0.4) {
    return 'Você está mais perto do que imagina.';
  }
  return 'Continue assim.';
}