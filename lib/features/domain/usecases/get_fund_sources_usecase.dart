import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetFundSourcesUseCase extends UseCase<List<FundSource>, NoParams>{

  final ExpenseRepository repo;


  GetFundSourcesUseCase({required this.repo});

  @override
  Future<Either<Failure, List<FundSource>>> call(NoParams params) async {
    return await repo.getFundSources();
  }

}