part of 'selected_date_bloc.dart';

@immutable
abstract class SelectedDateEvent {}

class SetSelectedDateEvent extends SelectedDateEvent {
  final int month, year;

  SetSelectedDateEvent({required this.month, required this.year});
}
