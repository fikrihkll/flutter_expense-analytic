import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/data/datasources/localdatasource/query_handler.dart';
import 'package:sqflite/sqflite.dart';

class MigrationHandler {

  /// Place the migration entity from the smallest old version until the highest old version
  static List<Migration> migrations = [
    Migration(
        oldVersion: 4,
        newVersion: 5,
        sql: [
          "ALTER TABLE ${DatabaseHandler.tableFundSources} ADD COLUMN deleted_at TIMESTAMP NULL"
        ]
    ),
    Migration(
        oldVersion: 5,
        newVersion: 6,
        sql: [
          QueryHandler.createTableBudgets(),
          QueryHandler.createTableBudgetUsers(),
          "ALTER TABLE ${DatabaseHandler.tableUsers} ADD COLUMN image TEXT NULL",
          "ALTER TABLE ${DatabaseHandler.tableUsers} ADD COLUMN email TEXT NULL",
          "ALTER TABLE ${DatabaseHandler.tableFundSources} ADD COLUMN budget_id INTEGER NOT NULL DEFAULT 1",
          "ALTER TABLE ${DatabaseHandler.tableExpenses} ADD COLUMN budget_id INTEGER NOT NULL DEFAULT 1",
          QueryHandler.createTableNewExpenses(),
          QueryHandler.createTableNewFundSources(),
          QueryHandler.moveDataExpensesToNewExpenses(),
          QueryHandler.moveDataFundToNewFund(),
          QueryHandler.dropTableExpense(),
          QueryHandler.dropTableFundSource(),
          QueryHandler.renameExpenseNewToExpense(),
          QueryHandler.renameFundSourceNewToFundSource(),
        ]
    )
  ];

  static Function(Database database, int oldVersion, int newVersion) onUpgrade = (database, oldVersion, newVersion) async {
    for (var value in migrations) {
      if (oldVersion < value.newVersion) {
        for (var sql in value.sql) {
          await database.execute(sql);
        }
      }
    }
  };

}

class Migration {

  final int oldVersion, newVersion;
  final List<String> sql;

  Migration({required this.oldVersion, required this.newVersion, required this.sql});

}