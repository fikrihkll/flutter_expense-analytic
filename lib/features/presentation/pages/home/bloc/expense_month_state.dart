part of 'expense_month_bloc.dart';

@immutable
abstract class ExpenseMonthState {}

class ExpenseMonthInitial extends ExpenseMonthState {}

class ExpenseMonthLoading extends ExpenseMonthState {}

class ExpenseMonthLoaded extends ExpenseMonthState {

  final int nominal;

  ExpenseMonthLoaded(this.nominal);
}

class ExpenseMonthError extends ExpenseMonthState {

  final String message;

  ExpenseMonthError(this.message);

}
