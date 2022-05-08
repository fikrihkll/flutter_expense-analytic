import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/usecases/delete_log_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_logs_in_month_usecase.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'all_logs_event.dart';
part 'all_logs_state.dart';

class AllLogsBloc extends Bloc<AllLogsEvent, AllLogsState> {

  // UseCase
  final GetLogsInMonthUseCase getLogsInMonthUseCase;
  final DeleteLogUseCase deleteLogUseCase;

  final int _limit = 20;
  int _page = 0;
  List<Log> listData = [];

  AllLogsBloc({required this.getLogsInMonthUseCase, required this.deleteLogUseCase}) : super(AllLogsInitial()) {
    on<GetAllLogsEvent>((event, emit) async {
      if(state is AllLogsInitial || event.isRefreshing){
        emit(AllLogsLoading());
        _page = 1;
        listData.clear();
        var result = await getLogsInMonthUseCase
            .call(
            GetLogsInMonthUseCaseParams(
              month: event.month,
              year: event.year,
              limit: _limit,
              page: _page
            )
        );

        emit(
          result.fold(
                  (l) => AllLogsError(l is ServerFailure ? l.msg : unexpectedFailureMessage),
                  (r) {
                    listData.addAll(r);
                    return AllLogsLoaded(listData, r.length < _limit);
                  }
          )
        );
      }else if(state is AllLogsLoaded && !(state as AllLogsLoaded).hasReachedMax){
        _page++;
        var result = await getLogsInMonthUseCase
            .call(
            GetLogsInMonthUseCaseParams(
              month: event.month,
              year: event.year,
              limit: _limit,
              page: _page
            )
        );

        emit(
            result.fold(
                    (l) => AllLogsError(l is ServerFailure ? l.msg : unexpectedFailureMessage),
                    (r) {
                      listData.addAll(r);
                       return AllLogsLoaded(listData, r.length < _limit);
                    }
            )
        );
      }
    });
  }

  Future<void> deleteLog(int id)async{
    await deleteLogUseCase.call(DeleteLogUseCaseParams(id: id));
  }
}
