import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/all_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/selected_date_bloc.dart';
import 'package:expense_app/features/presentation/pages/date_selection/date_selection_bottomsheet.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/widgets/center_padding_widget.dart';
import 'package:expense_app/features/presentation/widgets/column_padding.dart';
import 'package:expense_app/features/presentation/widgets/confirmation_dialog.dart';
import 'package:expense_app/features/presentation/widgets/log_list_item_widget.dart';
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
  late AllLogsBloc _allLogsBloc;
  late ExpenseMonthBloc _expenseMonthBloc;
  late SelectedDateBloc _selectedDateBloc;

  // Paging thingies
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // Params
  late DateTime _selectedStart;
  late DateTime _selectedEnd;


  void _onScroll(){
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if(currentScroll == maxScroll){
      if(!_isLoading){
        _allLogsBloc.add(GetAllLogsEvent(
            isRefreshing: false,
            dateStart: _selectedStart,
            dateEnd: _selectedEnd
        ));
        _isLoading = true;
      }
    }
  }

  Widget _buildRecentExpenseItem(Log log){
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: LogListItemWidget(
        log: log,
        onItemDeleted: (log) async {
          await _allLogsBloc.deleteLog(log.id);
          _expenseMonthBloc.add(GetExpenseMonthEvent(
              dateStart: _selectedStart,
              dateEnd: _selectedEnd
          ));
        },
      )
    );
  }

  Widget _buildLogsListSection(){
    return BlocBuilder<AllLogsBloc, AllLogsState>(
        builder: (context, state){

          if(state is AllLogsLoading){
            return const CupertinoActivityIndicator();
          }else if(state is AllLogsLoaded){
            _isLoading = false;
            return ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: state.hasReachedMax ? state.listData.length : state.listData.length + 1,
                itemBuilder: (context, position){
                  if(position < state.listData.length){
                    return _buildRecentExpenseItem(state.listData[position]);
                  }else{
                    return const CenterPadding(
                        child: CupertinoActivityIndicator()
                    );
                  }
                }
            );
          }else if(state is AllLogsError){
            _isLoading = false;
            return Center(
              child: Text('There is something wrong/n${state.message}'),
            );
          }else{
            return const Center(
              child: Text(':D'),
            );
          }
        }
    );
  }

  void _onDateTap() async {
    var result = await showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (context) => SingleChildScrollView(
        controller: ScrollController(),
        child: const DateSelectionBottomSheet()
      ),
    );

    // Check whether result is success or not
    if(result != null && result is MonthYearSelectionArgs){
      _selectedStart = result.selectedStart;
      _selectedEnd = result.selectedEnd;

      // Request data
      _allLogsBloc.add(GetAllLogsEvent(
          isRefreshing: true,
          dateStart: _selectedStart,
          dateEnd: _selectedEnd
      ));
      _expenseMonthBloc.add(GetExpenseMonthEvent(
          dateStart: _selectedStart,
          dateEnd: _selectedEnd
      ));
    }
  }

  Widget _buildDateSelectionButton() {
    return Material(
      color: Colors.transparent,
      child: ColumnPadding(
        right: true,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  _onDateTap();
                },
                icon: const Icon(Icons.date_range)
            ),
            Text("${DateUtil.dateFormat.format(_selectedStart)} - ${DateUtil.dateFormat.format(_selectedEnd)}")
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics',
          style: _theme.textTheme.headline1,
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSelectionButton(),
              const SizedBox(
                height: 8,
              ),
              ColumnPadding(
                  child: const Text("Total")
              ),
              ColumnPadding(
                child: Row(
                  children: [
                    Expanded(
                        child: BlocBuilder<ExpenseMonthBloc, ExpenseMonthState>(
                          builder: (context, state){
                            if(state is ExpenseMonthLoaded){
                              return Text(
                                'Rp.${MoneyUtil.getReadableMoney(state.nominal)}',
                                style: _theme.textTheme.headline3
                              );
                            }else{
                              return const Text(
                                'Rp.0',
                              );
                            }
                          },
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _selectedStart = DateTime.now().add(const Duration(days: -31));
    _selectedEnd = DateTime.now();

    _allLogsBloc = BlocProvider.of<AllLogsBloc>(context);
    _allLogsBloc.add(GetAllLogsEvent(
        isRefreshing: true,
        dateStart: _selectedStart,
        dateEnd: _selectedEnd
    ));

    _expenseMonthBloc = BlocProvider.of<ExpenseMonthBloc>(context);
    _expenseMonthBloc.add(GetExpenseMonthEvent(
        dateStart: _selectedStart,
        dateEnd: _selectedEnd
    )
    );

    _selectedDateBloc = BlocProvider.of<SelectedDateBloc>(context);


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
              _buildHeader(),
              _buildLogsListSection()
            ],
          ),
        ),
      ),
    );
  }
}
