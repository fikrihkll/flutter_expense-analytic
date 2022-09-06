part of 'expense_month_bloc.dart';

@immutable
abstract class ExpenseMonthState {}

class ExpenseMonthInitial extends ExpenseMonthState {}

class ExpenseInMonthLoaded extends ExpenseMonthState {
  final int data;

  ExpenseInMonthLoaded({required this.data});
}

class ExpenseInMonthError extends ExpenseMonthState {
  final String message;

  ExpenseInMonthError({required this.message});
}