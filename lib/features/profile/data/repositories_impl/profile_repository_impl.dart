import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._datasource, this._client);

  final ProfileRemoteDatasource _datasource;
  final SupabaseClient _client;

  String get _requireUserId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw StateError('Nenhum usuário logado.');
    return id;
  }

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

  @override
  Future<void> updateDisplayName(String name) async {
    await _datasource.updateProfileRow(_requireUserId, {'display_name': name});
  }

  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final userId = _requireUserId;
    final path = '$userId/avatar.$fileExtension';

    await _client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: _mimeTypeFor(fileExtension),
          ),
        );

    final publicUrl = _client.storage.from('avatars').getPublicUrl(path);
    final bustedUrl = '$publicUrl?updated=${DateTime.now().millisecondsSinceEpoch}';

    await _datasource.updateProfileRow(userId, {'avatar_url': bustedUrl});
    return bustedUrl;
  }

  @override
  Future<void> completeOnboarding() async {
    await _datasource.updateProfileRow(_requireUserId, {
      'onboarding_completed_at': DateTime.now().toIso8601String(),
    });
  }

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