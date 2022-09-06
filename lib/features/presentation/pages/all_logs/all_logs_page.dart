import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/core/util/theme_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/domain/entities/fund_detail.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';
import 'package:expense_app/features/presentation/bloc/balance_left/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/bloc/expense_month/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/bloc/logs/logs_bloc.dart';
import 'package:expense_app/features/presentation/bloc/total_expense_month/total_expense_month_bloc.dart';
import 'package:expense_app/features/presentation/bloc/total_funds/total_funds_bloc.dart';
import 'package:expense_app/features/presentation/pages/date_selection/date_selection_bottomsheet.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/category_list_widget.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/input_expense_section.dart';
import 'package:expense_app/features/presentation/pages/home/logs_list/logs_list_section.dart';
import 'package:expense_app/features/presentation/widgets/center_padding_widget.dart';
import 'package:expense_app/features/presentation/widgets/confirmation_dialog.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:expense_app/features/presentation/widgets/log_list_item_widget.dart';
import 'package:expense_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllLogsPage extends StatefulWidget {
  const AllLogsPage({Key? key}) : super(key: key);

  @override
  State<AllLogsPage> createState() => _AllLogsPageState();
}

class _AllLogsPageState extends State<AllLogsPage> {

  late ThemeData _theme;

  // Bloc or Presenter
  late FundSourceBloc _fundSourceBloc;
  late BalanceLeftBloc _balanceLeftBloc;
  late LogsBloc _logsBloc;
  late ExpenseMonthBloc _expenseMonthBloc;
  late TotalExpenseMonthBloc _totalExpenseMonthBloc;
  late TotalFundsBloc _totalFundsBloc;

  // Paging thingies
  final ScrollController _scrollController = ScrollController();
  final LogsListSectionController _logsController = LogsListSectionController();

  // Params
  DateTime? _fromDate, _untilDate;

  String _rangeDate = "";

