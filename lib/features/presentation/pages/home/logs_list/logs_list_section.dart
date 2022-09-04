import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/presentation/bloc/logs/logs_bloc.dart';
import 'package:expense_app/features/presentation/routes/route.dart';
import 'package:expense_app/features/presentation/widgets/log_list_item_widget.dart';
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

  late LogsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LogsBloc>(context);
    widget.controller?.initScrollListener(this);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isUsePaging ? 'All Logs' : 'Recent Expenses',
          style: _theme.textTheme.headline4,
        ),
        BlocBuilder<LogsBloc, LogsState>(
            buildWhen: (context, state) =>
                state is RecentLogsLoading ||
                state is RecentLogsLoaded ||
                state is RecentLogsError ||
                state is LoadAllLogsLoading ||
                state is LoadAllLogsLoaded ||
                state is LoadAllLogsError,
            builder: (context, state){
              if(state is RecentLogsLoading || state is LoadAllLogsLoading){
                return const CupertinoActivityIndicator();
              }else if(state is RecentLogsLoaded || state is LoadAllLogsLoaded){
                List<Log> listData = [];
                if (state is RecentLogsLoaded) {
                  listData = state.listData;
                }
                if (state is LoadAllLogsLoaded) {
                  listData = state.data;
                }
                return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: widget.isUsePaging && _bloc.isLoadMoreAvailable ?
                      listData.length + 1 : listData.length,
                    itemBuilder: (context, position){
                      if (position < listData.length) {
                        return _buildRecentExpenseItem(listData[position]);
                      } else {
                        return CupertinoActivityIndicator();
                      }
                    }
                );
              }else if(state is RecentLogsError || state is LoadAllLogsError){
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
        )
      ],
    );
  }

  Widget _buildRecentExpenseItem(Log log){
    return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: LogListItemWidget(
          log: log,
          onItemDeleted: (log) async {
            _bloc.add(DeleteLogEvent(id: log.id));
          },
        )
    );
  }

  @override
  void onReachedBottom() {
    // DateTime.now() is only used as dummy.
    // Because, formDate and untilDate already stored in BLOC if page 1 is already loaded
    _bloc.add(LoadAllLogEvent(isRefreshing: true, fromDate: DateTime.now(), untilDate: DateTime.now()));
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