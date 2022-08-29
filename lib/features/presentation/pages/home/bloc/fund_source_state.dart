part of 'fund_source_bloc.dart';

@immutable
abstract class FundSourceState {}

class FundSourceInitial extends FundSourceState {}

class FundSourceLoaded extends FundSourceState {

  final List<FundSource> listData;

  FundSourceLoaded(this.listData);
}

class FundSourceError extends FundSourceState {

  String message;

  FundSourceError(this.message);
}
