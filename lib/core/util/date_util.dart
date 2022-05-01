import 'package:intl/intl.dart';

class DateUtil{
  static DateFormat dbFormat = DateFormat('yyyy-MM-dd hh:mm');
  static DateFormat dateTimeFormat = DateFormat('hh:mm, d MMM yyyy');
  static DateFormat dateFormat = DateFormat('EEE, d MMM yyyy');

  static String formatDateFromDbString(String date){
    DateTime obj = dbFormat.parse(date);
    return dateFormat.format(obj);
  }
}