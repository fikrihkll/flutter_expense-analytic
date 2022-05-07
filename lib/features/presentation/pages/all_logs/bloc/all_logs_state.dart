part of 'all_logs_bloc.dart';

@immutable
abstract class AllLogsState {}

class AllLogsInitial extends AllLogsState {}

class AllLogsLoading extends AllLogsState {}

class AllLogsLoaded extends AllLogsState {
  final List<Log> listData;
  final bool hasReachedMax;
  AllLogsLoaded(this.listData, this.hasReachedMax);
}

class AllLogsError extends AllLogsState {
  final String message;
  AllLogsError(this.message);
}

