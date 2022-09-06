import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/core/util/theme_util.dart';
import 'package:expense_app/features/data/models/log_model.dart';
import 'package:expense_app/features/domain/entities/expense_categroy.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/presentation/bloc/expense_month/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/bloc/balance_left/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/bloc/logs/logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/category_list_widget.dart';
import 'package:expense_app/features/presentation/widgets/button_widget.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:expense_app/features/presentation/widgets/fund_source_selectable_list.dart';
import 'package:expense_app/features/presentation/widgets/splash_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputExpenseSection extends StatefulWidget {

  final Log? log;
  const InputExpenseSection({Key? key, this.log}) : super(key: key);

  @override
  State<InputExpenseSection> createState() => _InputExpenseSectionState();
}

class _InputExpenseSectionState extends State<InputExpenseSection> {

  // Bloc or Presenter
  late LogsBloc _logsBloc;
  late BalanceLeftBloc _balanceLeftBloc;
  late FundSourceBloc _fundSourceBloc;
  late ExpenseMonthBloc _expenseMonthBloc;
  FundSource? _selectedFundSource;

  final ButtonWidgetController _buttonController = ButtonWidgetController();

  late ThemeData _theme;
  
  int _selectedCategoryPosition = -1;

  // Edit Text Controller
  final TextEditingController _controllerNominal = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    _logsBloc = BlocProvider.of<LogsBloc>(context);
    _balanceLeftBloc = BlocProvider.of<BalanceLeftBloc>(context);
    _fundSourceBloc = BlocProvider.of<FundSourceBloc>(context);
    _expenseMonthBloc = BlocProvider.of<ExpenseMonthBloc>(context);
    _fundSourceBloc.add(GetFundSourceEvent());

