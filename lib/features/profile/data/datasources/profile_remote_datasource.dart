import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDatasource {
  ProfileRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>?> fetchProfileRow(String userId) async {
    final row =
        await _client.from('profiles').select().eq('id', userId).maybeSingle();
    return row;
  }

  Future<void> updateProfileRow(
      String userId, Map<String, dynamic> changes) async {
    await _client.from('profiles').update(changes).eq('id', userId);
  }
}
