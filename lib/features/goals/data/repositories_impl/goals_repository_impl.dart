import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/goal.dart';
import '../../domain/repositories/goals_repository.dart';
import '../datasources/goals_remote_datasource.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  GoalsRepositoryImpl(this._datasource, this._client);

  final GoalsRemoteDatasource _datasource;
  final SupabaseClient _client;

  String get _requireUserId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw StateError('Nenhum usuário logado.');
    return id;
  }

  @override
  Stream<List<Goal>> watchGoals() {
    return _datasource.watchGoals(_requireUserId).map(
          (rows) => rows.map(_mapRow).toList(),
        );
  }

  @override
  Future<List<Goal>> fetchDeletedGoals() async {
    final rows = await _datasource.fetchDeletedGoals(_requireUserId);
    return rows.map(_mapRow).toList();
  }

  @override
  Future<Goal> createGoal({
    required String title,
    required double targetAmount,
    double currentAmount = 0,
    DateTime? targetDate,
    GoalStatus status = GoalStatus.active,
  }) async {
    final row = await _datasource.insertGoal({
      'user_id': _requireUserId,
      'title': title,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'target_date': targetDate != null ? _dateOnly(targetDate) : null,
      'status': status.name,
    });
    return _mapRow(row);
  }

  @override
  Future<void> updateGoal({
    required String id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    GoalStatus? status,
  }) async {
    final changes = <String, dynamic>{};
    if (title != null) changes['title'] = title;
    if (targetAmount != null) changes['target_amount'] = targetAmount;
    if (currentAmount != null) changes['current_amount'] = currentAmount;
    if (targetDate != null) changes['target_date'] = _dateOnly(targetDate);
    if (status != null) changes['status'] = status.name;

    if (changes.isEmpty) return;
    await _datasource.updateGoal(id, changes);
  }

  @override
  Future<void> softDeleteGoal(String id) async {
    await _datasource.updateGoal(id, {
      'deleted_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> restoreGoal(String id) async {
    await _datasource.updateGoal(id, {'deleted_at': null});
  }

  @override
  Future<String> uploadGoalImage({
    required String goalId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final userId = _requireUserId;
    final path = '$userId/$goalId.$fileExtension';

    await _client.storage.from('goal-images').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: _mimeTypeFor(fileExtension),
          ),
        );

    final publicUrl = _client.storage.from('goal-images').getPublicUrl(path);
    final bustedUrl = '$publicUrl?updated=${DateTime.now().millisecondsSinceEpoch}';

    await _datasource.updateGoal(goalId, {'image_url': bustedUrl});
    return bustedUrl;
  }

  Goal _mapRow(Map<String, dynamic> row) {
    return Goal(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      title: row['title'] as String,
      targetAmount: (row['target_amount'] as num).toDouble(),
      currentAmount: (row['current_amount'] as num).toDouble(),
      targetDate: row['target_date'] != null
          ? DateTime.parse(row['target_date'] as String)
          : null,
      imageUrl: row['image_url'] as String?,
      icon: row['icon'] as String?,
      status: _statusFromString(row['status'] as String),
      sortOrder: row['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      deletedAt: row['deleted_at'] != null
          ? DateTime.parse(row['deleted_at'] as String)
          : null,
    );
  }

  GoalStatus _statusFromString(String value) {
    return GoalStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => GoalStatus.active,
    );
  }

  String _dateOnly(DateTime date) => date.toIso8601String().split('T').first;

  String _mimeTypeFor(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }
}