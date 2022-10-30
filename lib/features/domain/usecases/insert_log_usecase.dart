
import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class InsertLogUseCase extends UseCase<bool, InsertLogUseCaseParams>{

  final ExpenseRepository repo;

  InsertLogUseCase({required this.repo});

  @override
  Future<Either<Failure, bool>> call(InsertLogUseCaseParams params) async {
    return await repo.insertExpense(params.data);
  }

}

class InsertLogUseCaseParams {
  final LogModel data;

  InsertLogUseCaseParams({required this.data});
}