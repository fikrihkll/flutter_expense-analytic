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

}