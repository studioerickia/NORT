import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories_impl/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = Supabase.instance.client;
  return ProfileRepositoryImpl(ProfileRemoteDatasource(client), client);
});

final currentProfileProvider = FutureProvider<UserProfile?>((ref) {
  return ref.watch(profileRepositoryProvider).getCurrentProfile();
});