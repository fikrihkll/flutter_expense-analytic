part of 'balance_left_bloc.dart';

@immutable
abstract class BalanceLeftEvent {}

class GetBalanceLeftEvent extends BalanceLeftEvent {}

class GetExpenseInMonthEvent extends BalanceLeftEvent {

  final DateTime? fromDate;
  final DateTime? untilDate;

  GetExpenseInMonthEvent({this.fromDate, this.untilDate});
}

class GetTotalExpenseCategoryInMonthEvent extends BalanceLeftEvent {

  final DateTime fromDate;
  final DateTime untilDate;

  GetTotalExpenseCategoryInMonthEvent({required this.fromDate, required this.untilDate});
}

class GetTotalSavingsInMonthEvent extends BalanceLeftEvent {

  final DateTime fromDate;
  final DateTime untilDate;

  GetTotalSavingsInMonthEvent({required this.fromDate, required this.untilDate});
}