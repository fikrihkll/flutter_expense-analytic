import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/repositories/expense_repository_impl.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';
import 'package:expense_app/features/domain/usecases/delete_log_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_expense_in_month_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_logs_in_month_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_recent_logs_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_log_usecase.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/all_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/selected_date_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/insert_log_presenter.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/recent_logs_bloc.dart';
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

  // Usecase
  sl.registerFactory(() => GetRecentLogsUseCase(repo: sl()));
  sl.registerFactory(() => InsertLogUseCase(repo: sl()));
  sl.registerFactory(() => GetExpenseInMonthUseCase(repo: sl()));
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