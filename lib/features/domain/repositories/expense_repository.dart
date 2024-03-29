import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/entities/fund_detail.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';

abstract class ExpenseRepository{

  Future<Either<Failure, bool>> insertDummyUser();

  Future<Either<Failure, bool>> insertExpense(LogModel log);

  Future<Either<Failure, bool>> updateExpense(LogModel log);

  Future<Either<Failure, bool>> updateFundSource(FundSourceModel fundSource);

  Future<Either<Failure, bool>> insertFundSource(FundSourceModel fundSource);

  Future<Either<Failure, int>> getTodayExpense();

  Future<Either<Failure, int>> getExpenseInMonth(DateTime? fromDate, DateTime? untilDate);

  Future<Either<Failure, int>> getTodayLimit();

  Future<Either<Failure, int>> getTotalFunds(DateTime fromDate, DateTime untilDate);

  Future<Either<Failure, List<Log>>> getRecentLogs();

  Future<Either<Failure, List<Log>>> getLogsInMonth(DateTime fromDate, DateTime untilDate, int limit, int page, {int? fundIdFilter, String? categoryFilter});

  Future<Either<Failure, List<FundSource>>> getFundSources();

  Future<Either<Failure, List<FundDetail>>> getDetailExpenseIntMonth(DateTime fromDate, DateTime untilDate,);

  Future<Either<Failure, bool>> deleteLog(int id);

  Future<Either<Failure, bool>> deleteFundSource(int id);

  Future<Either<Failure, List<LogDetail>>> getExpenseTotalBasedCategoryInMonth(DateTime fromDate, DateTime untilDate,);

  Future<Either<Failure, int>> getTotalSavings(DateTime fromDate, DateTime untilDate,);
}