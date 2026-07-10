import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';

class SupabaseAuthService implements AuthService {
  SupabaseAuthService(this._client);

  final SupabaseClient _client;

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  bool get isLoggedIn => _client.auth.currentSession != null;

  @override
  Future<void> signUpWithEmail({required String email, required String password}) async {
    await _client.auth.signUp(email: email, password: password);
  }

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}