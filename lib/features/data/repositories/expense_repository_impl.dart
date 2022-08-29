import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/expense_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/finance_floor_db.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/fund_source_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/data/models/fund_source_model.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/entities/fund_source_entity.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';
import 'package:flutter/material.dart';

class ExpenseRepositoryImpl extends ExpenseRepository {

  final ExpenseDao expenseDao;
  final FundSourceDao fundDao;

  ExpenseRepositoryImpl({required this.expenseDao, required this.fundDao});

  @override
  Future<Either<Failure, bool>> deleteLog(int id) async {
    try{
      await expenseDao.deleteExpenses(id);
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getExpenseInMonth(DateTime dateStart, DateTime dateEnd) async {
    try{
      var dbDateStart = DateUtil.dbFormat.format(dateStart);
      var dbDateEnd = DateUtil.dbFormat.format(dateEnd);
      // var result = await expenseDao.getMonthExpense(dbDateStart, dbDateEnd);
      return Right(0);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<LogDetail>>> getLogsDetailInMonth(int month, int year) async {
    try{
      // var result = await localDataSource.getLogsDetailInMonth(month, year);
      return Right([]);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Log>>> getLogsInMonth(DateTime dateStart, DateTime dateEnd, int limit, int page) async {
    try{
      var dbDateStart = DateUtil.dbDateFormat.format(dateStart);
      var dbDateEnd = DateUtil.dbDateFormat.format(dateEnd);
      int offset = (page-1) * limit;
      var result = await expenseDao.getExpenses(dbDateStart, dbDateEnd, limit, offset);

      List<Log> resultMapped = result.map((e) => LogModel.fromDTO(e)).toList();

      return Right(resultMapped);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Log>>> getLatestLogs() async {
    try{
      var result = await expenseDao.getLatestExpenses();

      List<Log> resultMapped = result.map((e) => LogModel.fromDTO(e)).toList();

      return Right(resultMapped);
    }catch(e){
      debugPrint("ERROR ${e}");
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> insertLog(Log data) async {
    try{
      var mappedData = LogModel.toDto(data);
      await expenseDao.insertExpense(mappedData);
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getTodayBalanceLeft() async {
    try{
      DateTime now = DateTime.now();
      bool isWeekdays = now.weekday >= 1 && now.weekday <= 4;

      var result = 0;
      return Right(result);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> insertExpenseLimit(ExpenseLimit data) async {
    try{
      var convertedData = ExpenseLimitModel.toMap(data);
      // await expenseDao.insertExpenseLimit(convertedData);
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ExpenseLimit>> getExpenseLimit() async {
    try{
      var now = DateTime.now();
      // var result = await localDataSource.getExpenseLimit(now.month, now.year);
      return Right(ExpenseLimit(id: 0, weekdaysLimit: 0, weekendLimit: 0, balanceInMonth: 0, month: 0, year: 0));
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<FundSource>>> getFundSources() async {
    try{
      var result = await fundDao.getFundSources();
      debugPrint("REPO ${result.length}");
      var resultMapped = result.map((e) => FundSource.fromModel(FundSourceModel.fromDTO(e))).toList();
      return Right(resultMapped);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

}