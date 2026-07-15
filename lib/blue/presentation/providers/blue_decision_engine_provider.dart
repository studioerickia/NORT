import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/brain/blue_decision_engine.dart';
import '../../domain/brain/deterministic_decision_engine.dart';

final blueDecisionEngineProvider = Provider<BlueDecisionEngine>((ref) {
  return const DeterministicDecisionEngine();
});
