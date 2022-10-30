part of 'total_expense_month_bloc.dart';

@immutable
abstract class TotalExpenseMonthState {}

class TotalExpenseMonthInitial extends TotalExpenseMonthState {}

class TotalExpenseCategoryInMonthLoaded extends TotalExpenseMonthState {
  final List<LogDetail> data;

  TotalExpenseCategoryInMonthLoaded({required this.data});
}

class TotalExpenseCategoryInMonthError extends TotalExpenseMonthState {
  final String message;

  TotalExpenseCategoryInMonthError({required this.message});
}