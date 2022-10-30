
import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/data/models/fund_detail_model.dart';
import 'package:expense_app/features/data/models/log_detail_model.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/entities/fund_detail.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';
import 'package:flutter/material.dart';

class ExpenseRepositoryImpl extends ExpenseRepository {

  final LocalDataSource localDataSource;


  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> deleteLog(int id) async {
    try{
      await localDataSource.deleteLog(id);
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FundDetail>>> getDetailExpenseIntMonth(DateTime fromDate, DateTime untilDate) async {
    try{
      var result = await localDataSource.getDetailExpenseIntMonth(
          DateUtil.dbDateFormat.format(fromDate),
          DateUtil.dbDateFormat.format(untilDate)
      );

      var resultMapped = result.map((e) => FundDetailModel.fromJson(e)).toList();
      return Right(resultMapped);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FundSource>>> getFundSources() async {
    try{
      var result = await localDataSource.getFundSources();
      var resultMapped = result.map((e) => FundSourceModel.fromMap(e)).toList();
      return Right(resultMapped);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Log>>> getLogsInMonth(DateTime fromDate, DateTime untilDate, int limit, int page, {int? fundIdFilter, String? categoryFilter}) async {
    try{
      var result = await localDataSource.getLogsInMonth(
          DateUtil.dbDateFormat.format(fromDate),
          DateUtil.dbDateFormat.format(untilDate),
          limit, page, fundIdFilter: fundIdFilter,
          categoryFilter: categoryFilter
      );
      var resultMapped = result.map((e) => LogModel.fromMap(e)).toList();
      debugPrint("LENGTH ALL LOGS => ${resultMapped.length}");
      return Right(resultMapped);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Log>>> getRecentLogs() async {
    try{
      var result = await localDataSource.getRecentLogs();
      var resultMapped = result.map((e) => LogModel.fromMap(e)).toList();
      return Right(resultMapped);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTodayExpense() async {
    try{
      var result = await localDataSource.getTodayExpense(
          DateUtil.dbDateFormat.format(DateTime.now()),
          _isTodayWeekend(DateTime.now())
      );
      debugPrint("TODAY EXPENSE "+result.toString());
      return Right(result.toInt());
    }catch(e){
      debugPrint("TEST "+e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTodayLimit() async {
    try{
      var now = DateTime.now();

      var result = await localDataSource.getTodayLimit(
          _isTodayWeekend(now)
      );
      return Right(result.toInt());
    }catch(e){
      debugPrint("TEST LIMIT " + e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> insertDummyUser() async {
    try{
      await localDataSource.insertDummyUser();
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> insertExpense(LogModel log) async {
    try{
      await localDataSource.insertExpense(
          LogModel.toMap(log)
      );
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> insertFundSource(FundSourceModel fundSource) async {
    try{
      await localDataSource.insertFundSource(
          FundSourceModel.toMap(fundSource)
      );
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateExpense(LogModel log) async {
    try{
      await localDataSource.updateExpense(
          LogModel.toMap(log)
      );
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateFundSource(FundSourceModel fundSource) async {
    try{
      await localDataSource.updateFundSource(
          FundSourceModel.toMap(fundSource)
      );
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  bool _isTodayWeekend(DateTime dateTime) {
    if (dateTime.weekday == 7) return true;
    if (dateTime.weekday == 6) return true;
    if (dateTime.weekday == 5) return true;
    if (dateTime.weekday == 4) return true;

    return false;
  }

  @override
  Future<Either<Failure, int>> getExpenseInMonth(DateTime? fromDate, DateTime? untilDate) async {
    try{
      String finalFromDate = fromDate != null ? DateUtil.dbDateFormat.format(fromDate) : DateUtil.dbDateFormat.format(DateUtil.getFirstDateOfThisMonth());
      String finalUntilDate = untilDate != null ? DateUtil.dbDateFormat.format(untilDate) : DateUtil.dbDateFormat.format(DateUtil.getLastDateOfThisMonth());
      var result = await localDataSource.getExpenseInMonth(finalFromDate, finalUntilDate);
      debugPrint("EXPENSE HERE ${result} $finalFromDate $finalUntilDate");
      return Right(result);
    }catch(e){
      debugPrint("ERROR HERE " + e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LogDetail>>> getExpenseTotalBasedCategoryInMonth(DateTime fromDate, DateTime untilDate) async {
    try{
      var result = await localDataSource.getTotalBasedOnCategory(
          DateUtil.dbDateFormat.format(fromDate),
          DateUtil.dbDateFormat.format(untilDate)
      );
      var resultMapped = result.map((e) => LogDetailModel.fromJson(e)).toList();
      debugPrint("CAT HERE ${resultMapped.length}" );
      return Right(resultMapped);
    }catch(e){
      debugPrint("ERROR HERE " + e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalSavings(DateTime fromDate, DateTime untilDate,) async {
    try{
      var totalFunds = await localDataSource.getTotalFunds(
          DateUtil.dbDateFormat.format(fromDate),
          DateUtil.dbDateFormat.format(untilDate)
      );
      var totalExpense = await localDataSource.getExpenseInMonth(
          DateUtil.dbDateFormat.format(fromDate),
          DateUtil.dbDateFormat.format(untilDate)
      );
      return Right(totalFunds - totalExpense);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFundSource(int id) async {
    try{
      await localDataSource.deleteFundSource(
          id
      );
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalFunds(DateTime fromDate, DateTime untilDate) async {
    try{
      var totalFunds = await localDataSource.getTotalFunds(
          DateUtil.dbDateFormat.format(fromDate),
          DateUtil.dbDateFormat.format(untilDate)
      );

      return Right(totalFunds);
    }catch(e){
      debugPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

}