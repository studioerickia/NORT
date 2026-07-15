import 'package:supabase_flutter/supabase_flutter.dart' show User;

abstract class AuthService {
  User? get currentUser;

  bool get isLoggedIn;

  Future<void> signUpWithEmail(
      {required String email, required String password});

  Future<void> signInWithEmail(
      {required String email, required String password});

  Future<void> signOut();
}
