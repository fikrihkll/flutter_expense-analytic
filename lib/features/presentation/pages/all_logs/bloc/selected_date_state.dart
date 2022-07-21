part of 'selected_date_bloc.dart';

@immutable
abstract class SelectedDateState {}

class SelectedDateInitial extends SelectedDateState {}

class SelectedDateSet extends SelectedDateState {
  final int month, year;

  SelectedDateSet(this.month, this.year);
}
