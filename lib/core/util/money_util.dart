import 'package:expense_app/features/domain/entities/expense_categroy.dart';

class MoneyUtil{

  static String getReadableMoney(int nominal){
    String nominalStr = nominal.toString();
    String finalStr = '';
    int counter = 0;
    for(int i=nominalStr.length-1; i>=0; i--){
      if(counter == 3){
        finalStr += '.';
        finalStr += nominalStr[i];
        counter = 1;
      }else{
        finalStr += nominalStr[i];
        counter++;
      }
    }
    return finalStr.split('').reversed.join('');
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