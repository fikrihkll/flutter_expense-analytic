import 'package:expense_app/features/domain/entities/expense_categroy.dart';

class MoneyUtil{

  static String getReadableMoney(double nominal){
    String formattedValue = nominal.toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match match) => '${match.group(1)},');
    return formattedValue;
  }

  static final List<ExpenseCategory> listCategory = [
    ExpenseCategory(name: 'Meal'),
    ExpenseCategory(name: 'Food'),
    ExpenseCategory(name: 'Drink'),
    ExpenseCategory(name: 'Laundry'),
    ExpenseCategory(name: 'E-Money'),
    ExpenseCategory(name: 'Transportation'),
    ExpenseCategory(name: 'Tools'),
    ExpenseCategory(name: 'Toiletries'),
    ExpenseCategory(name: 'Electricity'),
    ExpenseCategory(name: 'Daily Needs'),
    ExpenseCategory(name: 'Shopping'),
    ExpenseCategory(name: 'Others'),
  ];

}