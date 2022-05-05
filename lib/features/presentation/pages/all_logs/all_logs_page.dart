import 'package:expense_app/features/presentation/pages/date_selection/date_selection_bottomsheet.dart';
import 'package:expense_app/features/presentation/sections/logs_list/recent_expense_list_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllLogsPage extends StatefulWidget {
  const AllLogsPage({Key? key}) : super(key: key);

  @override
  State<AllLogsPage> createState() => _AllLogsPageState();
}

class _AllLogsPageState extends State<AllLogsPage> {

  late ThemeData _theme;

  void _onDateTap(){
    showCupertinoModalPopup(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ScrollController(),
        child: DateSelectionBottomSheet()
      ),
    );
  }

  Widget _buildHeader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Logs',
          style: _theme.textTheme.headline1,
        ),
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: _onDateTap,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Rp.123.456.789',
                ),
              ),
              Row(
                children: [
                  Text(
                      'March 2022'
                  ),
                  Icon(Icons.arrow_drop_down, color: _theme.colorScheme.onPrimary,)
                ],
              ),
            ],
          ),
        )
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              FloatingActionButton(
                mini: true,
                  onPressed: (){

                  },
                child: Icon(Icons.arrow_back, color: _theme.colorScheme.onPrimary,),
              ),
              const SizedBox(
                height: 24,
              ),
              _buildHeader(),
              LogsListSection(listType: LogsListType.ALL,)
            ],
          ),
        ),
      ),
    );
  }
}
