part of 'expense_month_bloc.dart';

@immutable
abstract class ExpenseMonthEvent {}

class GetExpenseMonthEvent extends ExpenseMonthEvent {
  final int month, year;

  GetExpenseMonthEvent({required this.month, required this.year});
}
