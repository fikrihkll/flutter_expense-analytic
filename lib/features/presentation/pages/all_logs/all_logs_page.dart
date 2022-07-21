import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/all_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/selected_date_bloc.dart';
import 'package:expense_app/features/presentation/pages/date_selection/date_selection_bottomsheet.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/widgets/center_padding_widget.dart';
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
  int _selectedMonth = -1;
  int _selectedYear = -1;


  void _onScroll(){
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if(currentScroll == maxScroll){
      if(!_isLoading){
        _allLogsBloc.add(GetAllLogsEvent(
            isRefreshing: false,
            month: _selectedMonth,
            year: _selectedYear
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
              month: _selectedMonth,
              year: _selectedYear
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
      _selectedMonth = result.month;
      _selectedYear = result.year;

      // Request data
      _allLogsBloc.add(GetAllLogsEvent(
          isRefreshing: true,
          month: _selectedMonth,
          year: _selectedYear
      ));
      _selectedDateBloc.add(SetSelectedDateEvent(
          month: _selectedMonth,
          year: _selectedYear
      ));
      _expenseMonthBloc.add(GetExpenseMonthEvent(
          month: _selectedMonth,
          year: _selectedYear
      ));
    }
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
                child: BlocBuilder<ExpenseMonthBloc, ExpenseMonthState>(
                  builder: (context, state){
                    if(state is ExpenseMonthLoaded){
                      return Text(
                        'Rp.${MoneyUtil.getReadableMoney(state.nominal)}',
                      );
                    }else{
                      return const Text(
                        'Rp.0',
                      );
                    }
                  },
                )
              ),
              Row(
                children: [
                  BlocBuilder<SelectedDateBloc, SelectedDateState>(
                    builder: (context, state) {
                      if(state is SelectedDateSet){
                        return Text(
                            DateUtil.monthFormat.format(DateTime(state.year, state.month))
                        );
                      }else{
                        return Text(
                            DateUtil.monthFormat.format(DateTime(_selectedYear, _selectedMonth))
                        );
                      }
                    }
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
  void initState() {
    super.initState();

    _selectedMonth = DateTime.now().month;
    _selectedYear = DateTime.now().year;

    _allLogsBloc = BlocProvider.of<AllLogsBloc>(context);
    _allLogsBloc.add(GetAllLogsEvent(
        isRefreshing: true,
        month: _selectedMonth,
        year: _selectedYear
    ));

    _expenseMonthBloc = BlocProvider.of<ExpenseMonthBloc>(context);
    _expenseMonthBloc.add(GetExpenseMonthEvent(
        month: _selectedMonth,
        year: _selectedYear)
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
