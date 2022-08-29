import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/error/failure.dart';
import 'package:expense_app/core/usecase/usecase.dart';
import 'package:expense_app/features/domain/entities/fund_source_entity.dart';
import 'package:expense_app/features/domain/usecases/get_fund_sources_usecase.dart';
import 'package:meta/meta.dart';

part 'fund_source_event.dart';
part 'fund_source_state.dart';

class FundSourceBloc extends Bloc<FundSourceEvent, FundSourceState> {

  final GetFundSourcesUseCase getFundSourcesUseCase;
  List<FundSource> _list = [];

  FundSourceBloc({required this.getFundSourcesUseCase}) : super(FundSourceInitial()) {
    on<LoadFundSourceEvent>((event, emit) async {
      var result = await getFundSourcesUseCase.call(NoParams());

      emit(result.fold((l) => FundSourceError(l is ServerFailure ? l.msg : ""), (r) {
        _list = r;
        return FundSourceLoaded(r);
      }));
    });
  }

  List<FundSource> get list => _list;
}
