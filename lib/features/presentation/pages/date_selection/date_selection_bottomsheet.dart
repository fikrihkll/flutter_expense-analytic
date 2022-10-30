import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/presentation/widgets/button_widget.dart';
import 'package:expense_app/features/presentation/widgets/splash_effect_widget.dart';
import 'package:flutter/material.dart';

class DateSelectionBottomSheet extends StatefulWidget {
  const DateSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  State<DateSelectionBottomSheet> createState() => _DateSelectionBottomSheetState();
}

class _DateSelectionBottomSheetState extends State<DateSelectionBottomSheet> {

  late ThemeData _theme;
  String _errorMessage = "";
  DateTime? _fromDate, _untilDate;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

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
            Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text("From Date"),
                      SplashEffectWidget(
                          onTap: _onDateRangePressed,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                              _fromDate != null ? DateUtil.dateFormat.format(_fromDate!) : "Select",
                              style: _theme.textTheme.headline6,
                          )
                      ),
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(" - "),
                  ),
                  Column(
                    children: [
                      const Text("Until Date"),
                      SplashEffectWidget(
                          onTap: _onDateRangePressed,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                              _untilDate != null ? DateUtil.dateFormat.format(_untilDate!) : "Select",
                              style: _theme.textTheme.headline6,
                          )
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16,),
            Align(
              alignment: Alignment.centerRight,
              child: ButtonWidget(
                onPressed: _onFinishPressed,
                text: 'Finish',
              ),
            ),
            const SizedBox(height: 32,),
          ],
        ),
      ),
    );
  }

  void _onDateRangePressed() async {
    var result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000,1,1),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      _fromDate = result.start;
      _untilDate = result.end;
      setState(() {

      });
    }
  }

  void _onFinishPressed() {
    if (_fromDate != null && _untilDate != null) {
      Navigator.pop(
          context,
          DateSelectionArgs(
              fromDate: _fromDate!,
              untilDate: _untilDate!
          )
      );
    }
  }
}

class DateSelectionArgs{

  final DateTime fromDate, untilDate;


  DateSelectionArgs({required this.fromDate, required this.untilDate});

}