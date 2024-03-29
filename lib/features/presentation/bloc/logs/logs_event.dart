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
  final bool isRefreshing, retainDateRange;
  final DateTime fromDate, untilDate;
  final String? categoryFilter;
  final int? fundIdFilter;

  LoadAllLogEvent({
    required this.isRefreshing,
    required this.fromDate,
    required this.untilDate,
    this.retainDateRange = false,
    this.categoryFilter,
    this.fundIdFilter
  });
}

class UpdateLogEvent extends LogsEvent {
  final LogModel log;

  UpdateLogEvent({required this.log});
}
