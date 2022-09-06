import 'package:bloc/bloc.dart';
import 'package:expense_app/features/domain/usecases/get_total_funds_use_case.dart';
import 'package:meta/meta.dart';

part 'total_funds_event.dart';
part 'total_funds_state.dart';

class TotalFundsBloc extends Bloc<TotalFundsEvent, TotalFundsState> {

  final GetTotalFundsUseCase getTotalFundsUseCase;

  TotalFundsBloc({required this.getTotalFundsUseCase}) : super(TotalFundsInitial()) {
    on<GetTotalFundsEvent>((event, emit) async {
      var result = await getTotalFundsUseCase.call(
          GetTotalFundsUseCaseParams(
              fromDate: event.fromDate,
              untilDate: event.untilDate
          )
      );

      emit(
        result.fold(
                (left) => TotalFundsError(message: left.getMessage(left)),
                (right) => TotalFundsLoaded(data: right)
        )
      );
    });
  }
}
