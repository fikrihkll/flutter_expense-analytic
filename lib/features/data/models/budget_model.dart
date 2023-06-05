
/// LOCAL TABLE
/// budgets
class BudgetModel {
  int id;
  String name;
  String description;
  String ownerUserId;
  String currency;
  DateTime dateCreated;
  DateTime dateUpdated;

  BudgetModel({
    required this.id,
    required this.name,
    required this.ownerUserId,
    required this.currency,
    required this.description,
    required this.dateCreated,
    required this.dateUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'owner_user_id': ownerUserId,
      'description': description,
      'currency': currency,
      'date_created': dateCreated.toIso8601String(),
      'date_updated': dateUpdated.toIso8601String(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      name: map['name'],
      ownerUserId: map['owner_user_id'],
      currency: map['currency'],
      description: map['description'],
      dateCreated: map['date_created'] != null ? DateTime.parse(map['date_created']) : DateTime.now(),
      dateUpdated: map['date_updated'] != null ? DateTime.parse(map['date_updated']) : DateTime.now(),
    );
  }
}