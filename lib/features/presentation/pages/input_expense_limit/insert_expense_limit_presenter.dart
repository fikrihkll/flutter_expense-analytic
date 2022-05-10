import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/usecases/get_expense_limit_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_expense_limit_usecase.dart';

class InsertExpenseLimitPresenter {

  final InsertExpenseLimitUseCase insertExpenseLimitUseCase;
  final GetExpenseLimitUseCase getExpenseLimitUseCase;

  InsertExpenseLimitPresenter({
    required this.insertExpenseLimitUseCase,
    required this.getExpenseLimitUseCase
  });

  Future<bool> insertExpenseLimitEvent(ExpenseLimit data) async {
    var result = await insertExpenseLimitUseCase.call(InsertExpenseLimitUseCaseParams(data: data));
    return result.fold((l) => false, (r) => true);
  }

  Future<ExpenseLimit> getExpenseLimitEvent() async {
    var result = await getExpenseLimitUseCase.call(NoParams());
    return result.fold(
            (l) => const ExpenseLimit(id: -1, weekdaysLimit: 0, weekendLimit: 0, balanceInMonth: 0, month: 0, year: 0),
            (r) => r);
  }
}