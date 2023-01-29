part of 'fund_source_list_bloc.dart';

@immutable
abstract class FundSourceListState {}

class FundSourceListLoading extends FundSourceListState {}

class GetFundSourceListError extends FundSourceListState {
  String message;

  GetFundSourceListError({required this.message});
}

class GetFundSourceListLoaded extends FundSourceListState {
  final List<FundSource> data;

  GetFundSourceListLoaded({required this.data});
}
