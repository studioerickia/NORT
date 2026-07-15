import '../entities/blue_context.dart';
import '../entities/blue_decision.dart';

abstract class BlueDecisionEngine {
  BlueDecision decide(BlueContext context);
}
