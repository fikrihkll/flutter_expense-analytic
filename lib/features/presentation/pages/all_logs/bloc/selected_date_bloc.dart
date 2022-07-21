import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'selected_date_event.dart';
part 'selected_date_state.dart';

class SelectedDateBloc extends Bloc<SelectedDateEvent, SelectedDateState> {
  SelectedDateBloc() : super(SelectedDateInitial()) {
    on<SetSelectedDateEvent>((event, emit) {
      emit(SelectedDateSet(event.month, event.year));
    });
  }
}
