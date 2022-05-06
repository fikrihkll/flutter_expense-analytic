import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/usecases/get_recent_logs_usecase.dart';
import 'package:meta/meta.dart';

part 'recent_logs_event.dart';
part 'recent_logs_state.dart';

class RecentLogsBloc extends Bloc<RecentLogsEvent, RecentLogsState> {

  final GetRecentLogsUseCase getRecentLogsUseCase;

  RecentLogsBloc({required this.getRecentLogsUseCase}) : super(RecentLogsInitial()) {
    on<RecentLogsEvent>((event, emit) async {
      emit(RecentLogsLoading());

      var result = await getRecentLogsUseCase.call(NoParams());

      emit(
        result.fold(
                (l) => RecentLogsError(l is ServerFailure ? l.msg : unexpectedFailureMessage),
                (r) => RecentLogsLoaded(r)
        )
      );
    });
  }
}
