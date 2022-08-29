import 'package:expense_app/features/data/datasources/localdatasource/floor/expense_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/fund_source_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/user_dao.dart';
import 'package:expense_app/features/data/models/floor/expenses_dto.dart';
import 'package:expense_app/features/data/models/floor/fund_sources_dto.dart';
import 'package:expense_app/features/data/models/floor/results/expenses_result_dto.dart';
import 'package:expense_app/features/data/models/floor/results/fund_source_result_dto.dart';
import 'package:expense_app/features/data/models/floor/users_dto.dart';
import 'package:floor/floor.dart';

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'finance_floor_db.g.dart'; // the generated code will be there

@Database(version: 2, entities: [UsersDTO, ExpensesDTO, FundSourcesDTO, ExpensesResultDTO, FundSourceResultDTO])
abstract class FinanceFloorDB extends FloorDatabase {
  ExpenseDao get expenseDao;
  FundSourceDao get fundSourceDao;
  UserDao get userDao;
}