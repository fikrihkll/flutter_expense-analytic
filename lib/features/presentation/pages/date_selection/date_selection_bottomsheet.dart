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

  late DateTime _selectedStart;
  late DateTime _selectedEnd;

  late ThemeData _theme;
  late SpinnerWidget _monthSpinner;

  @override
  void initState() {
    super.initState();

    _selectedStart = DateTime.now().add(const Duration(days: -31));
    _selectedEnd = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            const Text('Start'),
            GestureDetector(
              onTap: () async {
                var result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2002),
                    lastDate: DateTime.now()
                );
                if (result != null && result.isBefore(_selectedEnd)) {
                  _selectedStart = result;
                }
              },
              child: Text(DateUtil.dateFormat.format(_selectedStart)),
            ),
            const Text('End'),
            GestureDetector(
              onTap: () async {
                var result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2002),
                    lastDate: DateTime.now()
                );
                if (result != null && result.isAfter(_selectedStart)) {
                  _selectedEnd = result;
                }
              },
              child: Text(DateUtil.dateFormat.format(_selectedEnd)),
            ),
            const SizedBox(height: 16,),
            Align(
              alignment: Alignment.centerRight,
              child: ButtonWidget(
                onPressed: (){
                  Navigator.pop(
                      context,
                      MonthYearSelectionArgs(
                          selectedStart: _selectedStart,
                          selectedEnd: _selectedEnd
                      )
                  );
                },
                text: 'Finish',
              ),
            ),
            const SizedBox(height: 32,),
          ],
        ),
      ),
    );
  }
}

class MonthYearSelectionArgs{

  final DateTime selectedStart;
  final DateTime selectedEnd;

  MonthYearSelectionArgs({required this.selectedStart, required this.selectedEnd});

}