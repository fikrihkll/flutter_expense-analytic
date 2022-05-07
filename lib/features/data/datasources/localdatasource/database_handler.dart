import 'package:expense_app/features/data/models/log_detail_model.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler{

  static const String _tableUser = 'user';
  static const String _tableLog = 'log';

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
          month INTEGER NOT NULL,
          year INTEGER NOT NULL,
          user_id INTEGER NOT NULL
          );
          ''',
        );
      },
      version: 2,
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

  Future<void> deleteLog(int id) async {
    final db = await _getDatabase();
    await db.delete(
      _tableLog,
      where: "id = ?",
      whereArgs: [id],
    );
  }

}