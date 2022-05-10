import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/usecases/get_today_balance_left_usecase.dart';
import 'package:meta/meta.dart';

part 'balance_left_event.dart';
part 'balance_left_state.dart';

class BalanceLeftBloc extends Bloc<BalanceLeftEvent, BalanceLeftState> {

  final GetTodayBalanceLeftUseCase getTodayBalanceLeftUseCase;

  BalanceLeftBloc({required this.getTodayBalanceLeftUseCase}) : super(BalanceLeftInitial()) {
    on<GetBalanceLeftEvent>((event, emit) async {

      var result = await getTodayBalanceLeftUseCase.call(NoParams());

      emit(
        result.fold(
                (l) => BalanceLeftError(message: l is ServerFailure ? l.msg : unexpectedFailureMessage),
                (r) => BalanceLeftLoaded(data: r))
      );
    });
  }
}
