import 'dart:typed_data';

import '../entities/goal.dart';

abstract class GoalsRepository {
  Stream<List<Goal>> watchGoals();

  Future<List<Goal>> fetchDeletedGoals();

  Future<Goal> createGoal({
    required String title,
    required double targetAmount,
    double currentAmount = 0,
    DateTime? targetDate,
    GoalStatus status = GoalStatus.active,
  });

  Future<void> updateGoal({
    required String id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    GoalStatus? status,
  });

  Future<void> softDeleteGoal(String id);

  Future<void> restoreGoal(String id);

  Future<String> uploadGoalImage({
    required String goalId,
    required Uint8List bytes,
    required String fileExtension,
  });
}