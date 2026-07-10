import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsRemoteDatasource {
  TransactionsRemoteDatasource(this._client);

  final SupabaseClient _client;

  Stream<List<Map<String, dynamic>>> watchTransactions(String userId) {
    return _client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('occurred_at', ascending: false)
        .map((rows) => rows.where((row) => row['deleted_at'] == null).toList());
  }

  Future<List<Map<String, dynamic>>> fetchCategories(String userId) async {
    final rows = await _client
        .from('categories')
        .select()
        .or('user_id.is.null,user_id.eq.$userId')
        .order('name');
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<Map<String, dynamic>> insertTransaction(Map<String, dynamic> values) async {
    final row = await _client.from('transactions').insert(values).select().single();
    return row;
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> changes) async {
    await _client.from('transactions').update(changes).eq('id', id);
  }
}