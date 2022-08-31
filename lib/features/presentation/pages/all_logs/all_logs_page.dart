import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/domain/entities/fund_detail.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/pages/date_selection/date_selection_bottomsheet.dart';
import 'package:expense_app/features/presentation/widgets/center_padding_widget.dart';
import 'package:expense_app/features/presentation/widgets/confirmation_dialog.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
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


  // Paging thingies
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // Params
  int _selectedMonth = -1;
  int _selectedYear = -1;

  @override
  void initState() {
    super.initState();

    _selectedMonth = DateTime.now().month;
    _selectedYear = DateTime.now().year;


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
              _buildLogsListSection(),
              _buildDetail()
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
            Text("Total Expense"),
            const SizedBox(height: 4,),
            Text(
              "Rp.${MoneyUtil.getReadableMoney(123456)}",
              style: _theme.textTheme.headline5
            ),
            Text("Total Funds Used"),
            const SizedBox(height: 4,),
            _buildListFundUsed()
          ],
        )
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  ..._buildListFundUsedItem(state.listData)
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
    listData.asMap().forEach((i, element) {
      listWidget.add(
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${element.name}: "),
                Text("Rp.${MoneyUtil.getReadableMoney(element.nominal)}", style: _theme.textTheme.headline5,),
              ],
            ),
        )
      );
    });
    return listWidget;
  }

  Widget _buildRecentExpenseItem(Log log){
    return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: LogListItemWidget(
          log: log,
          onItemDeleted: (log) async {

          },
        )
    );
  }

  Widget _buildLogsListSection(){
    return const SizedBox();
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
          onTap: _onDateTap,
          child: Row(
            children: [

              Row(
                children: [
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
      if(!_isLoading){

        _isLoading = true;
      }
    }
  }

}
