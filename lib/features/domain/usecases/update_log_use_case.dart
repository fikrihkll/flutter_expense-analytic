import 'package:either_dart/src/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class UpdateLogUseCase extends UseCase<void, UpdateLogUseCaseParams> {

  final ExpenseRepository repository;

  UpdateLogUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateLogUseCaseParams params) async {
    return await repository.updateExpense(params.log);
  }

}

class UpdateLogUseCaseParams {
  final LogModel log;

  UpdateLogUseCaseParams({required this.log});
}