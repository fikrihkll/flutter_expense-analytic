import 'package:expense_app/features/data/datasources/localdatasource/tables/log_table.dart';
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

  factory LogModel.fromEntity(LogTable entity){
    return LogModel(id: entity.id, category: entity.category, desc: entity.desc, date: entity.date, month: entity.month, year: entity.year, nominal: entity.nominal, userId: entity.userId);
  }

  static LogTable toEntity(Log data){
    return LogTable(id: data.id, category: data.category, desc: data.desc, date: data.date, month: data.month, year: data.year, nominal: data.nominal, userId: data.userId);
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