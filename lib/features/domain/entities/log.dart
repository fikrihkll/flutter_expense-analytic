import 'package:equatable/equatable.dart';

class Log extends Equatable{
  final int id;
  final String category;
  final String desc;
  final String date;
  final int month;
  final int year;
  final int nominal;
  final int userId;

  const Log({
    required this.id,
    required this.category,
    required this.desc,
    required this.date,
    required this.month,
    required this.year,
    required this.nominal,
    required this.userId
  });

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