import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_list/fund_source_list_bloc.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/transaction/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/bloc/logs/logs_bloc.dart';
import 'package:expense_app/features/presentation/widgets/log_list_item_widget.dart';
import 'package:expense_app/features/presentation/widgets/selectable_category_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogsListSection extends StatefulWidget {

  final bool isUsePaging;
  final LogsListSectionController? controller;

  const LogsListSection({Key? key, this.isUsePaging = false, this.controller}) : super(key: key);

  @override
  State<LogsListSection> createState() => _LogsListSectionState();
}

class _LogsListSectionState extends State<LogsListSection> with LogsListSectionOnReachedBottomListener{

  late ThemeData _theme;
  late LogsBloc _logsBloc;
  late FundSourceListBloc _fundBloc;
  int _selectedFundFilterPositon = -1;

  @override
  void initState() {
    super.initState();
    _logsBloc = BlocProvider.of<LogsBloc>(context);
    _fundBloc = sl<FundSourceListBloc>();
    if (widget.isUsePaging) {
      _fundBloc.add(GetFundSourceListEvent());
    }
    widget.controller?.initScrollListener(this);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return _provideBlocProvider(
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isUsePaging ? 'All Logs' : 'Recent Expenses',
              style: _theme.textTheme.headline4,
            ),
            const SizedBox(height: 4,),
            widget.isUsePaging ?
            _buildFundingFilterListBuilder() : const SizedBox(),
            _buildLogListBuilder()
          ],
        ),
      ),
    );
  }

  @override
  void onReachedBottom() {
    // DateTime.now() is only used as dummy.
    // Because, formDate and untilDate already stored in BLOC if page 1 is already loaded
    _logsBloc.add(LoadAllLogEvent(isRefreshing: false, fromDate: DateTime.now(), untilDate: DateTime.now()));
  }

  Widget _provideBlocProvider({required Widget child}) {
    return BlocProvider<FundSourceListBloc>(create: (create) => _fundBloc, child: child,);
  }

  Widget _buildRecentExpenseItem(Log log){
    return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: LogListItemWidget(
          log: log,
          onItemDeleted: (log) async {
            _logsBloc.add(DeleteLogEvent(id: log.id));
          },
        )
    );
  }

  Widget _buildFundingFilterListBuilder() {
    return BlocBuilder<FundSourceListBloc, FundSourceListState>(
        builder: (builder, state) {
          if (state is GetFundSourceListLoaded) {
            return _buildFundingFilterList(state.data);
          } else {
            return const CupertinoActivityIndicator();
          }
        }
    );
  }

  Widget _buildFundingFilterList(List<FundSource> listFunds) {
    return SelectableItemListWidget<FundSource>(
        onItemSelected: (selectedPosition) {
          if (_selectedFundFilterPositon == selectedPosition) {
            _selectedFundFilterPositon = -1;
            _logsBloc.add(
                LoadAllLogEvent(
                    isRefreshing: true,
                    retainDateRange: true,
                    // fromDate and untilDate will be retained in BLOC
                    // In these lines, only for obligation purpose
                    fromDate: DateTime.now(),
                    untilDate: DateTime.now(),
                    fundIdFilter: null
                )
            );
          } else {
            _selectedFundFilterPositon = selectedPosition;
            _logsBloc.add(
                LoadAllLogEvent(
                    isRefreshing: true,
                    retainDateRange: true,
                    // fromDate and untilDate will be retained in BLOC
                    // In these lines, only for obligation purpose
                    fromDate: DateTime.now(),
                    untilDate: DateTime.now(),
                    fundIdFilter: _fundBloc.listFund[_selectedFundFilterPositon].id
                )
            );
          }
        },
        listItem: listFunds
    );
  }

  Widget _buildLogList(List<Log> listData) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 0.0),
        itemCount: widget.isUsePaging && _logsBloc.isLoadMoreAvailable ?
        listData.length + 1 : listData.length,
        itemBuilder: (context, position){
          if (position < listData.length) {
            return _buildRecentExpenseItem(listData[position]);
          } else {
            return const Center(child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: CupertinoActivityIndicator(),
            ));
          }
        }
    );
  }

  Widget _buildLogListBuilder() {
    return BlocBuilder<LogsBloc, LogsState>(
        buildWhen: (context, state) =>
        state is RecentLogsLoading ||
            state is RecentLogsLoaded ||
            state is RecentLogsError ||
            state is LoadAllLogsLoading ||
            state is LoadAllLogsLoaded ||
            state is LoadAllLogsError,
        builder: (context, state) {
          if(state is RecentLogsLoading || state is LoadAllLogsLoading) {
            return const CupertinoActivityIndicator();
          }else if(state is RecentLogsLoaded || state is LoadAllLogsLoaded) {
            List<Log> listData = [];
            if (state is RecentLogsLoaded) {
              listData = state.listData;
            }
            if (state is LoadAllLogsLoaded) {
              listData = state.data;
            }
            return _buildLogList(listData);
          }else if(state is RecentLogsError || state is LoadAllLogsError) {
            String message = "";
            if (state is RecentLogsError) {
              message = state.message;
            }
            if (state is LoadAllLogsError) {
              message = state.message;
            }
            return Center(
              child: Text('There is something wrong/n$message'),
            );
          }else{
            return const Center(
              child: Text(':D'),
            );
          }
        }
    );
  }
}

abstract class LogsListSectionOnReachedBottomListener {

  void onReachedBottom();

}

class LogsListSectionController {

  late LogsListSectionOnReachedBottomListener _scrollListener;

  void initScrollListener(LogsListSectionOnReachedBottomListener newListener) {
    _scrollListener = newListener;
  }

  void bottomReach() {
    _scrollListener.onReachedBottom();
  }

}