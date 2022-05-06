import 'package:expense_app/features/data/datasources/localdatasource/dao/expense_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/tables/log_table.dart';
import 'package:expense_app/features/data/datasources/localdatasource/tables/user_table.dart';
import 'package:floor/floor.dart';

// required package imports
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';


@Database(version: 1, entities: [LogTable, UserTable])
abstract class AppDatabase extends FloorDatabase{
  ExpenseDao get expenseDao;
}