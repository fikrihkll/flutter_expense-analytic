import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetLogsInMonthUseCase extends UseCase<List<Log>, GetLogsInMonthUseCaseParams>{

  final ExpenseRepository repo;

  GetLogsInMonthUseCase({required this.repo});

  @override
  Future<Either<Failure, List<Log>>> call(GetLogsInMonthUseCaseParams params) async {
    return await repo.getLogsInMonth(params.dateStart, params.dateEnd, params.limit, params.page);
  }

}

class GetLogsInMonthUseCaseParams {

  final DateTime dateStart;
  final DateTime dateEnd;
  final int limit, page;

  GetLogsInMonthUseCaseParams({required this.dateStart, required this.dateEnd, required this.limit, required this.page});

}