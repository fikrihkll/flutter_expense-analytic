import 'package:flutter/material.dart';

class RecentExpenseListSection extends StatefulWidget {
  const RecentExpenseListSection({Key? key}) : super(key: key);

  @override
  State<RecentExpenseListSection> createState() => _RecentExpenseListSectionState();
}

class _RecentExpenseListSectionState extends State<RecentExpenseListSection> {

  late ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Expenses',
          style: _theme.textTheme.headline4,
        ),

      ],
    );
  }
}
