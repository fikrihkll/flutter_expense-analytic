import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/usecases/insert_log_usecase.dart';

class InsertLogPresenter {

  final InsertLogUseCase insertLogUseCase;


  InsertLogPresenter({required this.insertLogUseCase});

  Future<void> insertLogEvent(Log data) async {
    await insertLogUseCase.call(InsertLogUseCaseParams(data: data));
  }
}
