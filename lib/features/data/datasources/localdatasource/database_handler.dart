import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/data/models/log_detail_model.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler{

  static const String _tableUser = 'user';
  static const String _tableLog = 'log';
  static const String _tableExpenseLimit = 'expense_limit';

  late Database? db=null;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'todo.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''
          CREATE TABLE $_tableUser(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          username TEXT NOT NULL, 
          pass TEXT NOT NULL, 
          name TEXT NOT NULL
          );
          ''',
        );
        await database.execute(
          '''
          CREATE TABLE $_tableLog(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          desc TEXT NOT NULL, 
          category TEXT NOT NULL,
          nominal INTEGER NOT NULL,
          date TEXT NOT NULL, 
          day INTEGER NOT NULL,
          month INTEGER NOT NULL,
          year INTEGER NOT NULL,
          user_id INTEGER NOT NULL
          );
          ''',
        );
        await database.execute(
          '''
          CREATE TABLE $_tableExpenseLimit(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          month INTEGER NOT NULL, 
          year INTEGER NOT NULL, 
          weekdays_limit INTEGER NOT NULL,
          weekend_limit INTEGER NOT NULL,
          balance_in_month INTEGER NOT NULL,
          user_id INTEGER NOT NULL
          );
          ''',
        );
      },
      version: 1,
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

  Future<int> insertLog(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();

    data['id'] = null;
    // Insert TodoModel to database which model that has been converted to map
    result = await db.insert(_tableLog, data);
    return result;
  }

  Future<int> insertExpenseLimit(Map<String, dynamic> data) async {
    int result = 0;
    final Database db = await _getDatabase();

    final List<Map<String, dynamic>> queryResult = await db.rawQuery('SELECT * FROM $_tableExpenseLimit WHERE month = ${data['month']} AND year = ${data['year']}');

    if(queryResult.isNotEmpty){
      await db.rawQuery('UPDATE $_tableExpenseLimit SET weekdays_limit = ${data['weekdays_limit']}, weekend_limit = ${data['weekend_limit']}, balance_in_month = ${data['balance_in_month']} WHERE id = ${queryResult.first['id']}');
    }else{
      data['id'] = null;
      result = await db.insert(_tableExpenseLimit, data);
    }

    return result;
  }

  Future<int> getTodayExpense(int day, int month, int year) async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('SELECT SUM(nominal) as nominal FROM $_tableLog WHERE day = $day AND month = $month AND year = $year');
    // Convert from map to model then will be converted to list
    return queryResult.first['nominal'];
  }

  Future<int> getTodayLimit(bool isWeekdays, int month, int year) async {
    final Database db = await _getDatabase();
    String query = '';
    if(isWeekdays){
      query = 'SELECT weekdays_limit FROM $_tableExpenseLimit WHERE month = $month AND year = $year';
    }else{
      query = 'SELECT weekend_limit FROM $_tableExpenseLimit WHERE month = $month AND year = $year';
    }
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(query);
    // Convert from map to model then will be converted to list
    return queryResult.first[isWeekdays ? 'weekdays_limit' : 'weekend_limit'];
  }

  Future<List<LogModel>> getRecentLogs() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('SELECT*FROM $_tableLog ORDER BY date DESC LIMIT 10');
    // Convert from map to model then will be converted to list
    return queryResult.map((e) => LogModel.fromMap(e)).toList();
  }

  Future<List<LogModel>> getLogsInMonth(int month, int year, int page, int limit) async {
    final Database db = await _getDatabase();
    int offset = (page-1) * limit;
    String query = 'SELECT*FROM $_tableLog WHERE month = $month AND year = $year ORDER BY date DESC LIMIT $limit OFFSET $offset';
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(query);
    // Convert from map to model then will be converted to list
    return queryResult.map((e) => LogModel.fromMap(e)).toList();
  }

  Future<ExpenseLimitModel> getExpenseLimit(int month, int year) async {
    final Database db = await _getDatabase();
    String query = 'SELECT*FROM $_tableExpenseLimit WHERE month = $month AND year = $year';
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(query);
    // Convert from map to model then will be converted to list
    return queryResult.map((e) => ExpenseLimitModel.fromMap(e)).toList().first;
  }

  Future<List<LogDetailModel>> getLogsDetailInMonth(int month, int year) async {
    final Database db = await _getDatabase();
    String query = 'SELECT category, SUM(nominal) as nominal FROM $_tableLog WHERE month = $month AND year = $year GROUP BY category';
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(query);
    // Convert from map to model then will be converted to list
    return queryResult.map((e) => LogDetailModel.fromMap(e)).toList();
  }

  Future<int> getExpenseInMonth(int month, int year) async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('SELECT SUM(nominal) as nominal FROM $_tableLog WHERE month = $month AND year = $year');
    // Convert from map to model then will be converted to list
    return queryResult.first['nominal'];
  }

  Future<void> printLogData() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('SELECT * FROM $_tableLog');
    String log = '';
    queryResult.forEach((e) {log += '${e['desc']}|${e['category']}|${e['nominal']}|${e['date']}|${e['day']}|${e['month']}|${e['year']}|${e['user_id']}~\n';});

    debugPrint('PRINT ${queryResult.length}');
    debugPrint(log);
  }

  Future<void> insertData() async {
    String data = '''shampoo clear|Toiletries|64700|2022-05-08 10:55|8|5|2022|1~sabun biore|Toiletries|12100|2022-05-08 10:55|8|5|2022|1~sendal jepit|Others|20700|2022-05-08 10:56|8|5|2022|1~totebag indomaret|Others|2500|2022-05-08 10:56|8|5|2022|1~colokan 5m|Tools|40000|2022-05-08 10:56|8|5|2022|1~nasi x2|Meal|10000|2022-05-08 10:57|8|5|2022|1~air putih|Meal|14000|2022-05-08 10:57|8|5|2022|1~sikat gigi formula|Toiletries|16800|2022-05-08 10:57|8|5|2022|1~gunting|Tools|16700|2022-05-08 10:57|8|5|2022|1~tissue|Others|3000|2022-05-08 10:58|8|5|2022|1~listrik|Electricity|100000|2022-05-08 10:58|8|5|2022|1~nasi|Meal|5000|2022-05-08 10:58|8|5|2022|1~starbucks caramel machiato|Drink|64000|2022-05-08 10:59|8|5|2022|1~topup|E-Money|21500|2022-05-08 10:59|8|5|2022|1~masker shumu|Others|51996|2022-05-08 11:00|8|5|2022|1~clayton|Others|135800|2022-05-08 11:00|8|5|2022|1~magic com|Tools|230000|2022-05-08 11:00|8|5|2022|1~nasgor + kwetiaw|Food|33000|2022-05-08 11:00|8|5|2022|1~nasi|Meal|5000|2022-05-08 11:00|8|5|2022|1~warteg telor|Meal|18000|2022-05-08 11:00|null|5|2022|1~jco caramel machiato|Drink|34000|2022-05-08 11:01|8|5|2022|1~piring, gelas, sendok & mangkok|Tools|112000|2022-05-08 11:01|8|5|2022|1~naspad ayam bakar + ayam balado|Meal|30000|2022-05-08 11:02|8|5|2022|1~gojek ke CP|Transportation|10000|2022-05-08 11:30|8|5|2022|1~gojek ke bluekos|Transportation|31000|2022-05-08 11:30|8|5|2022|1~gocar ke starbucks SenCi|Transportation|15000|2022-05-08 11:30|8|5|2022|1~galon|Daily Needs|55000|2022-05-08 11:31|8|5|2022|1~pompa galon|Tools|89000|2022-05-08 11:31|8|5|2022|1~kulkas|Tools|425000|2022-05-08 11:31|8|5|2022|1~warteg + nasi|Meal|21000|2022-05-08 11:31|8|5|2022|1~gula + cococrunch|Meal|36000|2022-05-08 11:32|8|5|2022|1~bakso|Food|5000|2022-05-08 11:32|8|5|2022|1~spoons + mama lemon + brush|Tools|61000|2022-05-08 11:32|8|5|2022|1~naspad|Meal|18000|2022-05-09 02:16|9|5|2022|1~pecel lele|Meal|19000|2022-05-09 07:55|9|5|2022|1~pisau|Tools|24000|2022-05-09 09:33|9|5|2022|1~susu |Drink|6000|2022-05-09 09:33|9|5|2022|1~mentega + kecap|Daily Needs|21000|2022-05-09 09:34|9|5|2022|1~meja|Tools|340000|2022-05-10 10:02|10|5|2022|1~keranjang|Tools|20000|2022-05-10 10:02|10|5|2022|1'''.trim();

    var list = data.split('~').map((e) {
      var innerData = e.split('|').toList();
      var map = {
        'id': null,
        'desc': innerData[0],
        'category': innerData[1],
        'nominal': innerData[2],
        'date': innerData[3],
        'day': innerData[4],
        'month': innerData[5],
        'year': innerData[6],
        'user_id': 1,
      };
      return map;
    }).toList();

    debugPrint('---- MAPPED');
    debugPrint(list.toString());

    var er = '';
    for(int i=0; i<list.length; i++){
      try{
        await insertLog(list[i]);
      }catch(e){
        er += e.toString();
      }
    }
    debugPrint('ERROR ${er}');
  }

  Future<void> deleteLog(int id) async {
    final db = await _getDatabase();
    await db.delete(
      _tableLog,
      where: "id = ?",
      whereArgs: [id],
    );
  }

}