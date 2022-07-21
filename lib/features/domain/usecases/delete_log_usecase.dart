import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class DeleteLogUseCase extends UseCase<void, DeleteLogUseCaseParams>{

  final ExpenseRepository repo;


  DeleteLogUseCase({required this.repo});

  @override
  Future<Either<Failure, void>> call(DeleteLogUseCaseParams params) async {
    return await repo.deleteLog(params.id);
  }

}

class DeleteLogUseCaseParams {
  final int id;

  DeleteLogUseCaseParams({required this.id});
}