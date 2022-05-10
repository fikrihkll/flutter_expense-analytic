import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetExpenseLimitUseCase extends UseCase<ExpenseLimit, NoParams>{

  final ExpenseRepository repo;


  GetExpenseLimitUseCase({required this.repo});

  @override
  Future<Either<Failure, ExpenseLimit>> call(NoParams params) async {
    return await repo.getExpenseLimit();
  }

}