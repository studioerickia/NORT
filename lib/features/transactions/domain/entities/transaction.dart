enum TransactionType { income, expense }

class Transaction {
  const Transaction({
    required this.id,
    required this.userId,
    this.categoryId,
    this.goalId,
    required this.amount,
    required this.type,
    this.description,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String? categoryId;
  final String? goalId;
  final double amount;
  final TransactionType type;
  final String? description;
  final DateTime occurredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}