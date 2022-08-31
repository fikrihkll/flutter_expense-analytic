import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class InsertFundSourceUseCase extends UseCase<bool, InsertFundSourceUseCaseParams> {

  final ExpenseRepository repo;

  InsertFundSourceUseCase({required this.repo});

  @override
  Future<Either<Failure, bool>> call(InsertFundSourceUseCaseParams params) async {
    return await repo.insertFundSource(params.data);
  }

}

class InsertFundSourceUseCaseParams {
  final FundSourceModel data;

  InsertFundSourceUseCaseParams({required this.data});
}