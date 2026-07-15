import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/goals_remote_datasource.dart';
import '../../data/repositories_impl/goals_repository_impl.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goals_repository.dart';

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  final client = Supabase.instance.client;
  return GoalsRepositoryImpl(GoalsRemoteDatasource(client), client);
});

final goalsStreamProvider = StreamProvider<List<Goal>>((ref) {
  return ref.watch(goalsRepositoryProvider).watchGoals();
});

final deletedGoalsProvider = FutureProvider.autoDispose<List<Goal>>((ref) {
  return ref.watch(goalsRepositoryProvider).fetchDeletedGoals();
});
