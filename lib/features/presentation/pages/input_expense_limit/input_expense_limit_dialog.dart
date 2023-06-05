import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/core/util/theme_util.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/transaction/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/widgets/button_widget.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:expense_app/features/presentation/widgets/fund_source_selectable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputExpenseLimitDialog extends StatefulWidget {

  const InputExpenseLimitDialog({Key? key}) : super(key: key);

  @override
  State<InputExpenseLimitDialog> createState() => _InputExpenseLimitDialogState();
}

class _InputExpenseLimitDialogState extends State<InputExpenseLimitDialog> {

  // Bloc or Presenter
  late FundSourceBloc _fundSourceBloc;
  
  final ButtonWidgetController _controllerButton = ButtonWidgetController();
  late ThemeData _theme;

  int _selectedFundType = 0;
  FundSource? _selectedFundSource;

  // Edit Text Controller
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNominal = TextEditingController();

  final FundSourceSelectableListController _controllerFundList = FundSourceSelectableListController();

  @override
  void initState() {
    super.initState();

    _fundSourceBloc = BlocProvider.of<FundSourceBloc>(context);
    _fundSourceBloc.add(GetFundSourceEvent());
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return BlocListener<FundSourceBloc, FundSourceState>(
      listenWhen: (context, state) =>
          state is InsertFundSourceResult ||
          state is UpdateFundSourceResult,
      listener: (context, state) {
        if (state is InsertFundSourceResult) {
          if (state.isSuccess) {
            // Clear Edit Text
            _controllerNominal.text = '';
            _controllerName.text = '';

            _controllerButton.hideLoading();
            Navigator.pop(context);
          }
        }
        if (state is UpdateFundSourceResult) {
          if (state.isSuccess) {
            // Clear Edit Text
            _controllerNominal.text = '';
            _controllerName.text = '';

            _controllerButton.hideLoading();
            Navigator.pop(context);
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: FloatingContainer(
                shadowEnabled: false,
                splashEnabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Insert your Fund'),
                    const SizedBox(height: 16,),
                    TextField(
                      controller: _controllerName,
                      style: _theme.textTheme.bodyText1,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          labelText: 'Fund Source Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)))
                      ),
                    ),
                    const SizedBox(height: 16,),
                    TextField(
                      controller: _controllerNominal,
                      style: _theme.textTheme.bodyText1,
                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputAction: TextInputAction.done,
                      onChanged: (str){
                        _processNominalText(str, _controllerNominal);
                      },
                      decoration: const InputDecoration(
                          labelText: 'Nominal',
                          prefix: Text('Rp.'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)))
                      ),
                    ),
                    const SizedBox(height: 16,),
                    RadioListTile(
                        value: 0,
                        groupValue: _selectedFundType,
                        title: Text("Daily"),
                        onChanged: (str){
                          _selectedFundType = 0;
                          setState(() {
                          });
                        }
                    ),
                    RadioListTile(
                        value: 1,
                        title: Text("Weekly"),
                        groupValue: _selectedFundType,
                        onChanged: (str){
                          _selectedFundType = 1;
                          setState(() {
                          });
                        }
                    ),
                    RadioListTile(
                        value: 2,
                        title: Text("Monthly"),
                        groupValue: _selectedFundType,
                        onChanged: (str){
                          _selectedFundType = 2;
                          setState(() {
                          });
                        }
                    ),
                    const SizedBox(height: 16,),
                    _buildListFund(),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: (){
                          _selectedFundSource = null;
                          _controllerName.text = "";
                          _controllerNominal.text = "";
                          _selectedFundType = 0;
                          _controllerFundList.select(null);
                          setState(() {
                          });
                        }, child: Text("Clear")),
                        ButtonWidget(
                          controller: _controllerButton,
                          onPressed: () async => _saveExpenseData(),
                          text: 'Save',
                        ),
                      ],
                    ),
                  ],
                )
            ),
          ),
        ],
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
                  showNominal: true,
                  defaultSelected: _selectedFundSource,
                  listData: state.data,
                  controller: _controllerFundList,
                  onItemSelected: (item) {
                    _selectedFundSource = item;
                    _controllerName.text = item.name;
                    _selectedFundType = FundSource.fetchFundType(item);
                    _controllerNominal.text = MoneyUtil.getReadableMoney(FundSource.fetchFundNominal(item));
                    setState(() {

                    });
                  }
              );
            } else {
              return const Text("Something Wrong");
            }
          }
      ),
    );
  }

  FundSourceModel _buildData(){
    String nonDecimalNominal = _controllerNominal.text.replaceAll(',', '');
    return FundSourceModel(
        id: _selectedFundSource != null ? _selectedFundSource!.id : "",
        budgetId: "",
        dailyFund: _selectedFundType == 0 ? double.parse(nonDecimalNominal) : null,
        weeklyFund: _selectedFundType == 1 ? double.parse(nonDecimalNominal) : null,
        monthlyFund: _selectedFundType == 2 ? double.parse(nonDecimalNominal) : null,
        name: _controllerName.text,
        userId: _selectedFundSource != null ? _selectedFundSource!.userId : "1"
    );
  }

  bool isInputDataValid(){
    bool isValid = true;

    if(_controllerNominal.text.isEmpty){
      isValid = false;
    }
    if(_controllerName.text.isEmpty){
      isValid = false;
    }
    if(_fundSourceBloc.state is InsertFundSourceLoading ||
        _fundSourceBloc.state is UpdateFundSourceLoading
    ){
      isValid = false;
    }

    return isValid;
  }

  void _processNominalText(String text, TextEditingController controller){
    try{
      String nonDecimalNominal = text.replaceAll('.', '');
      controller.text = MoneyUtil.getReadableMoney(double.parse(nonDecimalNominal));
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
      // ignore: empty_catches
    }catch(e){

    }
  }

  void getData() async {
    // var result = await _insertExpenseLimitPresenter.getExpenseLimitEvent();
    // _controllerWeekdays.text = MoneyUtil.getReadableMoney(result.weekdaysLimit);
    // _controllerWeekend.text = MoneyUtil.getReadableMoney(result.weekendLimit);
    // _controllerBalanceInMonth.text = MoneyUtil.getReadableMoney(result.balanceInMonth);
  }

  void _saveExpenseData()async{
    FocusManager.instance.primaryFocus?.unfocus();
    if(isInputDataValid()){
      _controllerButton.showLoading();

      // Insert data...
      if (_selectedFundSource == null) {
        _fundSourceBloc.add(InsertFundSourceEvent(fundSourceModel: _buildData()));
      } else {
        _fundSourceBloc.add(UpdateFundSourceEvent(fundSourceModel: _buildData()));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Some fields are required'), backgroundColor: MyTheme.red,));
    }
  }
}
