import 'package:either_dart/src/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetTotalExpenseBasedOnCategoryUseCase extends UseCase<List<LogDetail>, GetTotalExpenseBasedOnCategoryUseCaseParams> {

  final ExpenseRepository repository;

  GetTotalExpenseBasedOnCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<LogDetail>>> call(GetTotalExpenseBasedOnCategoryUseCaseParams params) async {
    return await repository.getExpenseTotalBasedCategoryInMonth(params.fromDate, params.untilDate);
  }

}

class GetTotalExpenseBasedOnCategoryUseCaseParams {

  final DateTime fromDate, untilDate;

  GetTotalExpenseBasedOnCategoryUseCaseParams({required this.fromDate, required this.untilDate});

}