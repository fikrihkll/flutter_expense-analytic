part of 'fund_source_bloc.dart';

@immutable
abstract class FundSourceState {}

class FundSourceInitial extends FundSourceState {}

class GetFundSourceLoading extends FundSourceState {}

class GetFundSourceLoaded extends FundSourceState {
  final List<FundSource> data;

  GetFundSourceLoaded({required this.data});
}

class GetFundSourceError extends FundSourceState {
  final String message;

  GetFundSourceError({required this.message});
}

class InsertFundSourceLoading extends FundSourceState {}

class InsertFundSourceResult extends FundSourceState {
  final bool isSuccess;

  InsertFundSourceResult({required this.isSuccess});
}

class UpdateFundSourceLoading extends FundSourceState {}

class UpdateFundSourceResult extends FundSourceState {
  final bool isSuccess;

  UpdateFundSourceResult({required this.isSuccess});
}

class GetFundUsedDetailLoading extends FundSourceState {}

class GetFundUsedDetailLoaded extends FundSourceState {
  final List<FundDetail> listData;

  GetFundUsedDetailLoaded({required this.listData});
}

class GetFundUsedDetailError extends FundSourceState {
  final String message;

  GetFundUsedDetailError({required this.message});
}

class DeleteFundSourceLoading extends FundSourceState {}

class DeleteFundSourceResult extends FundSourceState {
  final bool isSuccess;

  DeleteFundSourceResult({required this.isSuccess});
}