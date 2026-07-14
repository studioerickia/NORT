enum BlueTone { neutral, celebratory, reassuring, curious, cautious }

enum BlueMood { idle, thinking, celebrating, reassuring, curious, concerned }

class BlueMessage {
  const BlueMessage({
    required this.text,
    required this.tone,
    required this.ruleId,
    required this.suggestedMood,
    this.shouldDisplay = true,
  });

  const BlueMessage.silence({required this.ruleId})
      : text = '',
        tone = BlueTone.neutral,
        suggestedMood = BlueMood.idle,
        shouldDisplay = false;

  final String text;
  final BlueTone tone;
  final String ruleId;
  final BlueMood suggestedMood;
  final bool shouldDisplay;
}