import 'package:either_dart/src/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetTotalFundsUseCase extends UseCase<double, GetTotalFundsUseCaseParams> {

  final ExpenseRepository repository;

  GetTotalFundsUseCase({required this.repository});

  @override
  Future<Either<Failure, double>> call(GetTotalFundsUseCaseParams params) async {
    return await repository.getTotalFunds(params.fromDate, params.untilDate);
  }

}

class GetTotalFundsUseCaseParams {

  final DateTime fromDate, untilDate;

  GetTotalFundsUseCaseParams({required this.fromDate, required this.untilDate});

}