import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/presentation/widgets/button_widget.dart';
import 'package:expense_app/features/presentation/widgets/spinner_widget.dart';
import 'package:flutter/material.dart';

class DateSelectionBottomSheet extends StatefulWidget {
  const DateSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  State<DateSelectionBottomSheet> createState() => _DateSelectionBottomSheetState();
}

class _DateSelectionBottomSheetState extends State<DateSelectionBottomSheet> {

  int _monthSelectedValue = 1;
  int _yearSelectedValue = 2022;

  late ThemeData _theme;
  late SpinnerWidget _monthSpinner;

  @override
  void initState() {
    super.initState();

    _monthSelectedValue = DateTime.now().month;
    _yearSelectedValue = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    _monthSpinner = SpinnerWidget(
        listData: DateUtil.listMonth,
        onItemSelectedListener: (value, index){
          _monthSelectedValue = index+1;
        }
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _monthSpinner.updateSelectedItem(DateTime.now().month-1);
    });

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
        decoration: BoxDecoration(
          color: _theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Date', style: _theme.textTheme.headline3,),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _monthSpinner,
                SpinnerWidget(
                    listData: DateUtil.listYear,
                    onItemSelectedListener: (value, index){
                      _yearSelectedValue = int.parse(DateUtil.listYear[index]);
                    }
                )
              ],
            ),
            const SizedBox(height: 16,),
            Align(
              alignment: Alignment.centerRight,
              child: ButtonWidget(
                onPressed: (){
                  debugPrint('pressed');
                  Navigator.pop(context, MonthYearSelectionArgs(year: _yearSelectedValue, month: _monthSelectedValue));
                },
                text: 'Finish',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MonthYearSelectionArgs{

  final int year;
  final int month;

  MonthYearSelectionArgs({required this.year, required this.month});

}