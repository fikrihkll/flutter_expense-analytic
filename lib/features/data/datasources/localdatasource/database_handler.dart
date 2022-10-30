import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/query_handler.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/data/models/log_detail_model.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/main.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler{

  static const String tableUsers = 'users';
  static const String tableExpenses = 'expenses';
  static const String tableFundSources = 'fund_sources';

  late Database? db=null;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'expense.db'),
      onUpgrade: (database, oldVersion, newVersion) async {
        await database.execute("ALTER TABLE $tableFundSources ADD COLUMN deleted_at TIMESTAMP NULL");
      },
      onCreate: (database, version) async {
        await database.execute(
          '''
          CREATE TABLE $tableUsers(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          username TEXT NOT NULL, 
          pass TEXT NOT NULL, 
          name TEXT NOT NULL,
          created_at TIMESTAMP NOT NULL,
          updated_at TIMESTAMP NOT NULL
          );
          ''',
        );
        await database.execute(
          '''
          CREATE TABLE $tableExpenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          fund_source_id INTEGER NULL, 
          description TEXT NOT NULL, 
          category TEXT NOT NULL,
          nominal INTEGER NOT NULL,
          date DATETIME NOT NULL,
          day INTEGER NOT NULL,
          month INTEGER NOT NULL,
          year INTEGER NOT NULL,
          created_at TIMESTAMP NOT NULL,
          updated_at TIMESTAMP NOT NULL
          );
          ''',
        );
        await database.execute(
          '''
          CREATE TABLE $tableFundSources(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          user_id INTEGER NOT NULL, 
          name TEXT NOT NULL, 
          daily_fund INTEGER NULL,
          weekly_fund INTEGER NULL,
          monthly_fund INTEGER NULL,
          created_at TIMESTAMP NOT NULL,
          updated_at TIMESTAMP NOT NULL,
          deleted_at TIMESTAMP NULL
          );
          ''',
        );
      },
      version: 5,
    );
  }

  Future<Database> _getDatabase()async{
    if(db == null){
      db = await initializeDB();
      return db!;
    }else{
      return db!;
    }
  }

  Future<int> insertUser() async {
    int result = 0;
    final Database db = await _getDatabase();

    result = await db.insert(tableUsers, {
      "id": null,
      "name": "Fikri Haikal",
      "username": "fikrihkl",
      "pass": "123",
      "created_at": DateUtil.dbFormat.format(DateTime.now()),
      "updated_at": DateUtil.dbFormat.format(DateTime.now()),
    });

    return result;
  }

  Future<int> insertExpense(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();

    data['id'] = null;
    // Insert TodoModel to database which model that has been converted to map
    result = await db.insert(tableExpenses, data);
    return result;
  }

  Future<int> updateExpense(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();

    result = await db.rawUpdate(
        "UPDATE $tableExpenses SET nominal = ?, date = ?, description = ?, category = ?, fund_source_id = ? WHERE id = ?",
        [
          data["nominal"],
          data["date"],
          data["description"],
          data["category"],
          data["fund_source_id"],
          data["id"]
        ]
    );
    return result;
  }

  Future<int> updateFundSource(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();
    await db.rawUpdate(
        'UPDATE $tableFundSources SET daily_fund = ?, weekly_fund = ?, monthly_fund = ?, name = ? WHERE id = ?',
        [
          data["daily_fund"],
          data["weekly_fund"],
          data["monthly_fund"],
          data["name"],
          data["id"]
        ]
    );
    return result;
  }

  Future<int> insertFundSource(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();

    result = await db.insert(tableFundSources, data);

    return result;
  }

  Future<int> deleteFundSource(int id) async {
    int result = 0;
    final Database db = await _getDatabase();

    await db.rawQuery("UPDATE $tableFundSources SET deleted_at = '${DateUtil.dbFormat.format(DateTime.now())}' WHERE id = $id");

    return result;
  }

  Future<int?> getTodayExpense(String date, bool isTodayWeekend) async {
    final Database db = await _getDatabase();

    final List<Map<String, dynamic>> queryResult = await db.rawQuery(QueryHandler.getTodayExpense(date, isTodayWeekend));
    return queryResult.first['nominal'];
  }

  Future<int?> getMonthlyExpense(String startDate, String endDate) async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
        QueryHandler.getMonthlyExpense(startDate, endDate)
    );

    return queryResult.first['nominal'];
  }

  Future<double?> getTodayLimit(bool isWeekend) async {
    final Database db = await _getDatabase();
    double totalLimit = 0;

    if(isWeekend){
      final List<Map<String, dynamic>> queryDailyResult = await db.rawQuery(QueryHandler.getDailyFundLimit());
      final List<Map<String, dynamic>> queryWeeklyResult = await db.rawQuery(QueryHandler.getWeekendFundLimit());

      if (queryDailyResult.first["daily_fund"] != null && queryWeeklyResult.first["weekly_fund"] != null) {
        totalLimit = queryDailyResult.first["daily_fund"] + queryWeeklyResult.first["weekly_fund"];
      } else if (queryDailyResult.first["daily_fund"] != null && queryWeeklyResult.first["weekly_fund"] == null) {
        totalLimit = queryDailyResult.first["daily_fund"];
      } else if (queryDailyResult.first["daily_fund"] == null && queryWeeklyResult.first["weekly_fund"] != null) {
        totalLimit = queryDailyResult.first["weekly_fund"];
      }

    }else{
      final List<Map<String, dynamic>> queryDailyResult = await db.rawQuery(QueryHandler.getDailyFundLimit());

      if (queryDailyResult.first["daily_fund"] != null) {
        totalLimit = queryDailyResult.first["daily_fund"];
      }
    }

    return totalLimit;
  }

  Future<List<Map<String, dynamic>>> getRecentLogs() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(QueryHandler.getRecentLogs());
    // Convert from map to model then will be converted to list
    return queryResult;
  }

  Future<List<Map<String, dynamic>>> getLogsInMonth(String fromDate, String untilDate, int limit, int page, {int fundIdFilter = -1, String categoryFilter = ""}) async {
    final Database db = await _getDatabase();
    int offset = (page-1) * limit;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(QueryHandler.getLogsInMonth(fromDate, untilDate, limit, page, offset, fundIdFilter: fundIdFilter, categoryFilter: categoryFilter));
    return queryResult;
  }

  Future<List<Map<String, dynamic>>> getCategoryListFromExistingFund(String fromDate, String untilDate, int fundId) async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(QueryHandler.getCategoryListFromExistingFund(fundId, fromDate, untilDate));
    return queryResult;
  }

  Future<List<Map<String, dynamic>>> getFundSources() async {
    final Database db = await _getDatabase();
    String query = QueryHandler.getFundSources();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(query);
    return queryResult;
  }

  Future<List<Map<String, dynamic>>> getTotalBasedOnCategory(String fromDate, String untilDate) async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(QueryHandler.getTotalBasedOnCategory(fromDate, untilDate));
    return queryResult;
  }

  Future<List<Map<String, dynamic>>> getDetailExpenseInMonth(String fromDate, String untilDate) async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(QueryHandler.getDetailExpenseInMonth(fromDate, untilDate));
    return queryResult;
  }

  Future<List<Map<String, dynamic>>> getTotalFunds(String fromDate, String untilDate) async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(QueryHandler.getTotalFunds(fromDate, untilDate));

    return queryResult;
  }

  Future<void> printLogData() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('SELECT * FROM $tableExpenses');
    String log = '';
    queryResult.forEach((e) {log += '${e['desc']}|${e['category']}|${e['nominal']}|${e['date']}|${e['day']}|${e['month']}|${e['year']}|${e['user_id']}~\n';});

    debugPrint('PRINT ${queryResult.length}');
    debugPrint(log);
  }

  Future<void> deleteExpense(int id) async {
    final db = await _getDatabase();
    await db.delete(
      tableExpenses,
      where: "id = ?",
      whereArgs: [id],
    );
  }

}