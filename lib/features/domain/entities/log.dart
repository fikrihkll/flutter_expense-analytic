import 'package:equatable/equatable.dart';
import 'package:expense_app/features/data/models/floor/results/expenses_result_dto.dart';
import 'package:expense_app/features/data/models/log_model.dart';

class Log extends Equatable{
  final int id;
  final String category;
  final String desc;
  final String date;
  final int day;
  final int month;
  final int year;
  final int nominal;
  final int userId;
  final int fundSourceId;

  const Log({
    required this.id,
    required this.category,
    required this.desc,
    required this.date,
    required this.day,
    required this.month,
    required this.year,
    required this.nominal,
    required this.userId,
    required this.fundSourceId
  });

  factory Log.fromModel(LogModel data) {
    return Log(id: data.id, category: data.category, desc: data.desc, date: data.date, day: 0, month: 0, year: 0, nominal: data.nominal, userId: data.userId, fundSourceId: data.fundSourceId);
  }

  @override
  List<Object?> get props => [
    id,
    category,
    desc,
    date,
    month,
    year,
    nominal,
    userId
  ];
}