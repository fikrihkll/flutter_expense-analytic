import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/models/log_model.dart';
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
  Future<Either<Failure, int>> getExpenseInMonth(int month, int year) async {
    try{
      var result = await localDataSource.getMonthExpense(month, year);
      return Right(result);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<LogDetail>>> getLogsDetailInMonth(int month, int year) async {
    try{
      var result = await localDataSource.getLogsDetailInMonth(month, year);
      return Right(result);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Log>>> getLogsInMonth(int month, int year, int limit) async {
    try{
      var result = await localDataSource.getLogsInMonth(month, year, limit);
      return Right(result);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Log>>> getLatestLogs() async {
    try{
      var result = await localDataSource.getLatestLogs();
      return Right(result);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> insertLog(Log data) async {
    try{
      var packedData = LogModel.toMap(data);
      await localDataSource.insertLogs(packedData);
      return const Right(true);
    }catch(e){
      debugPrint(e.toString());
      return Left(CacheFailure());
    }
  }

}