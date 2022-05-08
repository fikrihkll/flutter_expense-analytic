import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/core/util/theme_util.dart';
import 'package:expense_app/features/domain/entities/expense_categroy.dart';
import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/insert_log_presenter.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/recent_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/category_list_widget.dart';
import 'package:expense_app/features/presentation/widgets/button_widget.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputExpenseSection extends StatefulWidget {

  const InputExpenseSection({Key? key}) : super(key: key);

  @override
  State<InputExpenseSection> createState() => _InputExpenseSectionState();
}

class _InputExpenseSectionState extends State<InputExpenseSection> {

  // Bloc or Presenter
  late InsertLogPresenter _insertLogPresenter;
  late RecentLogsBloc _recentLogsBloc;
  late ExpenseMonthBloc _expenseMonthBloc;
  
  bool _isSaveButtonEnabled = true;
  late ThemeData _theme;
  final List<ExpenseCategory> _listCategory = [
    ExpenseCategory(name: 'Meal'),
    ExpenseCategory(name: 'Food'),
    ExpenseCategory(name: 'Drink'),
    ExpenseCategory(name: 'Laundry'),
    ExpenseCategory(name: 'E-Money'),
    ExpenseCategory(name: 'E-Wallet'),
    ExpenseCategory(name: 'Tools'),
    ExpenseCategory(name: 'Toiletries'),
    ExpenseCategory(name: 'Electricity'),
    ExpenseCategory(name: 'Shopping'),
    ExpenseCategory(name: 'Others'),
  ];
  int _selectedCategoryPosition = -1;

  // Edit Text Controller
  final TextEditingController _controllerNominal = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();

  Widget _buildCategoryList(){
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: SizedBox(
          height: 50,
          child: ListView.builder(
              itemCount: _listCategory.length,
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
        expenseCategory: _listCategory[position],
        onAreaClicked: (itemPosition){
          // Change selected item
          _selectedCategoryPosition = itemPosition;
          setState(() {
          });
        },
      ),
    );
  }

  void _processNominalText(String text){
    try{
      String nonDecimalNominal = text.replaceAll('.', '');
      _controllerNominal.text = MoneyUtil.getReadableMoney(int.parse(nonDecimalNominal));
      _controllerNominal.selection = TextSelection.fromPosition(TextPosition(offset: _controllerNominal.text.length));
    }catch(e){

    }
  }
  
  Log _buildData(){
    String nonDecimalNominal = _controllerNominal.text.replaceAll('.', '');
    return Log(
        id: -1,
        category: _listCategory[_selectedCategoryPosition].name,
        desc: _controllerDesc.text,
        date: DateUtil.dbFormat.format(DateTime.now()),
        month: DateTime.now().month,
        year: DateTime.now().year,
        nominal: int.parse(nonDecimalNominal),
        userId: 1
    );
  }

  bool isInputDataValid(){
    bool isValid = true;

    if(_controllerNominal.text.isEmpty){
      isValid = false;
    }
    if(_selectedCategoryPosition == -1){
      isValid = false;
    }
    if(!_isSaveButtonEnabled){
      isValid = false;
    }

    return isValid;
  }

  void _saveExpenseData()async{
    FocusManager.instance.primaryFocus?.unfocus();
    if(isInputDataValid()){
      _isSaveButtonEnabled = false;
      setState(() {});

      // Insert data...
      await _insertLogPresenter.insertLogEvent(_buildData());
      // Then update Recent Log List data and others...
      _recentLogsBloc.add(GetRecentLogsEvent());
      _expenseMonthBloc.add(GetExpenseMonthEvent(month: DateTime.now().month, year: DateTime.now().year));

      // Clear Edit Text
      _controllerNominal.text = '';
      _controllerDesc.text = '';

      _isSaveButtonEnabled = true;
      setState(() {});
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Some fields are required'), backgroundColor: MyTheme.red,));
    }
  }


  @override
  void initState() {
    super.initState();
    
    _insertLogPresenter = sl<InsertLogPresenter>();
    _recentLogsBloc = BlocProvider.of<RecentLogsBloc>(context);
    _expenseMonthBloc = BlocProvider.of<ExpenseMonthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return FloatingContainer(
        shadowEnabled: false,
        splashEnabled: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Insert your expense'),
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
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))
              ),
            ),
            const SizedBox(height: 16,),
            const Text('Category'),
            _buildCategoryList(),
            Align(
              alignment: Alignment.centerRight,
              child: ButtonWidget(
                onPressed: () async => _saveExpenseData(),
                isButtonEnabled: _isSaveButtonEnabled,
                text: 'Save',
              )
            )
          ],
        )
    );
  }
}
