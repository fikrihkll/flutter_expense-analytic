import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/entities/fund_detail.dart';
import 'package:expense_app/features/domain/usecases/delete_fund_source_usecase.dart';
import 'package:expense_app/features/domain/usecases/get_detail_fund_used_int_monh_use_case.dart';
import 'package:expense_app/features/domain/usecases/get_fund_sources_usecase.dart';
import 'package:expense_app/features/domain/usecases/insert_fund_source_usecase.dart';
import 'package:expense_app/features/domain/usecases/update_fund_source_usecase.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'fund_source_event.dart';
part 'fund_source_state.dart';

class FundSourceBloc extends Bloc<FundSourceEvent, FundSourceState> {

  final GetFundSourcesUseCase getFundSourcesUseCase;
  final UpdateFundSourceUseCase updateFundSourceUseCase;
  final InsertFundSourceUseCase insertFundSourceUseCase;
  final GetDetailFundUsedInMonthUseCase getDetailFundUsedInMonthUseCase;
  final DeleteFundSourceUseCase deleteFundSourceUseCase;

  final List<FundSource> _listFund = [];

  FundSourceBloc({
    required this.getFundSourcesUseCase,
    required this.updateFundSourceUseCase,
    required this.insertFundSourceUseCase,
    required this.getDetailFundUsedInMonthUseCase,
    required this.deleteFundSourceUseCase
  }) : super(FundSourceInitial()) {
    on<GetFundSourceEvent>((event, emit) async {
      emit(GetFundSourceLoading());

      var result = await getFundSourcesUseCase.call(NoParams());

      if (result.isRight) {
        _listFund.clear();
        _listFund.addAll(result.right);
      }

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
    on<UpdateFundSourceEvent>((event, emit) async {
      emit(UpdateFundSourceLoading());

      var result = await updateFundSourceUseCase.call(UpdateFundSourceUseCaseParams(fundSourceModel: event.fundSourceModel));

      emit(
          result.fold(
                  (left) => UpdateFundSourceResult(isSuccess: false),
                  (right) => UpdateFundSourceResult(isSuccess: true)
          )
      );
    });
    on<DeleteFundSourceEvent>((event, emit) async {
      emit(DeleteFundSourceLoading());

      var result = await deleteFundSourceUseCase.call(DeleteFundSourceUseCaseParams(id: event.id));

      emit(
          result.fold(
                  (left) => DeleteFundSourceResult(isSuccess: false),
                  (right) => DeleteFundSourceResult(isSuccess: true)
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
                  (right) {
                    return GetFundUsedDetailLoaded(listData: right);
                  }
          )
      );
    });
  }

  List<FundSource> get listFund => _listFund;
}
