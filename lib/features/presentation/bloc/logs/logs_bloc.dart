import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/usecases/delete_log_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_recent_logs_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_log_usecase.dart';
import 'package:meta/meta.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {

  final GetRecentLogsUseCase getRecentLogsUseCase;
  final DeleteLogUseCase deleteLogUseCase;
  final InsertLogUseCase insertLogUseCase;

  LogsBloc({
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

  }
}
