import 'package:floor/floor.dart';

@entity
class LogTable{

  @primaryKey
  final int id;
  final String category;
  final String desc;
  final String date;
  final int month;
  final int year;
  final int nominal;
  final int userId;

  const LogTable({
    required this.id,
    required this.category,
    required this.desc,
    required this.date,
    required this.month,
    required this.year,
    required this.nominal,
    required this.userId
  });

}