import 'dart:typed_data';

import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getCurrentProfile();

  Future<void> updateDisplayName(String name);

  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String fileExtension,
  });

  Future<void> completeOnboarding();
}
