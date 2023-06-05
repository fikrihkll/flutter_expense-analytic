import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/migration_handler.dart';
import 'package:expense_app/features/data/datasources/localdatasource/query_handler.dart';
import 'package:expense_app/features/data/models/budget_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseHandler {

  // TODO manual query update for field budget_id in fund_sources, expenses
  // TODO manual query update for field user_id in fund_sources, expenses
  // TODO change update and insert method in this class for handling UUID id

  static const String tableUsers = 'users';
  static const String tableExpenses = 'expenses';
  static const String tableFundSources = 'fund_sources';
  static const String tableBudgets = 'budgets';
  static const String tableBudgetUsers = 'budget_users';

  late Database? db = null;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'expense.db'),
      onUpgrade: MigrationHandler.onUpgrade,
      onCreate: (database, version) async {
        await database.execute(
          QueryHandler.createTableUsers(),
        );
        await database.execute(
          QueryHandler.createTableExpenses(),
        );
        await database.execute(
          QueryHandler.createTableFundSources(),
        );
      },
      version: 6,
    );
  }

  Future<Database> _getDatabase() async {
    if(db == null){
      db = await initializeDB();
      return db!;
    }else{
      return db!;
    }
  }

  Future<int> insertUser(String name, String username, String email) async {
    int result = 0;
    final Database db = await _getDatabase();

    result = await db.insert(tableUsers, {
      "id": null,
      "name": name,
      "username": username,
      "email": email,
      "pass": ":P",
      "created_at": DateUtil.dbFormat.format(DateTime.now()),
      "updated_at": DateUtil.dbFormat.format(DateTime.now()),
    });

    return result;
  }

  Future<int> insertExpense(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();

    data['id'] = const Uuid().v4();
    data['budget_id'] = null;
    if (data['budget_id'] == null) {
     data['budget_id'] = '1';
    }
    // Insert TodoModel to database which model that has been converted to map
    result = await db.insert(tableExpenses, data);
    return result;
  }

  Future<int> updateExpense(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();

    result = await db.rawUpdate(
        "UPDATE $tableExpenses SET nominal = ?, date = ?, description = ?, category = ?, fund_source_id = ?, budget_id = ? WHERE id = ?",
        [
          data["nominal"],
          data["date"],
          data["description"],
          data["category"],
          data["fund_source_id"],
         data["budget_id"] ?? '1',
          data["id"]
        ]
    );
    return result;
  }

  Future<int> updateFundSource(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();
    await db.rawUpdate(
        'UPDATE $tableFundSources SET daily_fund = ?, weekly_fund = ?, monthly_fund = ?, name = ?, budget_id = ? WHERE id = ?',
        [
          data["daily_fund"],
          data["weekly_fund"],
          data["monthly_fund"],
          data["name"],
         data["budget_id"] ?? '1',
          data["id"]
        ]
    );
    return result;
  }

  Future<int> insertFundSource(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();

    data['id'] = const Uuid().v4();
    data['budget_id'] = null;
    if (data['budget_id'] == null) {
     data['budget_id'] = '1';
    }

    result = await db.insert(tableFundSources, data);

    return result;
  }

  Future<int> deleteFundSource(String id) async {
    int result = 0;
    final Database db = await _getDatabase();

    await db.rawQuery("UPDATE $tableFundSources SET deleted_at = '${DateUtil.dbFormat.format(DateTime.now())}' WHERE id = $id");

    return result;
  }

  Future<double?> getTodayExpense(String date, bool isTodayWeekend) async {
    final Database db = await _getDatabase();

    final List<Map<String, dynamic>> queryResult = await db.rawQuery(QueryHandler.getTodayExpense(date, isTodayWeekend));
    return queryResult.first['nominal'];
  }

  Future<double?> getMonthlyExpense(String startDate, String endDate) async {
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

  Future<List<Map<String, dynamic>>> getLogsInMonth(String fromDate, String untilDate, int limit, int page, {String fundIdFilter = "", String categoryFilter = ""}) async {
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

  Future<void> deleteExpense(String id) async {
    final db = await _getDatabase();
    await db.delete(
      tableExpenses,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // TODO NOT UPDATED
  Future<void> insertBudget(int userId, BudgetModel entity) async {
    final db = await _getDatabase();
    await db.insert(
      tableBudgets,
      entity.toMap()
    );
  }

  // TODO NOT UPDATED
  Future<void> insertBudgetUser(int id, String name, String username, String image) async {
    final db = await _getDatabase();
    await db.insert(
        tableBudgets,
        {
          "id": id,
          "name": name,
          "username": username,
          "image": image,
        }
    );
  }



}