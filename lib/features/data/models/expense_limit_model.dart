import 'package:expense_app/features/domain/entities/expense_limit.dart';

class ExpenseLimitModel extends ExpenseLimit{

  final int id, weekdaysLimit, weekendLimit, balanceInMonth, month, year;

  const ExpenseLimitModel({
    required this.id,
    required this.weekdaysLimit,
    required this.weekendLimit,
    required this.balanceInMonth,
    required this.month,
    required this.year
  }):super(
    id: id,
    weekdaysLimit: weekdaysLimit,
    weekendLimit: weekendLimit,
    balanceInMonth: balanceInMonth,
    month: month,
    year: year
  );

  factory ExpenseLimitModel.fromMap(Map<String, dynamic> map){
    return ExpenseLimitModel(id: map['id'], weekdaysLimit: map['weekdays_limit'], weekendLimit: map['weekend_limit'], balanceInMonth: map['balance_in_month'], month: map['month'], year: map['year']);
  }

  static Map<String, dynamic> toMap(ExpenseLimit data){
    return {
      'id': data.id,
      'month': data.month,
      'year': data.year,
      'weekdays_limit': data.weekdaysLimit,
      'weekend_limit': data.weekendLimit,
      'balance_in_month': data.balanceInMonth,
      'user_id': 1
    };
  }

  @override
  List<Object?> get props => [weekdaysLimit, weekendLimit, balanceInMonth];
}