    if (widget.log != null) {
      _controllerNominal.text = MoneyUtil.getReadableMoney(widget.log!.nominal);
      _controllerDesc.text = widget.log!.description;
      _selectedCategoryPosition = _getSelectedCategory(widget.log!.category);
      _selectedFundSource = FundSource.idAndNameOnly(widget.log!.fundSourceId, widget.log!.fundSourceName);
      _selectedDate = DateUtil.dbFormat.parse(widget.log!.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return BlocListener<LogsBloc, LogsState>(
      listenWhen: (bloc, state) =>
          state is InsertLogsResult ||
          state is InsertLogsLoading ||
          state is UpdateLogsResult ||
          state is UpdateLogsLoading,
      listener: (bloc, state) {
        if (state is InsertLogsResult || state is UpdateLogsResult) {
          // After Success Action
          doAfterSuccess () {
            // Then update Recent Log List data and others...
            _logsBloc.add(GetRecentLogsEvent());
            _balanceLeftBloc.add(GetBalanceLeftEvent());
            _expenseMonthBloc.add(GetExpenseInMonthEvent());

            // Clear Edit Text
            _controllerNominal.text = '';
            _controllerDesc.text = '';

            _buttonController.hideLoading();
            setState(() {});
          }
          if (state is InsertLogsResult && state.isSuccess) {
            doAfterSuccess();
          }
          if (state is UpdateLogsResult && state.isSuccess) {
            doAfterSuccess();
            Navigator.pop(context);
          }
        } else if (state is InsertLogsLoading || state is UpdateLogsLoading) {

        }
      },
      child: FloatingContainer(
          shadowEnabled: false,
          splashEnabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.log != null ? 'Update your expense' : 'Insert your expense'),
              const SizedBox(height: 16,),
              TextField(
                controller: _controllerNominal,
                style: _theme.textTheme.bodyText1,
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                textInputAction: TextInputAction.next,
                onChanged: (str){
                  _processNominalText(str);
                },
                decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefix: Text('Rp.'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))
                ),
              ),
              const SizedBox(height: 16,),
              TextField(
                controller: _controllerDesc,
                style: _theme.textTheme.bodyText1,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))
                ),
              ),
              const SizedBox(height: 16,),
              const Text('Category'),
              _buildCategoryList(),
              const SizedBox(height: 8,),
              const Text('Fund Source'),
              _buildListFund(),
             _buildDateSelectionWidget(),
              Align(
                alignment: Alignment.centerRight,
                child: ButtonWidget(
                  controller: _buttonController,
                  onPressed: () async => _saveExpenseData(),
                  text: 'Save',
                )
              )
            ],
          )
      ),
    );
  }

  Widget _buildDateSelectionWidget() {
    if (_selectedDate != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          const Text('Selected Date'),
          const SizedBox(height: 4,),
          SplashEffectWidget(
              onTap: () async {
                var res = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate!,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now()
                );

                if (res != null) {
                  _selectedDate = res;
                  setState(() {

                  });
                }
              },
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                  DateUtil.dateFormat.format(_selectedDate!),
                  style: _theme.textTheme.headline5,
              )
          ),
          const SizedBox(height: 16,),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildCategoryList() {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: SizedBox(
          height: 50,
          child: ListView.builder(
              itemCount: MoneyUtil.listCategory.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, position){
                return _buildItemList(position);
              }
          ),
        ),
      ),
    );
  }

  Widget _buildItemList(int position){
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: CategoryListWidget(
        itemPosition: position,
        isSelected: _selectedCategoryPosition == position,
        expenseCategory: MoneyUtil.listCategory[position],
        onAreaClicked: (itemPosition){
          // Change selected item
          _selectedCategoryPosition = itemPosition;
          setState(() {
          });
        },
      ),
    );
  }

  Widget _buildListFund() {
    return Material(
      child: BlocBuilder<FundSourceBloc, FundSourceState>(
          buildWhen: (context, state) => state is GetFundSourceLoaded,
          builder: (context, state) {
            if (state is GetFundSourceLoaded) {
              return FundSourceSelectableList(
                  listData: state.data,
                  defaultSelected: _selectedFundSource,
                  onItemSelected: (item) {
                    _selectedFundSource = item;
                  }
              );
            } else {
              return const Text("Something Wrong");
            }
          }
      ),
    );
  }

  bool isInputDataValid(){
    bool isValid = true;

    if(_controllerNominal.text.isEmpty){
      debugPrint("nominal");
      isValid = false;
    }
    if(_selectedCategoryPosition == -1){
      debugPrint("cat");
      isValid = false;
    }
    if (_selectedFundSource == null) {
      debugPrint("fundSource");
      isValid = false;
    }
    if(_logsBloc.state is InsertLogsLoading){
      debugPrint("loading");
      isValid = false;
    }

    return isValid;
  }


  LogModel _buildData(){
    String nonDecimalNominal = _controllerNominal.text.replaceAll('.', '');
    debugPrint("HERE ${_selectedFundSource!.name}");
    debugPrint("HERE ${_selectedFundSource!.id}");
    return LogModel(
      id: widget.log != null ? widget.log!.id : -1,
      userId: 1,
      category: MoneyUtil.listCategory[_selectedCategoryPosition].name,
      description: _controllerDesc.text,
      date: widget.log != null ? DateUtil.dbFormat.format(_selectedDate!) : DateUtil.dbFormat.format(DateTime.now()),
      day: DateTime.now().day,
      month: DateTime.now().month,
      year: DateTime.now().year,
      nominal: int.parse(nonDecimalNominal),
      fundSourceId: _selectedFundSource!.id,
      fundSourceName: _selectedFundSource!.name,
    );
  }

  int _getSelectedCategory(String selectedCategory) {
    int selectedIndex = -1;
    MoneyUtil.listCategory.asMap().forEach((i, value) {
      if (value.name.toLowerCase() == selectedCategory.toLowerCase()) {
        selectedIndex = i;
      }
    });
    return selectedIndex;
  }

  void _saveExpenseData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(isInputDataValid()){
      _buttonController.showLoading();
      setState(() {});

      if (widget.log == null) {
        // Insert data...
        _logsBloc.add(InsertLogEvent(log: _buildData()));
      } else {
        // Update data...
        _logsBloc.add(UpdateLogEvent(log: _buildData()));
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Some fields are required'), backgroundColor: MyTheme.red,));
    }
  }

  void _processNominalText(String text){
    try{
      String nonDecimalNominal = text.replaceAll('.', '');
      _controllerNominal.text = MoneyUtil.getReadableMoney(int.parse(nonDecimalNominal));
      _controllerNominal.selection = TextSelection.fromPosition(TextPosition(offset: _controllerNominal.text.length));
    }catch(e){

    }
  }
}
