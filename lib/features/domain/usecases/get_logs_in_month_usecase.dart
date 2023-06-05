import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetLogsInMonthUseCase extends UseCase<List<Log>, GetLogsInMonthUseCaseParams>{

  final ExpenseRepository repo;

  GetLogsInMonthUseCase({required this.repo});

  @override
  Future<Either<Failure, List<Log>>> call(GetLogsInMonthUseCaseParams params) async {
    return await repo.getLogsInMonth(
        params.fromDate,
        params.untilDate,
        params.limit,
        params.page,
        fundIdFilter: params.fundIdFilter,
        categoryFilter: params.categoryFilter
    );
  }

}

class GetLogsInMonthUseCaseParams {

  final DateTime fromDate, untilDate;
  final int limit, page;
  final String? categoryFilter;
  final String? fundIdFilter;

  GetLogsInMonthUseCaseParams({
    required this.fromDate,
    required this.untilDate,
    required this.limit,
    required this.page,
    this.categoryFilter,
    this.fundIdFilter
  });

}