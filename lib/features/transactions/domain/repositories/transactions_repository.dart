import '../entities/category.dart';
import '../entities/transaction.dart';

abstract class TransactionsRepository {
  Stream<List<Transaction>> watchTransactions();

  Future<List<Category>> fetchCategories();

  Future<Transaction> createTransaction({
    required double amount,
    required TransactionType type,
    String? description,
    String? categoryId,
    required DateTime occurredAt,
  });

  Future<void> updateTransaction({
    required String id,
    double? amount,
    TransactionType? type,
    String? description,
    String? categoryId,
    DateTime? occurredAt,
  });

  Future<void> softDeleteTransaction(String id);

  Future<void> restoreTransaction(String id);
}
