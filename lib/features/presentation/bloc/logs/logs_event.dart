part of 'logs_bloc.dart';

@immutable
abstract class LogsEvent {}

class GetRecentLogsEvent extends LogsEvent {}

class InsertLogEvent extends LogsEvent {
  final LogModel log;

  InsertLogEvent({required this.log});
}

class DeleteLogEvent extends LogsEvent {
  final int id;

  DeleteLogEvent({required this.id});
}

class LoadAllLogEvent extends LogsEvent {
  final bool isRefreshing;
  final DateTime fromDate, untilDate;

  LoadAllLogEvent({required this.isRefreshing, required this.fromDate, required this.untilDate});
}
