import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/icon_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';

enum LogsListType{
  RECENT,
  ALL
}

class LogsListSection extends StatefulWidget {

  final LogsListType listType;

  const LogsListSection({Key? key, required this.listType}) : super(key: key);

  @override
  State<LogsListSection> createState() => _LogsListSectionState();
}

class _LogsListSectionState extends State<LogsListSection> {

  late ThemeData _theme;

  Widget _buildRecentExpenseItem(Log log){
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: FloatingContainer(
          child: Row(
            children: [
              Icon(
                IconUtil.getIconFromString(log.category),
                color: _theme.colorScheme.primary,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log.category, style: _theme.textTheme.headline6,),
                    const SizedBox(height: 4,),
                    Text(log.desc, style: _theme.textTheme.subtitle1,)
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Rp.${MoneyUtil.getReadableMoney(log.nominal)}', style: _theme.textTheme.headline6,),
                  const SizedBox(height: 4,),
                  Text(DateUtil.formatDateFromDbString(log.date), style: _theme.textTheme.subtitle1)
                ],
              ),
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.listType == LogsListType.RECENT ?
        Text('Recent Expenses', style: _theme.textTheme.headline4,)
        : const SizedBox(),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, position){
            return _buildRecentExpenseItem(Log(
              id: 1,
              category: 'Meal',
              desc: 'Yakinku Grill',
              date: '2022-10-22 20:20',
              month: 10,
              year: 2022,
              nominal: 275000,
              userId: 1
            ));
          }
        )
      ],
    );
  }
}
