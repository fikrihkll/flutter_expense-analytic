import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';

class QueryHandler {

  static String createTableUsers() {
    return """
    CREATE TABLE ${DatabaseHandler.tableUsers}(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      username TEXT NOT NULL, 
      pass TEXT NOT NULL, 
      name TEXT NOT NULL,
      created_at TIMESTAMP NOT NULL,
      updated_at TIMESTAMP NOT NULL
    );
    """;
  }

  static String createTableExpenses() {
    return """
    CREATE TABLE ${DatabaseHandler.tableExpenses}(
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
    """;
  }

  static String createTableNewExpenses() {
    return """
    CREATE TABLE ${DatabaseHandler.tableExpenses}_new(
      id TEXT PRIMARY KEY NOT NULL,
      user_id TEXT NOT NULL,
      fund_source_id TEXT NULL, 
      description TEXT NOT NULL, 
      category TEXT NOT NULL,
      nominal DOUBLE NOT NULL,
      date DATETIME NOT NULL,
      day INTEGER NOT NULL,
      month INTEGER NOT NULL,
      year INTEGER NOT NULL,
      budget_id TEXT,
      created_at TIMESTAMP NOT NULL,
      updated_at TIMESTAMP NOT NULL
    );
    """;
  }

  static String createTableFundSources() {
    return """
    CREATE TABLE ${DatabaseHandler.tableFundSources}(
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
    """;
  }

  static String createTableNewFundSources() {
    return """
    CREATE TABLE ${DatabaseHandler.tableFundSources}_new(
      id TEXT PRIMARY KEY NOT NULL, 
      user_id TEXT NOT NULL, 
      name TEXT NOT NULL, 
      daily_fund DOUBLE NULL,
      weekly_fund DOUBLE NULL,
      monthly_fund DOUBLE NULL,
      budget_id TEXT,
      created_at TIMESTAMP NOT NULL,
      updated_at TIMESTAMP NOT NULL,
      deleted_at TIMESTAMP NULL
    );
    """;
  }

  static String createTableBudgets() {
    return """
    CREATE TABLE ${DatabaseHandler.tableBudgets} (
      id TEXT PRIMARY KEY NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      currency TEXT,
      owner_user_id TEXT NOT NULL,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    """;
  }

  static String createTableBudgetUsers() {
    return """
    CREATE TABLE ${DatabaseHandler.tableBudgetUsers} (
      user_id TEXT NOT NULL,
      name TEXT NOT NULL,
      username TEXT NOT NULL,
      budget_id TEXT NOT NULL,
      image TEXT NULL,
      added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY(user_id, budget_id)
    );
    """;
  }

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

  static String getLogsInMonth(String fromDate, String untilDate, int limit, int page, int offset, {String fundIdFilter = "", String categoryFilter = ""}) {
    String query = "SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses LEFT JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE DATE(expenses.date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') ORDER BY expenses.date DESC LIMIT $limit OFFSET $offset";
    if (fundIdFilter.isNotEmpty && categoryFilter.isEmpty) {
      query = "SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses LEFT JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE DATE(expenses.date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') AND fund_source_id = '$fundIdFilter' ORDER BY expenses.date DESC LIMIT $limit OFFSET $offset";
    } else if (fundIdFilter.isEmpty && categoryFilter.isNotEmpty) {
      query = "SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses LEFT JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE DATE(expenses.date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') AND category = $categoryFilter ORDER BY expenses.date DESC LIMIT $limit OFFSET $offset";
    } else if (fundIdFilter.isNotEmpty && categoryFilter.isNotEmpty) {
      query = "SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses LEFT JOIN fund_sources ON expenses.fund_source_id = fund_sources.id WHERE DATE(expenses.date) BETWEEN DATE('$fromDate') AND DATE('$untilDate') AND fund_source_id = '$fundIdFilter' AND category = $categoryFilter ORDER BY expenses.date DESC LIMIT $limit OFFSET $offset";
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

  static String moveDataExpensesToNewExpenses() {
    return """
    INSERT INTO ${DatabaseHandler.tableExpenses}_new (id, user_id, fund_source_id, description, category, nominal, date, day, month, year, created_at, updated_at, budget_id)
SELECT id, user_id, fund_source_id, description, category, nominal, date, day, month, year, created_at, updated_at, budget_id
FROM ${DatabaseHandler.tableExpenses};
    """;
  }

  static String moveDataFundToNewFund() {
    return """
    INSERT INTO ${DatabaseHandler.tableFundSources}_new (id, user_id, name, daily_fund, weekly_fund, monthly_fund, created_at, updated_at, deleted_at, budget_id)
SELECT id, user_id, name, daily_fund, weekly_fund, monthly_fund, created_at, updated_at, deleted_at, budget_id
FROM ${DatabaseHandler.tableFundSources};
    """;
  }

  static String dropTableExpense() {
    return "DROP TABLE ${DatabaseHandler.tableExpenses}";
  }

  static String dropTableFundSource() {
    return "DROP TABLE ${DatabaseHandler.tableFundSources}";
  }

  static String renameExpenseNewToExpense() {
    return "ALTER TABLE ${DatabaseHandler.tableExpenses}_new RENAME TO ${DatabaseHandler.tableExpenses}";
  }

  static String renameFundSourceNewToFundSource() {
    return "ALTER TABLE ${DatabaseHandler.tableFundSources}_new RENAME TO ${DatabaseHandler.tableFundSources}";
  }

}