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
import 'package:meta/meta.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {

  final GetLogsInMonthUseCase getLogsInMonthUseCase;
  final GetRecentLogsUseCase getRecentLogsUseCase;
  final DeleteLogUseCase deleteLogUseCase;
  final InsertLogUseCase insertLogUseCase;

  List<Log> _listAllLog = [];
  int _page = 1;
  bool _isLoadMoreAvailable = false;
  bool _isPagingLoading = false;

  DateTime? fromDateAllLog, untilDateAllLog;

  LogsBloc({
    required this.getLogsInMonthUseCase,
    required this.getRecentLogsUseCase,
    required this.deleteLogUseCase,
    required this.insertLogUseCase
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

    on<LoadAllLogEvent>((event, emit) async {
      _isPagingLoading = true;

      if (event.isRefreshing) {
        emit(LoadAllLogsLoading());
        _listAllLog.clear();
        _page = 1;
        fromDateAllLog = event.fromDate;
        untilDateAllLog = event.untilDate;
      }

      var result = await getLogsInMonthUseCase.call(
        GetLogsInMonthUseCaseParams(
            fromDate: fromDateAllLog ?? event.fromDate,
            untilDate: untilDateAllLog ?? event.untilDate,
            limit: 20,
            page: _page
        )
      );
      _page ++;
      _isPagingLoading = false;

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

  }

  List<Log> get getListAllLog => _listAllLog;
  bool get isLoadMoreAvailable => _isLoadMoreAvailable;
  bool get isPagingLoading => _isPagingLoading;
}
