import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/usecases/get_expense_in_month_use_case.dart';
import 'package:expense_app/features/domain/usecases/get_today_balance_left_usecase.dart';
import 'package:meta/meta.dart';

part 'balance_left_event.dart';
part 'balance_left_state.dart';

class BalanceLeftBloc extends Bloc<BalanceLeftEvent, BalanceLeftState> {

  final GetTodayBalanceLeftUseCase getTodayBalanceLeftUseCase;
  final GetExpenseInMonthUseCase getExpenseInMonthUseCase;

  BalanceLeftBloc({
    required this.getTodayBalanceLeftUseCase,
    required this.getExpenseInMonthUseCase
  }) : super(BalanceLeftInitial()) {
    on<GetBalanceLeftEvent>((event, emit) async {

      var result = await getTodayBalanceLeftUseCase.call(NoParams());

      emit(
        result.fold(
                (l) => BalanceLeftError(message: l is ServerFailure ? l.msg : unexpectedFailureMessage),
                (r) => BalanceLeftLoaded(data: r))
      );
    });
    on<GetExpenseInMonthEvent>((event, emit) async {

      var result = await getExpenseInMonthUseCase.call(null);

      emit(
        result.fold(
                (l) => ExpenseInMonthError(message: l is ServerFailure ? l.msg : unexpectedFailureMessage),
                (r) => ExpenseInMonthLoaded(data: r))
      );
    });

  }
}
