import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';
import 'package:expense_app/features/domain/usecases/get_total_expense_based_on_category_use_case.dart';
import 'package:meta/meta.dart';

part 'total_expense_month_event.dart';
part 'total_expense_month_state.dart';

class TotalExpenseMonthBloc extends Bloc<TotalExpenseMonthEvent, TotalExpenseMonthState> {

  final GetTotalExpenseBasedOnCategoryUseCase getTotalExpenseBasedOnCategoryUseCase;

  TotalExpenseMonthBloc({
    required this.getTotalExpenseBasedOnCategoryUseCase
  }) : super(TotalExpenseMonthInitial()) {
    on<GetTotalExpenseCategoryInMonthEvent>((event, emit) async {
      var result = await getTotalExpenseBasedOnCategoryUseCase.call(
          GetTotalExpenseBasedOnCategoryUseCaseParams(
              fromDate: event.fromDate,
              untilDate: event.untilDate
          )
      );

      emit(
          result.fold(
                  (l) => TotalExpenseCategoryInMonthError(message: l.getMessage(l)),
                  (r) => TotalExpenseCategoryInMonthLoaded(data: r))
      );
    });
  }
}
