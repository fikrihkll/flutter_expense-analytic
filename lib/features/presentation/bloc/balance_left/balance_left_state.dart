part of 'balance_left_bloc.dart';

@immutable
abstract class BalanceLeftState {}

class BalanceLeftInitial extends BalanceLeftState {}

class BalanceLeftLoaded extends BalanceLeftState {
  final double data;

  BalanceLeftLoaded({required this.data});
}

class BalanceLeftError extends BalanceLeftState {
  final String message;

  BalanceLeftError({required this.message});
}

class TotalSavingsInMonthLoaded extends BalanceLeftState {
  final double data;

  TotalSavingsInMonthLoaded({required this.data});
}

class TotalSavingsInMonthError extends BalanceLeftState {
  final String message;

  TotalSavingsInMonthError({required this.message});
}