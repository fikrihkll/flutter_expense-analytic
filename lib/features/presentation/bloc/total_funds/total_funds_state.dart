part of 'total_funds_bloc.dart';

@immutable
abstract class TotalFundsState {}

class TotalFundsInitial extends TotalFundsState {}

class TotalFundsError extends TotalFundsState {
  String message;

  TotalFundsError({required this.message});
}

class TotalFundsLoaded extends TotalFundsState {
  final double data;

  TotalFundsLoaded({required this.data});
}