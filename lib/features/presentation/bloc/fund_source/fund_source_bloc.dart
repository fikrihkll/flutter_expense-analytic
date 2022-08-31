import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/entities/fund_detail.dart';
import 'package:expense_app/features/domain/usecases/get_detail_fund_used_int_monh_use_case.dart';
import 'package:expense_app/features/domain/usecases/get_fund_sources_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_fund_source_usecase.dart';
import 'package:expense_app/features/domain/usecases/update_fund_source_usecase.dart';
import 'package:meta/meta.dart';

part 'fund_source_event.dart';
part 'fund_source_state.dart';

class FundSourceBloc extends Bloc<FundSourceEvent, FundSourceState> {

  final GetFundSourcesUseCase getFundSourcesUseCase;
  final UpdateFundSourceUseCase updateFundSourceUseCase;
  final InsertFundSourceUseCase insertFundSourceUseCase;
  final GetDetailFundUsedInMonthUseCase getDetailFundUsedInMonthUseCase;

  FundSourceBloc({
    required this.getFundSourcesUseCase,
    required this.updateFundSourceUseCase,
    required this.insertFundSourceUseCase,
    required this.getDetailFundUsedInMonthUseCase
  }) : super(FundSourceInitial()) {
    on<GetFundSourceEvent>((event, emit) async {
      emit(GetFundSourceLoading());

      var result = await getFundSourcesUseCase.call(NoParams());

      emit(
        result.fold(
                (left) => GetFundSourceError(message: left is ServerFailure ? left.msg : unexpectedFailureMessage),
                (right) => GetFundSourceLoaded(data: right)
        )
      );
    });
    on<InsertFundSourceEvent>((event, emit) async {
      emit(InsertFundSourceLoading());

      var result = await insertFundSourceUseCase.call(InsertFundSourceUseCaseParams(data: event.fundSourceModel));

      emit(
          result.fold(
                  (left) => InsertFundSourceResult(isSuccess: false),
                  (right) => InsertFundSourceResult(isSuccess: true)
          )
      );
    });
    on<DeleteFundSourceEvent>((event, emit) async {
      emit(UpdateFundSourceLoading());

      var result = await getFundSourcesUseCase.call(NoParams());

      emit(
          result.fold(
                  (left) => UpdateFundSourceResult(isSuccess: false),
                  (right) => UpdateFundSourceResult(isSuccess: true)
          )
      );
    });

    on<GetFundUsedDetailEvent>((event, emit) async {
      emit(GetFundUsedDetailLoading());

      var result = await getDetailFundUsedInMonthUseCase.call(
        GetDetailFundUsedInMonthUseCaseParams(
            fromDate: event.fromDate,
            untilDate: event.untilDate
        )
      );

      emit(
          result.fold(
                  (left) => GetFundUsedDetailError(message: left is ServerFailure ? left.msg : unexpectedFailureMessage),
                  (right) => GetFundUsedDetailLoaded(listData: right)
          )
      );
    });
  }
}
