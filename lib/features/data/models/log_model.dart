import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/data/models/floor/expenses_dto.dart';
import 'package:expense_app/features/data/models/floor/results/expenses_result_dto.dart';
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
  final int fundSourceId;

  const LogModel({
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
  }):super(
    id: id,
    category: category,
    desc: desc,
    date: date,
    day: day,
    month: month,
    year: year,
    nominal: nominal,
    userId: userId,
    fundSourceId: fundSourceId
  );

  factory LogModel.fromDTO(ExpensesResultDTO dto){
    return LogModel(
        id: dto.id,
        category: dto.category,
        desc: dto.description,
        date: dto.date,
        day: 0,
        month: 0,
        year: 0,
        nominal: dto.nominal,
        userId: dto.user_id,
        fundSourceId: dto.fund_source_id
    );
  }

  static ExpensesDTO toDto(Log data) {
    return ExpensesDTO(id: null, user_id: data.userId, fund_source_id: data.fundSourceId, description: data.desc, category: data.category, nominal: data.nominal, date: data.date, created_at: DateUtil.dbNow(), updated_at: DateUtil.dbNow());
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