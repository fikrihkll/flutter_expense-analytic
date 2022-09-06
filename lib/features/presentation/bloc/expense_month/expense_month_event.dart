part of 'expense_month_bloc.dart';

@immutable
abstract class ExpenseMonthEvent {}
class GetExpenseInMonthEvent extends ExpenseMonthEvent {

  final DateTime? fromDate;
  final DateTime? untilDate;

  GetExpenseInMonthEvent({this.fromDate, this.untilDate});
}

