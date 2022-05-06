import 'package:dartz/dartz.dart';
import 'package:expense_app/core/error/failure.dart';


abstract class UseCase<Type,Params>{
  Future<Either<Failure,Type>> call(Params params);
}
class NoParams {
}