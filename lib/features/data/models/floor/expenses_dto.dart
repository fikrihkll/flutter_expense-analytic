import 'package:floor/floor.dart';

@Entity(tableName: "expenses")
class ExpensesDTO {

  @PrimaryKey(autoGenerate: true)
  int? id;
  int user_id;
  int fund_source_id;
  String description;
  String category;
  int nominal;
  String date;
  String created_at;
  String updated_at;

  ExpensesDTO({
    required this.id,
    required this.user_id,
    required this.fund_source_id,
    required this.description,
    required this.category,
    required this.nominal,
    required this.date,
    required this.created_at,
    required this.updated_at
  });

}