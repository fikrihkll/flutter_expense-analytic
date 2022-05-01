
import 'package:equatable/equatable.dart';

class ExpenseCategory extends Equatable{

  final String name;

  const ExpenseCategory({required this.name});

  @override
  List<Object?> get props => [
    name
  ];
}