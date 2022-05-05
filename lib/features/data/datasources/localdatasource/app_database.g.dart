// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExpenseDao? _expenseDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `LogTable` (`id` INTEGER NOT NULL, `category` TEXT NOT NULL, `desc` TEXT NOT NULL, `date` TEXT NOT NULL, `month` INTEGER NOT NULL, `year` INTEGER NOT NULL, `nominal` INTEGER NOT NULL, `userId` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserTable` (`id` INTEGER NOT NULL, `username` TEXT NOT NULL, `pass` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _logTableInsertionAdapter = InsertionAdapter(
            database,
            'LogTable',
            (LogTable item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'desc': item.desc,
                  'date': item.date,
                  'month': item.month,
                  'year': item.year,
                  'nominal': item.nominal,
                  'userId': item.userId
                }),
        _userTableInsertionAdapter = InsertionAdapter(
            database,
            'UserTable',
            (UserTable item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'pass': item.pass,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LogTable> _logTableInsertionAdapter;

  final InsertionAdapter<UserTable> _userTableInsertionAdapter;

  @override
  Future<List<LogTable>> getLatestLogs() async {
    return _queryAdapter.queryList(
        'SELECT*FROM logs_table ORDER BY date DESC LIMIT 10',
        mapper: (Map<String, Object?> row) => LogTable(
            id: row['id'] as int,
            category: row['category'] as String,
            desc: row['desc'] as String,
            date: row['date'] as String,
            month: row['month'] as int,
            year: row['year'] as int,
            nominal: row['nominal'] as int,
            userId: row['userId'] as int));
  }

  @override
  Future<MonthExpenseResult?> getMonthExpense(int month, int year) async {
    await _queryAdapter.queryNoReturn(
        'SELECT SUM(nominal) as total FROM logs_table WHERE month = ?1 AND year = ?2',
        arguments: [month, year]);
  }

  @override
  Future<List<LogTable>> getLogsInMonth(int month, int year, int limit) async {
    return _queryAdapter.queryList(
        'SELECT*FROM logs_table WHERE month = ?1 AND year = ?2 ORDER BY date DESC LIMIT 10 OFFSET ?3',
        mapper: (Map<String, Object?> row) => LogTable(id: row['id'] as int, category: row['category'] as String, desc: row['desc'] as String, date: row['date'] as String, month: row['month'] as int, year: row['year'] as int, nominal: row['nominal'] as int, userId: row['userId'] as int),
        arguments: [month, year, limit]);
  }

  @override
  Future<void> deleteLog(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM logs_table WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<List<LogDetailResult>> getLogsDetailInMonth(
      int month, int year) async {
    await _queryAdapter.queryNoReturn(
        'SELECT category, SUM(nominal) as total FROM logs_table WHERE month = ?1 AND year = ?2 GROUP BY category',
        arguments: [month, year]);
  }

  @override
  Future<void> insertLogs(LogTable data) async {
    await _logTableInsertionAdapter.insert(data, OnConflictStrategy.abort);
  }

  @override
  Future<void> createUser(UserTable data) async {
    await _userTableInsertionAdapter.insert(data, OnConflictStrategy.abort);
  }
}
