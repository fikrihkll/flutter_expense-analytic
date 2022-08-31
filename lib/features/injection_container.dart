import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/repositories/expense_repository_impl.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';
import 'package:expense_app/features/domain/usecases/delete_log_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_detail_fund_used_int_monh_use_case.dart';
import 'package:expense_app/features/domain/usecases/get_expense_in_month_use_case.dart';
import 'package:expense_app/features/domain/usecases/get_fund_sources_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_logs_in_month_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_recent_logs_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_today_balance_left_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_fund_source_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_log_usecase.dart';
import 'package:expense_app/features/domain/usecases/update_fund_source_usecase.dart';
import 'package:expense_app/features/presentation/bloc/balance_left/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/bloc/logs/logs_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
        () => LogsBloc(getRecentLogsUseCase:  sl(), deleteLogUseCase: sl(), insertLogUseCase: sl()),
  );
  sl.registerFactory(
        () => BalanceLeftBloc(
            getTodayBalanceLeftUseCase: sl(),
            getExpenseInMonthUseCase: sl()
        ),
  );
  sl.registerFactory(
        () => FundSourceBloc(
            insertFundSourceUseCase: sl(),
            updateFundSourceUseCase: sl(),
            getFundSourcesUseCase: sl(),
          getDetailFundUsedInMonthUseCase: sl()
        )
  );

  // Usecase
  sl.registerFactory(() => GetDetailFundUsedInMonthUseCase(repository: sl()));
  sl.registerFactory(() => GetExpenseInMonthUseCase(repository: sl()));
  sl.registerFactory(() => UpdateFundSourceUseCase(repo: sl()));
  sl.registerFactory(() => GetFundSourcesUseCase(repo: sl()));
  sl.registerFactory(() => InsertFundSourceUseCase(repo: sl()));
  sl.registerFactory(() => GetTodayBalanceLeftUseCase(repo: sl()));
  sl.registerFactory(() => GetRecentLogsUseCase(repo: sl()));
  sl.registerFactory(() => InsertLogUseCase(repo: sl()));
  // sl.registerFactory(() => GetExpenseInMonthUseCase(repo: sl()));
  sl.registerFactory(() => GetLogsInMonthUseCase(repo: sl()));
  sl.registerFactory(() => DeleteLogUseCase(repo: sl()));

  // Repo
  sl.registerLazySingleton<ExpenseRepository>(
          () => ExpenseRepositoryImpl(localDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
          () => LocalDataSourceImpl(
          databaseHandler: sl()
      ));

  // External
  sl.registerLazySingleton<DatabaseHandler>(() => DatabaseHandler());
}