import 'package:expense_app/features/data/datasources/localdatasource/dao/expense_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/data/models/log_detail_model.dart';
import 'package:expense_app/features/data/models/log_model.dart';

abstract class LocalDataSource{

  Future<void> insertLogs(Map<String, dynamic> data);

  // Future<void> createUser(UserTable data);

  Future<List<LogModel>> getLatestLogs();

  Future<int> getMonthExpense(int month, int year);

  Future<List<LogModel>> getLogsInMonth(int month, int year, int limit);

  Future<void> deleteLog(int id);

  Future<List<LogDetailModel>> getLogsDetailInMonth(int month, int year);

}

class LocalDataSourceImpl extends LocalDataSource{

  final DatabaseHandler databaseHandler;

  LocalDataSourceImpl({required this.databaseHandler});

  @override
  Future<void> deleteLog(int id) async {
    await databaseHandler.deleteLog(id);
  }

  @override
  Future<List<LogModel>> getLatestLogs() async {
    var result = await databaseHandler.getRecentLogs();
    return result;
  }

  @override
  Future<List<LogDetailModel>> getLogsDetailInMonth(int month, int year) async {
    throw Exception('');
  }

  @override
  Future<List<LogModel>> getLogsInMonth(int month, int year, int limit) async {
    throw Exception('');
  }

  @override
  Future<int> getMonthExpense(int month, int year) async {
    var result = await databaseHandler.getExpenseInMonth(month, year);
    return result;
  }

  @override
  Future<void> insertLogs(Map<String, dynamic> data) async {
    await databaseHandler.insertLog(data);
  }

}