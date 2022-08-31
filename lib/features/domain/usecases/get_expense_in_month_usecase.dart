import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/repositories/expense_repository.dart';

// class GetExpenseInMonthUseCase extends UseCase<int, GetExpenseInMonthUseCaseParams>{
//
//   final ExpenseRepository repo;
//
//   GetExpenseInMonthUseCase({required this.repo});
//
//   @override
//   Future<Either<Failure, int>> call(GetExpenseInMonthUseCaseParams params) async {
//     return await repo.getExpenseInMonth(params.month, params.year);
//   }
//
// }
//
// class GetExpenseInMonthUseCaseParams {
//
//   final int month;
//   final int year;
//
//   GetExpenseInMonthUseCaseParams({
//     required this.month,
//     required this.year
//   });
//
//
// }