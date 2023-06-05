import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class DeleteFundSourceUseCase extends UseCase<bool, DeleteFundSourceUseCaseParams> {

  final ExpenseRepository repo;

  DeleteFundSourceUseCase({required this.repo});

  @override
  Future<Either<Failure, bool>> call(DeleteFundSourceUseCaseParams params) async {
    return await repo.deleteFundSource(params.id);
  }

}

class DeleteFundSourceUseCaseParams {
  final String id;

  DeleteFundSourceUseCaseParams({required this.id});
}