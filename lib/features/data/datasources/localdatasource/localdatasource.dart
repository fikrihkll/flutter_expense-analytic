import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';

abstract class LocalDataSource{

  Future<void> insertDummyUser();

  Future<void> insertExpense(Map<String, dynamic> log);

  Future<void> updateExpense(Map<String, dynamic> log);

  Future<void> updateFundSource(Map<String, dynamic> fundSource);

  Future<void> insertFundSource(Map<String, dynamic> fundSource);

  Future<int> getTodayExpense(String date);

  Future<double> getTodayLimit(bool isWeekend);

  Future<List<Map<String, dynamic>>> getRecentLogs();

  Future<List<Map<String, dynamic>>> getLogsInMonth(String fromDate, String untilDate, int limit, int page);

  Future<List<Map<String, dynamic>>> getFundSources();

  Future<List<Map<String, dynamic>>> getTotalBasedOnCategory(String fromDate, String untilDate);

  Future<List<Map<String, dynamic>>> getDetailExpenseIntMonth(String fromDate, String untilDate);

  Future<int> getExpenseInMonth(String fromDate, String untilDate);

  Future<void> deleteLog(int id);

  Future<int> getTotalFunds(String fromDate, String untilDate);

}

class LocalDataSourceImpl extends LocalDataSource{

  final DatabaseHandler databaseHandler;

  LocalDataSourceImpl({required this.databaseHandler});

  @override
  Future<void> deleteLog(int id) async {
    await databaseHandler.deleteExpense(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getDetailExpenseIntMonth(String fromDate, String untilDate) async {
    return await databaseHandler.getDetailExpenseInMonth(fromDate, untilDate);
  }

  @override
  Future<List<Map<String, dynamic>>> getFundSources() async {
    return await databaseHandler.getFundSources();
  }

  @override
  Future<List<Map<String, dynamic>>> getLogsInMonth(String fromDate, String untilDate, int limit, int page) async {
    return await databaseHandler.getLogsInMonth(fromDate, untilDate, limit, page);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentLogs() async {
    return await databaseHandler.getRecentLogs();
  }

  @override
  Future<int> getTodayExpense(String date) async {
    return (await databaseHandler.getTodayExpense(date)) ?? 0;
  }

  @override
  Future<double> getTodayLimit(bool isWeekend) async {
    return (await databaseHandler.getTodayLimit(isWeekend)) ?? 0.0;
  }

  @override
  Future<List<Map<String, dynamic>>> getTotalBasedOnCategory(String fromDate, String untilDate) async {
    return await databaseHandler.getTotalBasedOnCategory(fromDate, untilDate);
  }

  @override
  Future<void> insertDummyUser() async {
    await await databaseHandler.insertUser();
  }

  @override
  Future<void> insertExpense(Map<String, dynamic> log) async {
    await databaseHandler.insertExpense(log);
  }

  @override
  Future<void> insertFundSource(Map<String, dynamic> fundSource) async {
    await databaseHandler.insertFundSource(fundSource);
  }

  @override
  Future<void> updateExpense(Map<String, dynamic> log) async {
    await databaseHandler.updateExpense(log);
  }

  @override
  Future<void> updateFundSource(Map<String, dynamic> fundSource) async {
    await databaseHandler.updateFundSource(fundSource);
  }

  @override
  Future<int> getExpenseInMonth(String fromDate, String untilDate) async {
    return (await databaseHandler.getMonthlyExpense(fromDate, untilDate)) ?? 0;
  }

  @override
  Future<int> getTotalFunds(String fromDate, String untilDate) async {
    var listFunds = await databaseHandler.getTotalFunds(fromDate, untilDate);
    int totalFunds = 0;
    listFunds.forEach((element) {
      if (element['total_funds'] != null) {
        totalFunds += (element['total_funds'] as double).toInt();
      }
    });
    return totalFunds;
  }

}