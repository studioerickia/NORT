import '../domain/entities/blue_message.dart';
import 'blue_state.dart';

BlueState mapBlueMoodToState(BlueMood mood) {
  switch (mood) {
    case BlueMood.idle:
      return BlueState.idle;
    case BlueMood.thinking:
      return BlueState.thinking;
    case BlueMood.celebrating:
      return BlueState.celebrating;
    case BlueMood.reassuring:
      return BlueState.idle;
  }
}