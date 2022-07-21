import 'package:equatable/equatable.dart';

class ExpenseLimit extends Equatable{

  final int id, weekdaysLimit, weekendLimit, balanceInMonth, month, year;

  const ExpenseLimit({
    required this.id,
    required this.weekdaysLimit,
    required this.weekendLimit,
    required this.balanceInMonth,
    required this.month,
    required this.year
  });

  @override
  List<Object?> get props => [id, weekdaysLimit, weekendLimit, balanceInMonth];
}