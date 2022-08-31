part of 'logs_bloc.dart';

@immutable
abstract class LogsState {}

class LogsInitial extends LogsState {}

class RecentLogsLoading extends LogsState {}

class RecentLogsLoaded extends LogsState {
  final List<Log> listData;

  RecentLogsLoaded(this.listData);
}

class RecentLogsError extends LogsState {
  final String message;

  RecentLogsError(this.message);
}

class InsertLogsLoading extends LogsState {}

class InsertLogsResult extends LogsState {
  bool isSuccess;

  InsertLogsResult(this.isSuccess);
}

class DeleteLogsLoading extends LogsState {}

class DeleteLogsResult extends LogsState {
  bool isSuccess;

  DeleteLogsResult(this.isSuccess);
}