import 'package:equatable/equatable.dart';

class Log extends Equatable{
  final int id;
  final int userId;
  final int? fundSourceId;
  final String category;
  final String description;
  final String date;
  final double nominal;
  final int day;
  final int month;
  final int year;
  final String? fundSourceName;

  const Log({
    required this.id,
    required this.userId,
    required this.fundSourceId,
    required this.category,
    required this.description,
    required this.date,
    required this.nominal,
    required this.day,
    required this.month,
    required this.year,
    required this.fundSourceName,
  });

  @override
  List<Object?> get props => [
    id,
    category,
    description,
    date,
    nominal,
    userId,
    fundSourceId,
    fundSourceName,
  ];
}