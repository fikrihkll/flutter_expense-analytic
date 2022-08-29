import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/features/domain/usecases/get_expense_in_month_usecase.dart';
import 'package:meta/meta.dart';

part 'expense_month_event.dart';
part 'expense_month_state.dart';

class ExpenseMonthBloc extends Bloc<ExpenseMonthEvent, ExpenseMonthState> {

  final GetExpenseInMonthUseCase getExpenseInMonthUseCase;

  ExpenseMonthBloc({required this.getExpenseInMonthUseCase}) : super(ExpenseMonthInitial()) {
    on<GetExpenseMonthEvent>((event, emit) async {
      emit(ExpenseMonthLoading());

      var result = await getExpenseInMonthUseCase.call(GetExpenseInMonthUseCaseParams(dateStart: event.dateStart, dateEnd: event.dateEnd));

      emit(
        result.fold((l) => ExpenseMonthError(''), (r) => ExpenseMonthLoaded(r))
      );
    });
  }
}
