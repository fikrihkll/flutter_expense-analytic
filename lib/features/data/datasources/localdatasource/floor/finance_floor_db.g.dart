// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_floor_db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorFinanceFloorDB {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FinanceFloorDBBuilder databaseBuilder(String name) =>
      _$FinanceFloorDBBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FinanceFloorDBBuilder inMemoryDatabaseBuilder() =>
      _$FinanceFloorDBBuilder(null);
}

class _$FinanceFloorDBBuilder {
  _$FinanceFloorDBBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FinanceFloorDBBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FinanceFloorDBBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FinanceFloorDB> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FinanceFloorDB();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FinanceFloorDB extends FinanceFloorDB {
  _$FinanceFloorDB([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExpenseDao? _expenseDaoInstance;

  FundSourceDao? _fundSourceDaoInstance;

  UserDao? _userDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER, `name` TEXT NOT NULL, `username` TEXT NOT NULL, `password` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `expenses` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_id` INTEGER NOT NULL, `fund_source_id` INTEGER NOT NULL, `description` TEXT NOT NULL, `category` TEXT NOT NULL, `nominal` INTEGER NOT NULL, `date` TEXT NOT NULL, `created_at` TEXT NOT NULL, `updated_at` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `fund_sources` (`id` INTEGER, `user_id` INTEGER NOT NULL, `name` TEXT NOT NULL, `daily_fund` INTEGER, `weekly_fund` INTEGER, `monthly_fund` INTEGER, `created_at` TEXT NOT NULL, `updated_at` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ExpensesResultDTO` (`id` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, `fund_source_id` INTEGER NOT NULL, `description` TEXT NOT NULL, `category` TEXT NOT NULL, `nominal` INTEGER NOT NULL, `date` TEXT NOT NULL, `created_at` TEXT NOT NULL, `updated_at` TEXT NOT NULL, `fundsourceName` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FundSourceResultDTO` (`id` INTEGER NOT NULL, `nominal` INTEGER NOT NULL, `name` TEXT NOT NULL, `daily_fund` INTEGER, `weekly_fund` INTEGER, `monthly_fund` INTEGER, `days` INTEGER NOT NULL, `weeks` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }

  @override
  FundSourceDao get fundSourceDao {
    return _fundSourceDaoInstance ??= _$FundSourceDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _expensesDTOInsertionAdapter = InsertionAdapter(
            database,
            'expenses',
            (ExpensesDTO item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.user_id,
                  'fund_source_id': item.fund_source_id,
                  'description': item.description,
                  'category': item.category,
                  'nominal': item.nominal,
                  'date': item.date,
                  'created_at': item.created_at,
                  'updated_at': item.updated_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExpensesDTO> _expensesDTOInsertionAdapter;

  @override
  Future<List<ExpensesResultDTO>> getLatestExpenses() async {
    return _queryAdapter.queryList(
        'SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses INNER JOIN fund_sources ON expenses.fund_source_id = fund_sources.id AND expenses.user_id = 1 ORDER BY expenses.date DESC LIMIT 10',
        mapper: (Map<String, Object?> row) => ExpensesResultDTO(
            id: row['id'] as int,
            user_id: row['user_id'] as int,
            fund_source_id: row['fund_source_id'] as int,
            description: row['description'] as String,
            category: row['category'] as String,
            nominal: row['nominal'] as int,
            date: row['date'] as String,
            created_at: row['created_at'] as String,
            updated_at: row['updated_at'] as String,
            fundsourceName: row['fundsourceName'] as String));
  }

  @override
  Future<List<ExpensesResultDTO>> getExpenses(
      String dateStart, String dateEnd, int limit, int offset) async {
    return _queryAdapter.queryList(
        'SELECT expenses.*, fund_sources.name as fund_source_name FROM expenses INNER JOIN fund_sources ON expenses.fund_source_id = fund_sources.id AND expenses.user_id = 1 AND expenses.date >= ?1 AND expenses.date <= ?2 ORDER BY expenses.date DESC LIMIT ?3 OFFSET ?4',
        mapper: (Map<String, Object?> row) => ExpensesResultDTO(id: row['id'] as int, user_id: row['user_id'] as int, fund_source_id: row['fund_source_id'] as int, description: row['description'] as String, category: row['category'] as String, nominal: row['nominal'] as int, date: row['date'] as String, created_at: row['created_at'] as String, updated_at: row['updated_at'] as String, fundsourceName: row['fundsourceName'] as String),
        arguments: [dateStart, dateEnd, limit, offset]);
  }

  @override
  Future<List<ExpensesDTO>> getExpensesAll() async {
    return _queryAdapter.queryList('SELECT * FROM expenses',
        mapper: (Map<String, Object?> row) => ExpensesDTO(
            id: row['id'] as int?,
            user_id: row['user_id'] as int,
            fund_source_id: row['fund_source_id'] as int,
            description: row['description'] as String,
            category: row['category'] as String,
            nominal: row['nominal'] as int,
            date: row['date'] as String,
            created_at: row['created_at'] as String,
            updated_at: row['updated_at'] as String));
  }

  @override
  Future<void> deleteExpenses(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM expenses WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertExpense(ExpensesDTO expense) async {
    await _expensesDTOInsertionAdapter.insert(
        expense, OnConflictStrategy.ignore);
  }
}

class _$FundSourceDao extends FundSourceDao {
  _$FundSourceDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _fundSourcesDTOInsertionAdapter = InsertionAdapter(
            database,
            'fund_sources',
            (FundSourcesDTO item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.user_id,
                  'name': item.name,
                  'daily_fund': item.daily_fund,
                  'weekly_fund': item.weekly_fund,
                  'monthly_fund': item.monthly_fund,
                  'created_at': item.created_at,
                  'updated_at': item.updated_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FundSourcesDTO> _fundSourcesDTOInsertionAdapter;

  @override
  Future<List<FundSourceResultDTO>> getFundCalculation(
      String dateStart, String dateEnd) async {
    return _queryAdapter.queryList(
        'SELECT fund_sources.id, SUM(expenses.nominal) as nominal, fund_sources.name, (fund_sources.daily_fund * DATEDIFF(?1, ?2)) as daily_fund, (fund_sources.weekly_fund * CAST((DATEDIFF(?1, ?2)/7) as INT)) as weekly_fund, fund_sources.monthly_fund, DATEDIFF(?1, ?2) as days, CAST((DATEDIFF(?1, ?2)/7) as INT) as weeks FROM expenses INNER JOIN fund_sources ON expenses.fund_source_id = fund_sources.id AND expenses.user_id = 1 AND expenses.date >= ?1 AND expenses.date <= ?2 GROUP BY fund_sources.id',
        mapper: (Map<String, Object?> row) => FundSourceResultDTO(id: row['id'] as int, nominal: row['nominal'] as int, name: row['name'] as String, daily_fund: row['daily_fund'] as int?, weekly_fund: row['weekly_fund'] as int?, monthly_fund: row['monthly_fund'] as int?, days: row['days'] as int, weeks: row['weeks'] as int),
        arguments: [dateStart, dateEnd]);
  }

  @override
  Future<List<FundSourcesDTO>> getFundSources() async {
    return _queryAdapter.queryList('SELECT * FROM fund_sources',
        mapper: (Map<String, Object?> row) => FundSourcesDTO(
            id: row['id'] as int?,
            user_id: row['user_id'] as int,
            name: row['name'] as String,
            daily_fund: row['daily_fund'] as int?,
            weekly_fund: row['weekly_fund'] as int?,
            monthly_fund: row['monthly_fund'] as int?,
            created_at: row['created_at'] as String,
            updated_at: row['updated_at'] as String));
  }

  @override
  Future<void> insertFundSource(FundSourcesDTO fundSource) async {
    await _fundSourcesDTOInsertionAdapter.insert(
        fundSource, OnConflictStrategy.abort);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _usersDTOInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UsersDTO item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'username': item.username,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UsersDTO> _usersDTOInsertionAdapter;

  @override
  Future<List<UsersDTO>> getUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => UsersDTO(
            id: row['id'] as int?,
            name: row['name'] as String,
            username: row['username'] as String,
            password: row['password'] as String));
  }

  @override
  Future<void> insertUsers(UsersDTO user) async {
    await _usersDTOInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }
}
