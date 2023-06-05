part of 'fund_source_bloc.dart';

@immutable
abstract class FundSourceEvent {}

class GetFundSourceEvent extends FundSourceEvent {}

class InsertFundSourceEvent extends FundSourceEvent {
  final FundSourceModel fundSourceModel;

  InsertFundSourceEvent({required this.fundSourceModel});
}

class UpdateFundSourceEvent extends FundSourceEvent {
  final FundSourceModel fundSourceModel;

  UpdateFundSourceEvent({required this.fundSourceModel});
}

class DeleteFundSourceEvent extends FundSourceEvent {
  final String id;

  DeleteFundSourceEvent({required this.id});
}

class GetFundUsedDetailEvent extends FundSourceEvent {
  final DateTime fromDate;
  final DateTime untilDate;

  GetFundUsedDetailEvent({required this.fromDate, required this.untilDate});
}
