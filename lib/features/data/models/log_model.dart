import 'package:expense_app/core/util/date_util.dart';


/// LOCAL TABLE
/// expenses
class LogModel {
  final String id;
  final String userId;
  final String? fundSourceId;
  final String? budgetId;
  final String category;
  final String description;
  final String date;
  final int day;
  final int month;
  final int year;
  final double nominal;
  final String? fundSourceName; // not part of the table

  const LogModel({
    required this.id,
    required this.userId,
    required this.fundSourceId,
    required this.budgetId,
    required this.category,
    required this.description,
    required this.date,
    required this.nominal,
    required this.fundSourceName,
    required this.day,
    required this.month,
    required this.year
  });

  factory LogModel.fromMap(Map<String, dynamic> map){
    return LogModel(
        id: map['id'].toString(),
        userId: map['user_id'].toString(),
        fundSourceId: map['fund_source_id'].toString(),
        budgetId: map['budget_id'].toString(),
        category: map['category'],
        description: map['description'],
        date: map['date'],
        nominal: map['nominal'],
        fundSourceName: map['fund_source_name'],
        day: map['day'],
        month: map['month'],
        year: map['year'],
    );
  }

  static Map<String, dynamic> toMap(LogModel data){
    return {
      'id': data.id.isNotEmpty ? data.id : null,
      'user_id': data.userId,
      'fund_source_id': data.fundSourceId,
      'budget_id': data.budgetId,
      'category': data.category,
      'description': data.description,
      'date': data.date,
      'nominal': data.nominal,
      'day': data.day,
      'month': data.month,
      'year': data.year,
      'created_at': DateUtil.dbFormat.format(DateTime.now()),
      'updated_at': DateUtil.dbFormat.format(DateTime.now())
    };
  }

  @override
  List<Object?> get props => [
    id,
    category,
    description,
    date,
    nominal,
    userId,
    fundSourceId,
    budgetId,
    day,
    month,
    year
  ];
}