import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

class GetRecentLogsUseCase extends UseCase<List<Log>, NoParams>{

  final ExpenseRepository repo;


  GetRecentLogsUseCase({required this.repo});

  @override
  Future<Either<Failure, List<Log>>> call(NoParams params) async {
    return await repo.getRecentLogs();
  }

}