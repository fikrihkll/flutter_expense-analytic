part of 'balance_left_bloc.dart';

@immutable
abstract class BalanceLeftEvent {}

class GetBalanceLeftEvent extends BalanceLeftEvent {}

class GetTotalSavingsInMonthEvent extends BalanceLeftEvent {

  final DateTime fromDate;
  final DateTime untilDate;

  GetTotalSavingsInMonthEvent({required this.fromDate, required this.untilDate});
}