  @override
  void initState() {
    super.initState();

    _fundSourceBloc = BlocProvider.of<FundSourceBloc>(context);
    _balanceLeftBloc = BlocProvider.of<BalanceLeftBloc>(context);
    _logsBloc = BlocProvider.of<LogsBloc>(context);
    _expenseMonthBloc = BlocProvider.of<ExpenseMonthBloc>(context);
    _totalExpenseMonthBloc = BlocProvider.of<TotalExpenseMonthBloc>(context);
    _totalFundsBloc = BlocProvider.of<TotalFundsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    _scrollController.addListener(_onScroll);
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16,),
              _fromDate != null
                  ? Column(
                    children: [
                      _buildDetail(),
                      const SizedBox(height: 32,),
                      LogsListSection(
                        isUsePaging: true,
                        controller: _logsController,
                      ),
                    ],
                  ) :
                  const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail() {
    return FloatingContainer(
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total Expense"),
              const SizedBox(height: 4,),
              _buildTotalMonthExpense(),
              const SizedBox(height: 16,),
              const Text("Total Funds"),
              const SizedBox(height: 4,),
              _buildTotalFunds(),
              const SizedBox(height: 16,),
              _buildListFundUsed(),
              const SizedBox(height: 16,),
              const Text("Total Expense Based on Category"),
              const SizedBox(height: 4,),
              _buildListTotalCategory(),
              const SizedBox(height: 16,),
              const Text("Total Savings"),
              const SizedBox(height: 4,),
              _buildTotalSavings(),
            ],
          ),
    );
  }

  Widget _buildTotalMonthExpense() {
    return BlocConsumer<ExpenseMonthBloc, ExpenseMonthState>(
        listenWhen: (context, state) => state is ExpenseInMonthError,
        listener: (context, state) {
          if (state is ExpenseInMonthError) {
            debugPrint("NGNTT");
          }
        },
        buildWhen: (context, state) =>
            state is ExpenseInMonthLoaded,
        builder: (context, state) {
          if (state is ExpenseInMonthLoaded) {
            return Text(
                "Rp.${MoneyUtil.getReadableMoney(state.data)}",
                style: _theme.textTheme.headline5
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        }
    );
  }

  Widget _buildTotalFunds() {
    return BlocConsumer<TotalFundsBloc, TotalFundsState>(
        listenWhen: (context, state) => state is TotalFundsError,
        listener: (context, state) {
          if (state is TotalFundsError) {
            MyTheme.showSnackbar(state.message, context);
          }
        },
        buildWhen: (context, state) =>
        state is TotalFundsLoaded,
        builder: (context, state) {
          if (state is TotalFundsLoaded) {
            return Text(
                "Rp.${MoneyUtil.getReadableMoney(state.data)}",
                style: _theme.textTheme.headline5
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        }
    );
  }

  Widget _buildTotalSavings() {
    return BlocBuilder<BalanceLeftBloc, BalanceLeftState>(
        buildWhen: (context, state) =>
        state is TotalSavingsInMonthLoaded ||
            state is TotalSavingsInMonthError,
        builder: (context, state) {
          if (state is TotalSavingsInMonthLoaded) {
            Color color = state.data > 0 ? MyTheme.green : MyTheme.red;
            return Text(
                "Rp.${MoneyUtil.getReadableMoney(state.data)}",
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold
                )
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        }
    );
  }

  Widget _buildListFundUsed() {
    return BlocBuilder<FundSourceBloc, FundSourceState>(
        buildWhen: (context, state) => state is GetFundUsedDetailLoaded ||
            state is GetFundUsedDetailLoading ||
            state is GetFundUsedDetailError ||
            state is FundSourceInitial,
        builder: (context, state) {
          if (state is GetFundUsedDetailLoaded) {
            _rangeDate = "";
            if (state.listData.isNotEmpty) {
              _rangeDate = "${state.listData.first.days} day(s), ${state.listData.first.weeks} week(s), ${state.listData.first.months} month(s)";
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rangeDate.isNotEmpty ? Text(_rangeDate) : const SizedBox(),
                  const SizedBox(height: 16,),
                  const Text("Total Funds Used"),
                  const SizedBox(height: 4,),
                  ..._buildListFundUsedItem(state.listData),
                ],
              ),
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        }
    );
  }

  Widget _buildListTotalCategory() {
    return BlocConsumer<TotalExpenseMonthBloc, TotalExpenseMonthState>(
        listenWhen: (context, state) => state is TotalExpenseCategoryInMonthError,
        listener: (context, state) {
          if (state is TotalExpenseCategoryInMonthError) {
            MyTheme.showSnackbar(state.message, context);
          }
        },
        buildWhen: (context, state) => state is TotalExpenseCategoryInMonthLoaded,
        builder: (context, state) {
          if (state is TotalExpenseCategoryInMonthLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ..._buildListTotalCategoryItem(state.data),
                ],
              ),
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        }
    );
  }

  List<Widget> _buildListFundUsedItem(List<FundDetail> listData) {
    List<Widget> listWidget = [];
    List<Widget> nameWidget = [];
    listData.asMap().forEach((i, element) {
      nameWidget.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${element.name} ", style: _theme.textTheme.headline4,),
              Row(
                children: [
                  Text(
                    "Rp.${MoneyUtil.getReadableMoney(element.nominal)}",
                    style: _theme.textTheme.headline5,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "/Rp.${MoneyUtil.getReadableMoney(FundDetail.fetchFundTotalNominal(element))}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10
                            ),
                          ),
                        ),
                        Text("Rp.${MoneyUtil.getReadableMoney(FundDetail.fetchFundNominal(element))}/${FundDetail.fetchFundType(element)}", style: TextStyle(fontSize: 10),)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4,),
              Container(color: Colors.white, height: 1, width: double.infinity,),
              const SizedBox(height: 8,)
            ],
          )
      );
    });
    listWidget.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...nameWidget
          ],
        )
    );
    return listWidget;
  }

  List<Widget> _buildListTotalCategoryItem(List<LogDetail> listData) {
    List<Widget> listWidget = [];
    List<Widget> nameWidget = [];
    List<Widget> nominalWidget = [];
    listData.asMap().forEach((i, element) {
      nameWidget.add(
          Text("${element.category} ", style: _theme.textTheme.headline4,)
      );
      nominalWidget.add(
          Text("Rp.${MoneyUtil.getReadableMoney(element.nominal)}", style: _theme.textTheme.headline5,)
      );
    });
    listWidget.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...nameWidget
              ],
            ),
            const SizedBox(width: 8,),
            Column(
              children: [
                ...nominalWidget
              ],
            ),
          ],
        )
    );
    return listWidget;
  }


  void _onDateRangePressed() async {
    var result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000,1,1),
      lastDate: DateTime.now().add(Duration(days: 100)),
    );

    if (result != null) {
      _fromDate = result.start;
      _untilDate = result.end;
      setState(() {

      });
      _fundSourceBloc.add(GetFundUsedDetailEvent(fromDate: _fromDate!, untilDate: _untilDate!));
      _expenseMonthBloc.add(GetExpenseInMonthEvent(fromDate: _fromDate!, untilDate: _untilDate!));
      _totalExpenseMonthBloc.add(GetTotalExpenseCategoryInMonthEvent(fromDate: _fromDate!, untilDate: _untilDate!));
      _balanceLeftBloc.add(GetTotalSavingsInMonthEvent(fromDate: _fromDate!, untilDate: _untilDate!));
      _logsBloc.add(LoadAllLogEvent(isRefreshing: true, fromDate: _fromDate!, untilDate: _untilDate!));
      _totalFundsBloc.add(GetTotalFundsEvent(fromDate: _fromDate!, untilDate: _untilDate!));
    }
  }

  Widget _buildHeader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        FloatingActionButton(
          mini: true,
          onPressed: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: _theme.colorScheme.onPrimary,),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          'All Logs',
          style: _theme.textTheme.headline1,
        ),
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: _onDateRangePressed,
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    _fromDate != null ?
                        "${DateUtil.dateFormat.format(_fromDate!)} - ${DateUtil.dateFormat.format(_untilDate!)}"
                        : "Select Date"
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

  void _onScroll(){
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if(currentScroll == maxScroll){
      if(!_logsBloc.isPagingLoading && _logsBloc.isLoadMoreAvailable) {
        _logsController.bottomReach();
        _logsBloc.setPagingLoading(true);
      }
    }
  }

}
