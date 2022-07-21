import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class InsertExpenseLimitUseCase extends UseCase<bool, InsertExpenseLimitUseCaseParams> {

  final ExpenseRepository repo;

  InsertExpenseLimitUseCase({required this.repo});

  @override
  Future<Either<Failure, bool>> call(InsertExpenseLimitUseCaseParams params) async {
    return await repo.insertExpenseLimit(params.data);
  }

}

class InsertExpenseLimitUseCaseParams {
  final ExpenseLimit data;

  InsertExpenseLimitUseCaseParams({required this.data});
}