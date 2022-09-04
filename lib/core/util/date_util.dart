import 'package:intl/intl.dart';

class DateUtil{
  static DateFormat dbFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  static DateFormat dbDateFormat = DateFormat('yyyy-MM-dd');
  static DateFormat dateTimeFormat = DateFormat('hh:mm, d MMM yyyy');
  static DateFormat dateFormat = DateFormat('EEE, d MMM yyyy');
  static DateFormat monthFormat = DateFormat('MMMM yyyy');

  static String formatDateFromDbString(String date){
    DateTime obj = dbFormat.parse(date);
    return dateFormat.format(obj);
  }

  static List<String> listMonth = [
    'Jaunary',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static List<String> listYear = [
    '${DateTime.now().year}',
    '${DateTime.now().year-1}',
    '${DateTime.now().year-2}',
    '${DateTime.now().year-3}',
  ];

  static DateTime getFirstDateOfThisMonth() {
    return DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1
    );
  }

  static DateTime getLastDateOfThisMonth() {
    return DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          0
        ).day,
    );
  }

}