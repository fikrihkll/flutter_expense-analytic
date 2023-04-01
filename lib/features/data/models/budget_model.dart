class BudgetModel {
  int id;
  String name;
  String description;
  DateTime dateCreated;
  DateTime dateUpdated;

  BudgetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.dateCreated,
    required this.dateUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date_created': dateCreated.toIso8601String(),
      'date_updated': dateUpdated.toIso8601String(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dateCreated: map['date_created'] != null ? DateTime.parse(map['date_created']) : DateTime.now(),
      dateUpdated: map['date_updated'] != null ? DateTime.parse(map['date_updated']) : DateTime.now(),
    );
  }
}