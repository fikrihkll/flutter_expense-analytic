import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/icon_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/bloc/balance_left/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/bloc/expense_month/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/transaction/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/bloc/logs/logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/edit_expense/edit_expense_widget.dart';
import 'package:expense_app/features/presentation/widgets/confirmation_dialog.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LogListItemWidget extends StatelessWidget {

  final Log log;
  final Function(Log) onItemDeleted;

  LogListItemWidget({Key? key, required this.log, required this.onItemDeleted}) : super(key: key);

  late ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Dismissible(
      confirmDismiss: (direction) async {
        var result = await showDialog(context: context,
            builder: (context)=>
                ConfirmationDialogWidget(
                    title: 'Delete Log',
                    message: 'Are you sure want to delete this Log?',
                    positiveAction: 'Yes',
                )
        );

        if(result is bool && result){
          onItemDeleted(log);
          return true;
        }else{
          return false;
        }
      },
      key: Key(log.id.toString()),
      child: FloatingContainer(
          onLongPress: () {
            showMaterialModalBottomSheet(
                context: context,
                isDismissible: true,
                enableDrag: true,
                backgroundColor: Colors.transparent,
                bounce: true,
                closeProgressThreshold: 0.6,
                builder: (builder) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider<LogsBloc>(create: (create) => sl<LogsBloc>()),
                    BlocProvider<BalanceLeftBloc>(create: (create) => sl<BalanceLeftBloc>()),
                    BlocProvider<FundSourceBloc>(create: (create) => sl<FundSourceBloc>()),
                    BlocProvider<ExpenseMonthBloc>(create: (create) => sl<ExpenseMonthBloc>()),
                  ],
                  child: SingleChildScrollView(
                    child: EditExpenseBottomSheet(log: log,),
                  ),
                )
            );
          },
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
                    Text(log.description, style: _theme.textTheme.subtitle1,)
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
}
