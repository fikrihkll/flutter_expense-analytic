import 'package:expense_app/features/presentation/widgets/spinner_widget.dart';
import 'package:flutter/material.dart';

class DateSelectionBottomSheet extends StatefulWidget {
  const DateSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  State<DateSelectionBottomSheet> createState() => _DateSelectionBottomSheetState();
}

class _DateSelectionBottomSheetState extends State<DateSelectionBottomSheet> {

  late ThemeData _theme;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinnerWidget(listData: [
                  'Jaunary',
                  'February',
                  'March',
                ], onItemSelectedListener: (value, index){

                }),
                SpinnerWidget(listData: [
                  '2020',
                  '2021',
                  '2022',
                ], onItemSelectedListener: (value, index){

                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
