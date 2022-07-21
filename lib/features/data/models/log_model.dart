import 'package:expense_app/features/domain/entities/log.dart';

class LogModel extends Log{
  final int id;
  final String category;
  final String desc;
  final String date;
  final int day;
  final int month;
  final int year;
  final int nominal;
  final int userId;

  const LogModel({
    required this.id,
    required this.category,
    required this.desc,
    required this.date,
    required this.day,
    required this.month,
    required this.year,
    required this.nominal,
    required this.userId
  }):super(
    id: id,
    category: category,
    desc: desc,
    date: date,
    day: day,
    month: month,
    year: year,
    nominal: nominal,
    userId: userId
  );

  factory LogModel.fromMap(Map<String, dynamic> map){
    return LogModel(
        id: map['id'],
        category: map['category'],
        desc: map['desc'],
        date: map['date'],
        day: map['day'],
        month: map['month'],
        year: map['year'],
        nominal: map['nominal'],
        userId: map['user_id']
    );
  }

  static Map<String, dynamic> toMap(Log data){
    return {
      'id': data.id,
      'category': data.category,
      'desc': data.desc,
      'date': data.date,
      'day': data.day,
      'month': data.month,
      'year': data.year,
      'nominal': data.nominal,
      'user_id': data.userId
    };
  }

  @override
  List<Object?> get props => [
    id,
    category,
    desc,
    date,
    day,
    month,
    year,
    nominal,
    userId
  ];
}