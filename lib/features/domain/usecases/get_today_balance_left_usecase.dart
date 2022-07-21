import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetTodayBalanceLeftUseCase extends UseCase<int, NoParams>{

  final ExpenseRepository repo;


  GetTodayBalanceLeftUseCase({required this.repo});

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repo.getTodayBalanceLeft();
  }

}