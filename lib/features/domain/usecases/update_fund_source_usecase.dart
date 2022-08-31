import 'package:either_dart/src/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class UpdateFundSourceUseCase extends UseCase<bool, UpdateFundSourceUseCaseParams> {

  final ExpenseRepository repo;


  UpdateFundSourceUseCase({required this.repo});

  @override
  Future<Either<Failure, bool>> call(UpdateFundSourceUseCaseParams params) async {
    return await repo.updateFundSource(params.fundSourceModel);
  }

}

class UpdateFundSourceUseCaseParams {

  final FundSourceModel fundSourceModel;

  UpdateFundSourceUseCaseParams({required this.fundSourceModel});

}