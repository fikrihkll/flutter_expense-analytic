import 'package:expense_app/features/domain/entities/expense_categroy.dart';

class ExpenseCategoryModel extends ExpenseCategory{

  final String name;

  const ExpenseCategoryModel({
    required this.name
  }):super(
    name: name
  );

  @override
  List<Object?> get props => [
    name
  ];
}