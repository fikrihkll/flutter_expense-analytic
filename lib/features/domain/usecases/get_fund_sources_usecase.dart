import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/fund_source_entity.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetFundSourcesUseCase extends UseCase<List<FundSource>, NoParams>{

  final ExpenseRepository repo;

  GetFundSourcesUseCase({required this.repo});

  @override
  Future<Either<Failure, List<FundSource>>> call(NoParams params) async {
    return await repo.getFundSources();
  }

}

