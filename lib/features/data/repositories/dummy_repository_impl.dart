import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/finance_floor_db.dart';
import 'package:expense_app/features/data/models/floor/expenses_dto.dart';
import 'package:expense_app/features/data/models/floor/fund_sources_dto.dart';
import 'package:expense_app/features/data/models/floor/users_dto.dart';
import 'package:flutter/material.dart';

class DummyRepositoryImpl {

  late FinanceFloorDB? db;


  DummyRepositoryImpl() {
    initDb();
  }

  Future<void> initDb() async {
    db = await $FloorFinanceFloorDB.databaseBuilder("finance_db5.db").build();
  }

  Future<void> _checkDb() async {
    await initDb();
  }

  String _dbNow() {
    return DateUtil.dbFormat.format(DateTime.now());
  }

  Future<void> insertUser() async {
    await _checkDb();

    UsersDTO user = UsersDTO(
        id: 1, name: "Fikri", username: "fikrihkl", password: "fikri123");
    var listUsers = await db!.userDao.getUsers();
    if (listUsers.isEmpty) {
      await db!.userDao.insertUsers(user);
    }
    listUsers = await db!.userDao.getUsers();
    debugPrint("${listUsers.first.id} - ${listUsers.first.name}");
  }

  Future<void> insertDummyData() async {
    await _checkDb();

    List<FundSourcesDTO> funds = [
      FundSourcesDTO(id: 1,
          user_id: 1,
          name: "Monthly Extra",
          daily_fund: null,
          weekly_fund: null,
          monthly_fund: 150000,
          created_at: _dbNow(),
          updated_at: _dbNow()),
      FundSourcesDTO(id: 2,
          user_id: 1,
          name: "Monthly Needs",
          daily_fund: null,
          weekly_fund: null,
          monthly_fund: 400000,
          created_at: _dbNow(),
          updated_at: _dbNow()),
      FundSourcesDTO(id: 3,
          user_id: 1,
          name: "Monthly Teeth",
          daily_fund: null,
          weekly_fund: null,
          monthly_fund: 300000,
          created_at: _dbNow(),
          updated_at: _dbNow()),
      FundSourcesDTO(id: 4,
          user_id: 1,
          name: "Weekly Fun",
          daily_fund: null,
          weekly_fund: 150000,
          monthly_fund: null,
          created_at: _dbNow(),
          updated_at: _dbNow()),
      FundSourcesDTO(id: 5,
          user_id: 1,
          name: "Daily",
          daily_fund: 50000,
          weekly_fund: null,
          monthly_fund: null,
          created_at: _dbNow(),
          updated_at: _dbNow()),
      FundSourcesDTO(id: 6,
          user_id: 1,
          name: "Monthly Transportation",
          daily_fund: null,
          weekly_fund: null,
          monthly_fund: 490000,
          created_at: _dbNow(),
          updated_at: _dbNow())
    ];

    await db!.fundSourceDao.insertFundSource(funds[0]);
    await db!.fundSourceDao.insertFundSource(funds[1]);
    await db!.fundSourceDao.insertFundSource(funds[2]);
    await db!.fundSourceDao.insertFundSource(funds[3]);
    await db!.fundSourceDao.insertFundSource(funds[4]);
    await db!.fundSourceDao.insertFundSource(funds[5]);

    var listFunds = await db!.fundSourceDao.getFundSources();
  }
  
  Future<void> insertExpenses() async {
    await _checkDb();
    
    List<ExpensesDTO> expenses = [
      ExpensesDTO(id: null, user_id: 1, fund_source_id: 5, description: "Makan Siang", category: "Meal", nominal: 14000, date: "2022-8-22 12:30", created_at: _dbNow(), updated_at: _dbNow()),
      ExpensesDTO(id: null, user_id: 1, fund_source_id: 5, description: "Makan Malam", category: "Meal", nominal: 18000, date: "2022-8-25 19:30", created_at: _dbNow(), updated_at: _dbNow()),
      ExpensesDTO(id: null, user_id: 1, fund_source_id: 4, description: "Marugame", category: "Food", nominal: 78000, date: "2022-8-28 20:30", created_at: _dbNow(), updated_at: _dbNow()),
      ExpensesDTO(id: null, user_id: 1, fund_source_id: 4, description: "KK Vanila Latte", category: "Drink", nominal: 34000, date: "2022-7-22 14:30", created_at: _dbNow(), updated_at: _dbNow()),
      ExpensesDTO(id: null, user_id: 1, fund_source_id: 5, description: "Makan Malam", category: "Meal", nominal: 25000, date: "2022-7-14 19:30", created_at: _dbNow(), updated_at: _dbNow()),
      ExpensesDTO(id: null, user_id: 1, fund_source_id: 1, description: "KSK", category: "Drink", nominal: 14000, date: "2022-8-14 19:30", created_at: _dbNow(), updated_at: _dbNow()),
      ExpensesDTO(id: null, user_id: 1, fund_source_id: 2, description: "Spotify", category: "Subs", nominal: 25000, date: "2022-7-22 18:30", created_at: _dbNow(), updated_at: _dbNow()),
    ];
    await db!.expenseDao.insertExpense(expenses[0]);
    await db!.expenseDao.insertExpense(expenses[1]);
    await db!.expenseDao.insertExpense(expenses[2]);
    await db!.expenseDao.insertExpense(expenses[3]);
    await db!.expenseDao.insertExpense(expenses[4]);
    await db!.expenseDao.insertExpense(expenses[5]);
    await db!.expenseDao.insertExpense(expenses[6]);

    List<ExpensesDTO> getResult = await db!.expenseDao.getExpensesAll();
    debugPrint("EXP TOTAL ${getResult.length}");
  }

  Future<void> insertOneExp() async {
    var expense = ExpensesDTO(id: -1, user_id: 1, fund_source_id: 5, description: "Makan Siang", category: "Meal", nominal: 14000, date: "2022-8-22 12:30", created_at: _dbNow(), updated_at: _dbNow());
    await db!.expenseDao.insertExpense(expense);
    List<ExpensesDTO> getResult = await db!.expenseDao.getExpensesAll();
    debugPrint("${getResult.last.id} | ${getResult.last.description}");
  }

}