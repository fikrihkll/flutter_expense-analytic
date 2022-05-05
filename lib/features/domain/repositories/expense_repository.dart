import 'package:expense_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';

abstract class ExpenseRepository{
  Future<Either<Failure, int>> getExpenseInMonth(int month, int year);
  Future<Either<Failure, List<Log>>> getgetRecentLogs();
  Future<Either<Failure, List<Log>>> getLogsInMonth(int month, int year);
  Future<Either<Failure, bool>> insertLog(Log data);
  Future<Either<Failure, bool>> deleteLog(int id);
  Future<Either<Failure, List<LogDetail>>> getLogsDetailInMonth(int month, int year);
}