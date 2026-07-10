enum CategoryType { income, expense, both }

class Category {
  const Category({
    required this.id,
    this.userId,
    required this.name,
    this.icon,
    required this.type,
  });

  final String id;
  final String? userId;
  final String name;
  final String? icon;
  final CategoryType type;

  @override
  bool operator ==(Object other) => other is Category && other.id == id;

  @override
  int get hashCode => id.hashCode;
}