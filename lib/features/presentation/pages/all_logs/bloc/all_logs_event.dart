part of 'all_logs_bloc.dart';

@immutable
abstract class AllLogsEvent {}

class GetAllLogsEvent extends AllLogsEvent {
  final bool isRefreshing;
  final int month, year;

  GetAllLogsEvent({
    required this.isRefreshing,
    required this.month,
    required this.year
  });
}
