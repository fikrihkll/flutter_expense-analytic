import 'package:expense_app/features/data/datasources/localdatasource/dao/expense_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/query_result/log_detail_result.dart';
import 'package:expense_app/features/data/datasources/localdatasource/tables/log_table.dart';
import 'package:expense_app/features/data/datasources/localdatasource/tables/user_table.dart';

abstract class LocalDataSource{

  Future<void> insertLogs(LogTable data);

  Future<void> createUser(UserTable data);

  Future<List<LogTable>> getLatestLogs();

  Future<int> getMonthExpense(int month, int year);

  Future<List<LogTable>> getLogsInMonth(int month, int year, int limit);

  Future<void> deleteLog(int id);

  Future<List<LogDetailResult>> getLogsDetailInMonth(int month, int year);

}

class LocalDataSourceImpl extends LocalDataSource{

  final ExpenseDao expenseDao;


  LocalDataSourceImpl({required this.expenseDao});

  @override
  Future<void> createUser(UserTable data) async {
    await expenseDao.createUser(data);
  }

  @override
  Future<void> deleteLog(int id) async {
    await expenseDao.deleteLog(id);
  }

  @override
  Future<List<LogTable>> getLatestLogs() async {
    var result = await expenseDao.getLatestLogs();
    return result;
  }

  @override
  Future<List<LogDetailResult>> getLogsDetailInMonth(int month, int year) async {
    var result = await expenseDao.getLogsDetailInMonth(month, year);
    return result;
  }

  @override
  Future<List<LogTable>> getLogsInMonth(int month, int year, int limit) async {
    var result = await expenseDao.getLogsInMonth(month, year, limit);
    return result;
  }

  @override
  Future<int> getMonthExpense(int month, int year) async {
    var result = await expenseDao.getMonthExpense(month, year);
    return result != null ? result.total : 0;
  }

  @override
  Future<void> insertLogs(LogTable data) async {
    await expenseDao.insertLogs(data);
  }

}