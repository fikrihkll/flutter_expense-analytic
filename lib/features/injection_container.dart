import 'package:expense_app/features/data/datasources/localdatasource/app_database.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/repositories/expense_repository_impl.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';
import 'package:expense_app/features/domain/usecases/get_recent_logs_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_log_usecase.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/insert_log_presenter.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/recent_logs_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
        () => RecentLogsBloc(getRecentLogsUseCase:  sl()),
  );
  sl.registerFactory(
        () => InsertLogPresenter(insertLogUseCase:  sl()),
  );

  // Usecase
  sl.registerFactory(() => GetRecentLogsUseCase(repo: sl()));
  sl.registerFactory(() => InsertLogUseCase(repo: sl()));

  // Repo
  sl.registerLazySingleton<ExpenseRepository>(
          () => ExpenseRepositoryImpl(localDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
          () => LocalDataSourceImpl(
          expenseDao: sl()
      ));

  // External
  var localDb = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerLazySingleton(() async => localDb.expenseDao);
}