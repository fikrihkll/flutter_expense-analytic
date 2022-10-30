import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/domain/entities/log.dart';

class LogModel extends Log{
  final int id;
  final int userId;
  final int? fundSourceId;
  final String category;
  final String description;
  final String date;
  final int day;
  final int month;
  final int year;
  final int nominal;
  final String? fundSourceName;

  const LogModel({
    required this.id,
    required this.userId,
    required this.fundSourceId,
    required this.category,
    required this.description,
    required this.date,
    required this.nominal,
    required this.fundSourceName,
    required this.day,
    required this.month,
    required this.year
  }):super(
    id: id,
    userId: userId,
    fundSourceId: fundSourceId,
    category: category,
    description: description,
    date: date,
    nominal: nominal,
    fundSourceName: fundSourceName,
    day: day,
    month: month,
    year: year
  );

  factory LogModel.fromMap(Map<String, dynamic> map){
    return LogModel(
        id: map['id'],
        userId: map['user_id'],
        fundSourceId: map['fund_source_id'],
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
      'id': data.id > 0 ? data.id : null,
      'user_id': data.userId,
      'fund_source_id': data.fundSourceId,
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
    day,
    month,
    year
  ];
}