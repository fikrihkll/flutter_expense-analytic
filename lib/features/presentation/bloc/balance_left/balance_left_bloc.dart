import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';
import 'package:expense_app/features/domain/usecases/get_expense_in_month_use_case.dart';
import 'package:expense_app/features/domain/usecases/get_today_balance_left_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_total_expense_based_on_category_use_case.dart';
import 'package:expense_app/features/domain/usecases/get_total_savings_use_case.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'balance_left_event.dart';
part 'balance_left_state.dart';

class BalanceLeftBloc extends Bloc<BalanceLeftEvent, BalanceLeftState> {

  final GetTodayBalanceLeftUseCase getTodayBalanceLeftUseCase;
  final GetTotalSavingsUseCase getTotalSavingsUseCase;

  BalanceLeftBloc({
    required this.getTodayBalanceLeftUseCase,
    required this.getTotalSavingsUseCase
  }) : super(BalanceLeftInitial()) {
    on<GetBalanceLeftEvent>((event, emit) async {
      debugPrint("BALANCE LEFT CALLED");
      var result = await getTodayBalanceLeftUseCase.call(NoParams());
      debugPrint("RESULT ${result.isRight ? result.right : result.left.toString()}");
      emit(
        result.fold(
                (l) => BalanceLeftError(message: l is ServerFailure ? l.msg : unexpectedFailureMessage),
                (r) => BalanceLeftLoaded(data: r))
      );
    });
    on<GetTotalSavingsInMonthEvent>((event, emit) async {
      var result = await getTotalSavingsUseCase.call(
          GetTotalSavingsUseCaseParams(
              fromDate: event.fromDate,
              untilDate: event.untilDate
          )
      );
      emit(
          result.fold(
                  (l) => TotalSavingsInMonthError(message: l is ServerFailure ? l.msg : unexpectedFailureMessage),
                  (r) => TotalSavingsInMonthLoaded(data: r))
      );
    });

  }
}
