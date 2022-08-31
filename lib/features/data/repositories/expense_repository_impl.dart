
import 'package:either_dart/either.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/data/models/fund_detail_model.dart';
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
      return Left(CacheFailure());
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
      return Left(CacheFailure());
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
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Log>>> getLogsInMonth(DateTime fromDate, DateTime untilDate, int limit, int page) async {
    try{
      var result = await localDataSource.getLogsInMonth(
          DateUtil.dbDateFormat.format(fromDate),
          DateUtil.dbDateFormat.format(untilDate),
          limit, page
      );
      var resultMapped = result.map((e) => LogModel.fromMap(e)).toList();
      return Right(resultMapped);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
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
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getTodayExpense() async {
    try{
      var result = await localDataSource.getTodayExpense(DateUtil.dbDateFormat.format(DateTime.now()));
      return Right(result.toInt());
    }catch(e){
      debugPrint("TEST "+e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getTodayLimit() async {
    try{
      var now = DateTime.now();

      var result = await localDataSource.getTodayLimit(
          _isTodayWeekend(now)
      );
      return Right(result);
    }catch(e){
      debugPrint("TEST LIMIT " + e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> insertDummyUser() async {
    try{
      await localDataSource.insertDummyUser();
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
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
      return Left(CacheFailure());
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
      return Left(CacheFailure());
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
      return Left(CacheFailure());
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
      return Left(CacheFailure());
    }
  }

  bool _isTodayWeekend(DateTime dateTime) {
    if (dateTime.weekday == 6) return true;
    if (dateTime.weekday == 5) return true;
    if (dateTime.weekday == 4) return true;
    if (dateTime.weekday == 3) return true;

    return false;
  }

  @override
  Future<Either<Failure, int>> getExpenseInMonth(DateTime? fromDate, DateTime? untilDate) async {
    try{
      DateTime now = DateTime.now();
      String finalFromDate = fromDate != null ? DateUtil.dbDateFormat.format(fromDate) : DateUtil.dbDateFormat.format(DateTime(now.year, now.month, 1));
      String finalUntilDate = untilDate != null ? DateUtil.dbDateFormat.format(untilDate) : DateUtil.dbDateFormat.format(DateTime(now.year, now.month, 1).add(Duration(days: DateTime(now.year, now.month, 0).day)));
      debugPrint("${finalFromDate} - ${finalUntilDate}");
      var result = await localDataSource.getExpenseInMonth(finalFromDate, finalUntilDate);
      return Right(result);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

}