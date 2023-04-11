import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetTodayBalanceLeftUseCase extends UseCase<double, NoParams>{

  final ExpenseRepository repo;


  GetTodayBalanceLeftUseCase({required this.repo});

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    double limitToday = -1;
    double expenseToday = -1;
    var limitRepoResult = await repo.getTodayLimit();
    var expenseTodayRepoResult = await repo.getTodayExpense();

    if (limitRepoResult.isRight) {
      limitToday = limitRepoResult.right;
    }
    if (expenseTodayRepoResult.isRight) {
      expenseToday = expenseTodayRepoResult.right;
    }

    if (limitToday >= 0 && expenseToday >= 0) {
      return Right(limitToday - expenseToday);
    } else {
      return Left(CacheFailure());
    }
  }

}