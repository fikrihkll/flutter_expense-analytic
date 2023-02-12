import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/usecases/delete_log_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_logs_in_month_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_recent_logs_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_log_usecase.dart';
import 'package:expense_app/features/domain/usecases/update_log_use_case.dart';
import 'package:meta/meta.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {

  final GetLogsInMonthUseCase getLogsInMonthUseCase;
  final GetRecentLogsUseCase getRecentLogsUseCase;
  final DeleteLogUseCase deleteLogUseCase;
  final InsertLogUseCase insertLogUseCase;
  final UpdateLogUseCase updateLogUseCase;

  List<Log> _listAllLog = [];
  int _page = 1;
  bool _isLoadMoreAvailable = true;

  DateTime? fromDateAllLog, untilDateAllLog;

  LogsBloc({
    required this.getLogsInMonthUseCase,
    required this.getRecentLogsUseCase,
    required this.deleteLogUseCase,
    required this.insertLogUseCase,
    required this.updateLogUseCase
  }) : super(LogsInitial()) {
    on<GetRecentLogsEvent>((event, emit) async {
      emit(RecentLogsLoading());

      var result = await getRecentLogsUseCase.call(NoParams());

      emit(
        result.fold(
                (l) => RecentLogsError(l is ServerFailure ? l.msg : unexpectedFailureMessage),
                (r) => RecentLogsLoaded(r)
        )
      );
    });

    on<InsertLogEvent>((event, emit) async {
      emit(InsertLogsLoading());

      var result = await insertLogUseCase.call(InsertLogUseCaseParams(data: event.log));

      emit(
          result.fold(
                  (l) => InsertLogsResult(false),
                  (r) => InsertLogsResult(true)
          )
      );
    });

    on<DeleteLogEvent>((event, emit) async {
      emit(DeleteLogsLoading());

      var result = await deleteLogUseCase.call(DeleteLogUseCaseParams(id: event.id));

      emit(
          result.fold(
                  (l) => DeleteLogsResult(false),
                  (r) => DeleteLogsResult(true)
          )
      );
    });

    on<LoadAllLogEvent>((event, emit) async {
      // Set to false to prevent the event invocation when the scroll view is touching it's bottom side

      if (event.isRefreshing) {
        _isLoadMoreAvailable = true;
        emit(LoadAllLogsLoading());
        _listAllLog.clear();
        _page = 1;
        if (!event.retainDateRange) {
          fromDateAllLog = event.fromDate;
          untilDateAllLog = event.untilDate;
        }
      }

      await Future.delayed(const Duration(seconds: 1));

      var result = await getLogsInMonthUseCase.call(
        GetLogsInMonthUseCaseParams(
            fromDate: fromDateAllLog ?? event.fromDate,
            untilDate: untilDateAllLog ?? event.untilDate,
            limit: 20,
            page: _page,
            fundIdFilter: event.fundIdFilter
        )
      );
      _page ++;

      emit(
          result.fold(
                  (l) => LoadAllLogsError(message: l is ServerFailure ? l.msg : unexpectedFailureMessage),
                  (r) {
                    _listAllLog.addAll(r);
                    if (r.length < 20) {
                      _isLoadMoreAvailable = false;
                    }
                    return LoadAllLogsLoaded(_listAllLog);
                  }
          )
      );
    });
    on<UpdateLogEvent>((event, emit) async {
      emit(UpdateLogsLoading());

      var result = await updateLogUseCase.call(UpdateLogUseCaseParams(log: event.log));

      emit(
          result.fold(
                  (l) => UpdateLogsResult(false),
                  (r) => UpdateLogsResult(true)
          )
      );
    });
  }

  List<Log> get getListAllLog => _listAllLog;
  bool get isLoadMoreAvailable => _isLoadMoreAvailable;
}
