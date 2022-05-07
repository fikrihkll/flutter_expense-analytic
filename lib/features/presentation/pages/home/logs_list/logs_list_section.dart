import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/icon_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/recent_logs_bloc.dart';
import 'package:expense_app/features/presentation/widgets/confirmation_dialog.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:expense_app/features/presentation/widgets/log_list_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogsListSection extends StatefulWidget {

  const LogsListSection({Key? key}) : super(key: key);

  @override
  State<LogsListSection> createState() => _LogsListSectionState();
}

class _LogsListSectionState extends State<LogsListSection> {

  late ThemeData _theme;

  Widget _buildRecentExpenseItem(Log log){
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: LogListItemWidget(
        log: log,
        onItemDeleted: (log) async {
          await BlocProvider.of<RecentLogsBloc>(context).deleteLog(log.id);
          BlocProvider.of<ExpenseMonthBloc>(context).add(GetExpenseMonthEvent(
              month: DateTime.now().month,
              year: DateTime.now().year
          ));
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Expenses', style: _theme.textTheme.headline4,),
        BlocBuilder<RecentLogsBloc, RecentLogsState>(
            builder: (context, state){
              if(state is RecentLogsLoading){
                return const CupertinoActivityIndicator();
              }else if(state is RecentLogsLoaded){
                return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: state.listData.length,
                    itemBuilder: (context, position){
                      return _buildRecentExpenseItem(state.listData[position]);
                    }
                );
              }else if(state is RecentLogsError){
                return Center(
                  child: Text('There is something wrong/n${state.message}'),
                );
              }else{
                return const Center(
                  child: Text(':D'),
                );
              }
            }
        )
      ],
    );
  }
}
