part of 'balance_left_bloc.dart';

@immutable
abstract class BalanceLeftState {}

class BalanceLeftInitial extends BalanceLeftState {}

class BalanceLeftLoaded extends BalanceLeftState {
  final int data;

  BalanceLeftLoaded({required this.data});
}

class BalanceLeftError extends BalanceLeftState {
  final String message;

  BalanceLeftError({required this.message});
}
