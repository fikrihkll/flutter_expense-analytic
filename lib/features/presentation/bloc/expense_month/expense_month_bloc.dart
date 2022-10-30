import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';
import 'package:expense_app/features/domain/usecases/get_expense_in_month_use_case.dart';
import 'package:expense_app/features/domain/usecases/get_total_expense_based_on_category_use_case.dart';
import 'package:meta/meta.dart';

part 'expense_month_event.dart';
part 'expense_month_state.dart';

class ExpenseMonthBloc extends Bloc<ExpenseMonthEvent, ExpenseMonthState> {

  final GetExpenseInMonthUseCase getExpenseInMonthUseCase;

  ExpenseMonthBloc({
    required this.getExpenseInMonthUseCase
  }) : super(ExpenseMonthInitial()) {
    on<GetExpenseInMonthEvent>((event, emit) async {
      GetExpenseInMonthUseCaseParams? params;
      if (event.untilDate != null && event.fromDate != null) {
        params = GetExpenseInMonthUseCaseParams(fromDate: event.fromDate!, untilDate: event.untilDate!);
      }
      var result = await getExpenseInMonthUseCase.call(params);
      emit(
          result.fold(
                  (l) => ExpenseInMonthError(message: l.getMessage(l)),
                  (r) => ExpenseInMonthLoaded(data: r)
          )
      );
    });
  }
}
