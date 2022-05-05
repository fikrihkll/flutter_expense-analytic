import 'package:expense_app/features/domain/entities/log.dart';

class LogModel extends Log{
  final int id;
  final String category;
  final String desc;
  final String date;
  final int month;
  final int year;
  final int nominal;
  final int userId;

  const LogModel({
    required this.id,
    required this.category,
    required this.desc,
    required this.date,
    required this.month,
    required this.year,
    required this.nominal,
    required this.userId
  }):super(
    id: id,
    category: category,
    desc: desc,
    date: date,
    month: month,
    year: year,
    nominal: nominal,
    userId: userId
  );

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