import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/usecases/get_fund_sources_usecase.dart';
import 'package:meta/meta.dart';

part 'fund_source_list_event.dart';
part 'fund_source_list_state.dart';

class FundSourceListBloc extends Bloc<FundSourceListEvent, FundSourceListState> {

  final GetFundSourcesUseCase getFundSourcesUseCase;

  final List<FundSource> _listFund = [];

  FundSourceListBloc({required this.getFundSourcesUseCase,}) : super(FundSourceListLoading()) {
    on<GetFundSourceListEvent>((event, emit) async {
      var result = await getFundSourcesUseCase.call(NoParams());

      if (result.isRight) {
        _listFund.clear();
        _listFund.addAll(result.right);
      }

      emit(
          result.fold(
                  (left) => GetFundSourceListError(message: left is ServerFailure ? left.msg : unexpectedFailureMessage),
                  (right) => GetFundSourceListLoaded(data: right)
          )
      );
    });
  }

  List<FundSource> get listFund  => _listFund;
}
