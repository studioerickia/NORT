import 'package:supabase_flutter/supabase_flutter.dart';

class GoalsRemoteDatasource {
  GoalsRemoteDatasource(this._client);

  final SupabaseClient _client;

  Stream<List<Map<String, dynamic>>> watchGoals(String userId) {
    return _client
        .from('goals')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('sort_order')
        .map((rows) => rows.where((row) => row['deleted_at'] == null).toList());
  }

  Future<List<Map<String, dynamic>>> fetchDeletedGoals(String userId) async {
    final rows = await _client
        .from('goals')
        .select()
        .eq('user_id', userId)
        .not('deleted_at', 'is', null)
        .order('deleted_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<Map<String, dynamic>> insertGoal(Map<String, dynamic> values) async {
    final row = await _client.from('goals').insert(values).select().single();
    return row;
  }

  Future<void> updateGoal(String id, Map<String, dynamic> changes) async {
    await _client.from('goals').update(changes).eq('id', id);
  }
}