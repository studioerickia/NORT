import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/personality/blue_rules_engine.dart';
import '../../domain/personality/deterministic_blue_rules_engine.dart';

final blueRulesEngineProvider = Provider<BlueRulesEngine>((ref) {
  return const DeterministicBlueRulesEngine();
});
