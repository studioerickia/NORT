import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase/auth_service.dart';
import '../../../../core/services/supabase/supabase_auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return SupabaseAuthService(Supabase.instance.client);
});

final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});