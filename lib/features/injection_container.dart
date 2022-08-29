import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/expense_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/finance_floor_db.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/fund_source_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/floor/user_dao.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/repositories/expense_repository_impl.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';
import 'package:expense_app/features/domain/usecases/delete_log_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_expense_in_month_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_expense_limit_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_fund_sources_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_logs_in_month_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_recent_logs_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_today_balance_left_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_expense_limit_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_log_usecase.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/all_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/selected_date_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/insert_log_presenter.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/recent_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/input_expense_limit/insert_expense_limit_presenter.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
        () => RecentLogsBloc(getRecentLogsUseCase:  sl(), deleteLogUseCase: sl()),
  );
  sl.registerFactory(
        () => InsertLogPresenter(insertLogUseCase:  sl()),
  );
  sl.registerFactory(
        () => ExpenseMonthBloc(getExpenseInMonthUseCase: sl()),
  );
  sl.registerFactory(
        () => AllLogsBloc(getLogsInMonthUseCase: sl(), deleteLogUseCase: sl()),
  );
  sl.registerFactory(
        () => SelectedDateBloc(),
  );
  sl.registerFactory(
        () => BalanceLeftBloc(getTodayBalanceLeftUseCase: sl()),
  );
  sl.registerFactory(
        () => InsertExpenseLimitPresenter(insertExpenseLimitUseCase: sl(), getExpenseLimitUseCase: sl()),
  );
  sl.registerFactory(
        () => FundSourceBloc(getFundSourcesUseCase: sl()),
  );

  // Usecase
  sl.registerFactory(() => GetExpenseLimitUseCase(repo: sl()));
  sl.registerFactory(() => InsertExpenseLimitUseCase(repo: sl()));
  sl.registerFactory(() => GetTodayBalanceLeftUseCase(repo: sl()));
  sl.registerFactory(() => GetRecentLogsUseCase(repo: sl()));
  sl.registerFactory(() => InsertLogUseCase(repo: sl()));
  sl.registerFactory(() => GetExpenseInMonthUseCase(repo: sl()));
  sl.registerFactory(() => GetLogsInMonthUseCase(repo: sl()));
  sl.registerFactory(() => DeleteLogUseCase(repo: sl()));
  sl.registerFactory(() => GetFundSourcesUseCase(repo: sl()));

  // Data sources
  FinanceFloorDB db = await $FloorFinanceFloorDB.databaseBuilder("finance_db5.db").build();
  ExpenseDao expenseDao = await db.expenseDao;
  UserDao userDao = await db.userDao;
  FundSourceDao fundDao = await db.fundSourceDao;
  sl.registerLazySingleton<FinanceFloorDB>(
          () => db);
  sl.registerLazySingleton<ExpenseDao>(
          () => expenseDao);
  sl.registerLazySingleton<FundSourceDao>(
          () => fundDao);
  sl.registerLazySingleton<UserDao>(
          () => userDao);

  // Repo
  sl.registerLazySingleton<ExpenseRepository>(
          () => ExpenseRepositoryImpl(expenseDao: sl(), fundDao: sl()));

  // sl.registerLazySingleton<LocalDataSource>(
  //         () => LocalDataSourceImpl(
  //         databaseHandler: sl()
  //     ));

  // External
  sl.registerLazySingleton<DatabaseHandler>(() => DatabaseHandler());
}