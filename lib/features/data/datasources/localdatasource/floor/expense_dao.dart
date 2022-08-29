import 'package:expense_app/features/data/models/floor/expenses_dto.dart';
import 'package:expense_app/features/data/models/floor/results/expenses_result_dto.dart';
import 'package:floor/floor.dart';

@dao
abstract class ExpenseDao {

  @Query("SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses INNER JOIN fund_sources ON expenses.fund_source_id = fund_sources.id AND expenses.user_id = 1 ORDER BY expenses.date DESC LIMIT 10")
  Future<List<ExpensesResultDTO>> getLatestExpenses();

  @Query("SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses INNER JOIN fund_sources ON expenses.fund_source_id = fund_sources.id AND expenses.user_id = 1 AND expenses.date >= :dateStart AND expenses.date <= :dateEnd ORDER BY expenses.date DESC LIMIT :limit OFFSET :offset")
  Future<List<ExpensesResultDTO>> getExpenses(String dateStart, String dateEnd, int limit, int offset);

  @Query("SELECT * FROM expenses")
  Future<List<ExpensesDTO>> getExpensesAll();

  @Query("DELETE FROM expenses WHERE id = :id")
  Future<void> deleteExpenses(int id);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertExpense(ExpensesDTO expense);
}