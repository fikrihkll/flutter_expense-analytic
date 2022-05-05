import 'package:expense_app/features/data/datasources/localdatasource/app_database.dart';
import 'package:expense_app/features/data/datasources/localdatasource/localdatasource.dart';
import 'package:expense_app/features/data/repositories/expense_repository_impl.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  // sl.registerFactory(
  //       () => HomeProfileBloc(getProfileData:  sl()),
  // );

  //usecase
  // sl.registerFactory(() => GetProfileData(repo: sl()));

  //repo
  sl.registerLazySingleton<ExpenseRepository>(
          () => ExpenseRepositoryImpl(localDataSource: sl()));

  //Data sources
  sl.registerLazySingleton<LocalDataSource>(
          () => LocalDataSourceImpl(
          expenseDao: sl()
      ));

  //External
  var localDb = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerLazySingleton(() async => localDb.expenseDao);
}