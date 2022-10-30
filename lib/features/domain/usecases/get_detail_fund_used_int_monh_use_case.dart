import 'package:either_dart/src/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/fund_detail.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetDetailFundUsedInMonthUseCase extends UseCase<List<FundDetail>, GetDetailFundUsedInMonthUseCaseParams> {

  final ExpenseRepository repository;
  GetDetailFundUsedInMonthUseCase({required this.repository});

  @override
  Future<Either<Failure, List<FundDetail>>> call(GetDetailFundUsedInMonthUseCaseParams params) async {
    return await repository.getDetailExpenseIntMonth(params.fromDate, params.untilDate);
  }

}

class GetDetailFundUsedInMonthUseCaseParams {
  DateTime fromDate, untilDate;

  GetDetailFundUsedInMonthUseCaseParams({required this.fromDate, required this.untilDate});
}