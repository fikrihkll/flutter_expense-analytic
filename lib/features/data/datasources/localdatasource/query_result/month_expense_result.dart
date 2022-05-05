import 'package:floor/floor.dart';

class MonthExpenseResult{

  @ColumnInfo(name: 'total')
  final int total;

  MonthExpenseResult(this.total);

}