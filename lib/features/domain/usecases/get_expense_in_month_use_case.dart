import 'package:either_dart/src/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetExpenseInMonthUseCase extends UseCase<double, GetExpenseInMonthUseCaseParams?> {

  final ExpenseRepository repository;
  GetExpenseInMonthUseCase({required this.repository});

  @override
  Future<Either<Failure, double>> call(GetExpenseInMonthUseCaseParams? params) async {
    return await repository.getExpenseInMonth(params?.fromDate, params?.untilDate);
  }

}

class GetExpenseInMonthUseCaseParams {

  final DateTime fromDate;
  final DateTime untilDate;

  GetExpenseInMonthUseCaseParams({required this.fromDate, required this.untilDate});
}