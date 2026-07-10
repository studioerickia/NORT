import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/transactions_remote_datasource.dart';
import '../../data/repositories_impl/transactions_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transactions_repository.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  final client = Supabase.instance.client;
  return TransactionsRepositoryImpl(TransactionsRemoteDatasource(client), client);
});

final transactionsStreamProvider = StreamProvider<List<Transaction>>((ref) {
  return ref.watch(transactionsRepositoryProvider).watchTransactions();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(transactionsRepositoryProvider).fetchCategories();
});