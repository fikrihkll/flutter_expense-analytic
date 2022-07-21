part of 'recent_logs_bloc.dart';

@immutable
abstract class RecentLogsState {}

class RecentLogsInitial extends RecentLogsState {}

class RecentLogsLoading extends RecentLogsState {}

class RecentLogsLoaded extends RecentLogsState {
  final List<Log> listData;

  RecentLogsLoaded(this.listData);
}

class RecentLogsError extends RecentLogsState {
  final String message;

  RecentLogsError(this.message);
}
