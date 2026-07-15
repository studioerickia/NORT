import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/transactions_remote_datasource.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl(this._datasource, this._client);

  final TransactionsRemoteDatasource _datasource;
  final SupabaseClient _client;

  String get _requireUserId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw StateError('Nenhum usuário logado.');
    return id;
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return _datasource.watchTransactions(_requireUserId).map(
          (rows) => rows.map(_mapTransactionRow).toList(),
        );
  }

  @override
  Future<List<Category>> fetchCategories() async {
    final rows = await _datasource.fetchCategories(_requireUserId);
    return rows.map(_mapCategoryRow).toList();
  }

  @override
  Future<Transaction> createTransaction({
    required double amount,
    required TransactionType type,
    String? description,
    String? categoryId,
    required DateTime occurredAt,
  }) async {
    final row = await _datasource.insertTransaction({
      'user_id': _requireUserId,
      'amount': amount,
      'type': type.name,
      'description': description,
      'category_id': categoryId,
      'occurred_at': occurredAt.toIso8601String(),
    });
    return _mapTransactionRow(row);
  }

  @override
  Future<void> updateTransaction({
    required String id,
    double? amount,
    TransactionType? type,
    String? description,
    String? categoryId,
    DateTime? occurredAt,
  }) async {
    final changes = <String, dynamic>{};
    if (amount != null) changes['amount'] = amount;
    if (type != null) changes['type'] = type.name;
    if (description != null) changes['description'] = description;
    if (categoryId != null) changes['category_id'] = categoryId;
    if (occurredAt != null) {
      changes['occurred_at'] = occurredAt.toIso8601String();
    }

    if (changes.isEmpty) return;
    await _datasource.updateTransaction(id, changes);
  }

  @override
  Future<void> softDeleteTransaction(String id) async {
    await _datasource.updateTransaction(id, {
      'deleted_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> restoreTransaction(String id) async {
    await _datasource.updateTransaction(id, {'deleted_at': null});
  }

  Transaction _mapTransactionRow(Map<String, dynamic> row) {
    return Transaction(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      categoryId: row['category_id'] as String?,
      goalId: row['goal_id'] as String?,
      amount: (row['amount'] as num).toDouble(),
      type: _transactionTypeFromString(row['type'] as String),
      description: row['description'] as String?,
      occurredAt: DateTime.parse(row['occurred_at'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      deletedAt: row['deleted_at'] != null
          ? DateTime.parse(row['deleted_at'] as String)
          : null,
    );
  }

  Category _mapCategoryRow(Map<String, dynamic> row) {
    return Category(
      id: row['id'] as String,
      userId: row['user_id'] as String?,
      name: row['name'] as String,
      icon: row['icon'] as String?,
      type: _categoryTypeFromString(row['type'] as String),
    );
  }

  TransactionType _transactionTypeFromString(String value) {
    return TransactionType.values.firstWhere(
      (t) => t.name == value,
      orElse: () => TransactionType.expense,
    );
  }

  CategoryType _categoryTypeFromString(String value) {
    return CategoryType.values.firstWhere(
      (t) => t.name == value,
      orElse: () => CategoryType.both,
    );
  }
}
