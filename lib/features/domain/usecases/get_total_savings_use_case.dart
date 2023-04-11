import 'package:either_dart/src/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetTotalSavingsUseCase extends UseCase<double, GetTotalSavingsUseCaseParams> {

  final ExpenseRepository repository;

  GetTotalSavingsUseCase({required this.repository});

  @override
  Future<Either<Failure, double>> call(GetTotalSavingsUseCaseParams params) async {
    return await repository.getTotalSavings(params.fromDate, params.untilDate);
  }

}

class GetTotalSavingsUseCaseParams {

  final DateTime fromDate, untilDate;

  GetTotalSavingsUseCaseParams({required this.fromDate, required this.untilDate});

}