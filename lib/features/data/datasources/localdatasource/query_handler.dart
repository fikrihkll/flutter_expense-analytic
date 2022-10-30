import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';

class QueryHandler {

  static String getTodayExpense(String date, bool isWeekend) {
    String query;
    if (isWeekend) {
      query = 'SELECT SUM(nominal) as nominal FROM expenses WHERE DATE(date) = DATE("$date") AND fund_source_id IN (SELECT id FROM fund_sources WHERE daily_fund NOT NULL OR weekly_fund NOT NULL)';
    } else {
      query = 'SELECT SUM(nominal) as nominal FROM expenses WHERE DATE(date) = DATE("$date") AND fund_source_id IN (SELECT id FROM fund_sources WHERE daily_fund NOT NULL)';
    }
    return query;
  }

  static String getMonthlyExpense(String startDate, String endDate) {
    String query = 'SELECT SUM(nominal) as nominal FROM ${DatabaseHandler.tableExpenses} WHERE DATE(date) BETWEEN DATE("$startDate") AND DATE("$endDate")';
    return query;
  }

  static String getDailyFundLimit() {
    String query = "SELECT CAST(SUM(daily_fund) as DOUBLE) as daily_fund FROM ${DatabaseHandler.tableFundSources} WHERE daily_fund NOT NULL AND deleted_at NOT NULL";
    return query;
  }

  static String getWeekendFundLimit() {
    String query = "SELECT CAST(SUM(weekly_fund) as DOUBLE) as weekly_fund FROM ${DatabaseHandler.tableFundSources} WHERE weekly_fund NOT NULL AND deleted_at NOT NULL";
    return query;
  }

  static String getRecentLogs() {
    String query = 'SELECT * FROM ${DatabaseHandler.tableExpenses} ORDER BY date DESC LIMIT 10';
    return query;
  }

  static String getLogsInMonth(String fromDate, String untilDate, int limit, int page, int offset, {int fundIdFilter = -1, String categoryFilter = ""}) {
    String query = "SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses LEFT JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE DATE(expenses.date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') ORDER BY expenses.date DESC LIMIT $limit OFFSET $offset";
    if (fundIdFilter != -1 && categoryFilter.isEmpty) {
      query = "SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses LEFT JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE DATE(expenses.date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') AND fund_source_id = $fundIdFilter ORDER BY expenses.date DESC LIMIT $limit OFFSET $offset";
    } else if (fundIdFilter == -1 && categoryFilter.isNotEmpty) {
      query = "SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses LEFT JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE DATE(expenses.date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') AND category = $categoryFilter ORDER BY expenses.date DESC LIMIT $limit OFFSET $offset";
    } else if (fundIdFilter != -1 && categoryFilter.isNotEmpty) {
      query = "SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses LEFT JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE DATE(expenses.date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') AND fund_source_id = $fundIdFilter AND category = $categoryFilter ORDER BY expenses.date DESC LIMIT $limit OFFSET $offset";
    }
    return query;
  }

  static String getFundSources() {
    String query = "SELECT * FROM ${DatabaseHandler.tableFundSources} WHERE deleted_at IS NULL ORDER BY daily_fund DESC, weekly_fund DESC, monthly_fund DESC";
    return query;
  }

  static String getTotalBasedOnCategory(String fromDate, String untilDate,) {
    String query = "SELECT category, SUM(nominal) as nominal FROM expenses WHERE DATE(date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') GROUP BY category";
    return query;
  }

  static String getDetailExpenseInMonth(String fromDate, String untilDate) {
    String query = "SELECT fund_sources.id, SUM(expenses.nominal) as nominal,  fund_sources.daily_fund, fund_sources.weekly_fund, fund_sources.monthly_fund, fund_sources.name, (fund_sources.daily_fund * (julianday('$untilDate')- julianday('$fromDate')+1)) as daily_fund_total, (fund_sources.weekly_fund * CAST(((julianday('$untilDate')- julianday('$fromDate')+1)/7) as INT)) as weekly_fund_total, (fund_sources.monthly_fund *  CAST(((julianday('$untilDate')- julianday('$fromDate')+1)/28) as INT)) as monthly_fund_total, (julianday('$untilDate')- julianday('$fromDate')+1) as days, CAST(((julianday('$untilDate')- julianday('$fromDate')+1)/7) as INT) as weeks, (CAST(((julianday('$untilDate')- julianday('$fromDate')+1)/28) as INT)) as months FROM expenses INNER JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE expenses.user_id = 1 AND (DATE(expenses.date) BETWEEN DATE('$fromDate') AND ('$untilDate')) GROUP BY fund_sources.id";
    return query;
  }

  static String getTotalFunds(String fromDate, String untilDate) {
    String query = "SELECT (COALESCE(total_table.daily_fund_total, 0) + COALESCE(total_table.weekly_fund_total, 0) + COALESCE(total_table.monthly_fund_total, 0)) as total_funds, total_table.days, total_table.weeks, total_table.months FROM (SELECT (fund_sources.daily_fund * (julianday('$untilDate')- julianday('$fromDate')+1)) as daily_fund_total, (fund_sources.weekly_fund * CAST(((julianday('$untilDate')- julianday('$fromDate')+1)/7) as INT)) as weekly_fund_total,  (fund_sources.monthly_fund *  CAST(((julianday('$untilDate')- julianday('$fromDate')+1)/28) as INT)) as monthly_fund_total, (julianday('$untilDate')- julianday('$fromDate')+1) as days, CAST(((julianday('$untilDate')- julianday('$fromDate')+1)/7) as INT) as weeks, (CAST(((julianday('$untilDate')- julianday('$fromDate')+1)/28) as INT)) as months FROM expenses INNER JOIN fund_sources ON expenses.fund_source_id = fund_sources.id AND expenses.user_id = 1 AND (DATE(expenses.date) BETWEEN DATE('$fromDate') AND ('$untilDate')) GROUP BY fund_sources.id) as total_table";
    return query;
  }

  static String getCategoryListFromExistingFund(int fundId, String fromDate, String untilDate) {
    String query = "SELECT category FROM ${DatabaseHandler.tableExpenses} WHERE fund_source_id = $fundId AND DATE(date) BETWEEN DATE('$fromDate') AND DATE('$untilDate')";
    return query;
  }

}