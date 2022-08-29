part of 'expense_month_bloc.dart';

@immutable
abstract class ExpenseMonthEvent {}

class GetExpenseMonthEvent extends ExpenseMonthEvent {
  final DateTime dateStart;
  final DateTime dateEnd;

  GetExpenseMonthEvent({required this.dateStart, required this.dateEnd});
}
