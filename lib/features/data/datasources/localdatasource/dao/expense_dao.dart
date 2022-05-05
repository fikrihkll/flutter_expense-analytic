import 'package:expense_app/features/data/datasources/localdatasource/query_result/log_detail_result.dart';
import 'package:expense_app/features/data/datasources/localdatasource/query_result/month_expense_result.dart';
import 'package:expense_app/features/data/datasources/localdatasource/tables/log_table.dart';
import 'package:expense_app/features/data/datasources/localdatasource/tables/user_table.dart';
import 'package:floor/floor.dart';

@dao
abstract class ExpenseDao {

  @insert
  Future<void> insertLogs(LogTable data);

  @insert
  Future<void> createUser(UserTable data);

  @Query('SELECT*FROM logs_table ORDER BY date DESC LIMIT 10')
  Future<List<LogTable>> getLatestLogs();

  @Query('SELECT SUM(nominal) as total FROM logs_table WHERE month = :month AND year = :year')
  Future<MonthExpenseResult?> getMonthExpense(int month, int year);

  @Query('SELECT*FROM logs_table WHERE month = :month AND year = :year ORDER BY date DESC LIMIT 10 OFFSET :limit')
  Future<List<LogTable>> getLogsInMonth(int month, int year, int limit);

  @Query('DELETE FROM logs_table WHERE id = :id')
  Future<void> deleteLog(int id);

  @Query('SELECT category, SUM(nominal) as total FROM logs_table WHERE month = :month AND year = :year GROUP BY category')
  Future<List<LogDetailResult>> getLogsDetailInMonth(int month, int year);

}