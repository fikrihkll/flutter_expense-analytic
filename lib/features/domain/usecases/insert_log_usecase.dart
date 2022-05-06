import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class InsertLogUseCase extends UseCase<void, InsertLogUseCaseParams>{

  final ExpenseRepository repo;

  InsertLogUseCase({required this.repo});

  @override
  Future<Either<Failure, void>> call(InsertLogUseCaseParams params) async {
    return await repo.insertLog(params.data);
  }

}

class InsertLogUseCaseParams {
  final Log data;

  InsertLogUseCaseParams({required this.data});
}