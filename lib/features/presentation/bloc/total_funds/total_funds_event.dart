part of 'total_funds_bloc.dart';

@immutable
abstract class TotalFundsEvent {}

class GetTotalFundsEvent extends TotalFundsEvent {

  final DateTime fromDate, untilDate;

  GetTotalFundsEvent({required this.fromDate, required this.untilDate});
}