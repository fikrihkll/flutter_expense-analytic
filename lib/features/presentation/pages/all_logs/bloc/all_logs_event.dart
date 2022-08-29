part of 'all_logs_bloc.dart';

@immutable
abstract class AllLogsEvent {}

class GetAllLogsEvent extends AllLogsEvent {
  final bool isRefreshing;
  final DateTime dateStart;
  final DateTime dateEnd;

  GetAllLogsEvent({
    required this.isRefreshing,
    required this.dateStart,
    required this.dateEnd
  });
}
