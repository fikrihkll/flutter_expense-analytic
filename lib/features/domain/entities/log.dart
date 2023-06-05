import 'package:equatable/equatable.dart';

import '../../data/models/log_model.dart';

class Log extends Equatable{
  final String id;
  final String userId;
  final String? fundSourceId;
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

  static Log fromModel(LogModel model) {
    return Log(
      id: model.id,
      userId: model.userId,
      fundSourceId: model.fundSourceId,
      category: model.category,
      description: model.description,
      date: model.date,
      nominal: model.nominal,
      day: model.day,
      month: model.month,
      year: model.year,
      fundSourceName: model.fundSourceName
    );
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
    fundSourceName,
  ];
}