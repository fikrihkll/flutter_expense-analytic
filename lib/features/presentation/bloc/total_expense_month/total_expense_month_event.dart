part of 'total_expense_month_bloc.dart';

@immutable
abstract class TotalExpenseMonthEvent {}

class GetTotalExpenseCategoryInMonthEvent extends TotalExpenseMonthEvent {

  final DateTime fromDate;
  final DateTime untilDate;

  GetTotalExpenseCategoryInMonthEvent({required this.fromDate, required this.untilDate});
}