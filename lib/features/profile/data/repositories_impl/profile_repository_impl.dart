import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._datasource, this._client);

  final ProfileRemoteDatasource _datasource;
  final SupabaseClient _client;

  @override
  Future<UserProfile?> getCurrentProfile() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return null;

    final row = await _datasource.fetchProfileRow(authUser.id);

    if (row == null) {
      return UserProfile(
        id: authUser.id,
        email: authUser.email ?? '',
        locale: 'pt-BR',
        timezone: 'America/Sao_Paulo',
      );
    }

    return UserProfile(
      id: row['id'] as String,
      email: authUser.email ?? '',
      displayName: row['display_name'] as String?,
      avatarUrl: row['avatar_url'] as String?,
      locale: row['locale'] as String? ?? 'pt-BR',
      timezone: row['timezone'] as String? ?? 'America/Sao_Paulo',
      onboardingCompletedAt: row['onboarding_completed_at'] != null
          ? DateTime.parse(row['onboarding_completed_at'] as String)
          : null,
    );
  }
}