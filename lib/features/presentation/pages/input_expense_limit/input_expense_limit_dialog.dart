import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/core/util/theme_util.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/pages/input_expense_limit/insert_expense_limit_presenter.dart';
import 'package:expense_app/features/presentation/widgets/button_widget.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
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
  late InsertExpenseLimitPresenter _insertExpenseLimitPresenter;
  
  bool _isSaveButtonEnabled = true;
  late ThemeData _theme;


  // Edit Text Controller
  final TextEditingController _controllerWeekdays = TextEditingController();
  final TextEditingController _controllerWeekend = TextEditingController();
  final TextEditingController _controllerBalanceInMonth = TextEditingController();

  void _processNominalText(String text, TextEditingController controller){
    try{
      String nonDecimalNominal = text.replaceAll('.', '');
      controller.text = MoneyUtil.getReadableMoney(int.parse(nonDecimalNominal));
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    // ignore: empty_catches
    }catch(e){

    }
  }

  void getData() async {
    var result = await _insertExpenseLimitPresenter.getExpenseLimitEvent();
    _controllerWeekdays.text = MoneyUtil.getReadableMoney(result.weekdaysLimit);
    _controllerWeekend.text = MoneyUtil.getReadableMoney(result.weekendLimit);
    _controllerBalanceInMonth.text = MoneyUtil.getReadableMoney(result.balanceInMonth);
  }

  ExpenseLimit _buildData(){
    String nonDecimalWeekdays = _controllerWeekdays.text.replaceAll('.', '');
    String nonDecimalWeekdend = _controllerWeekend.text.replaceAll('.', '');
    String nonDecimalBalanceInMonth = _controllerBalanceInMonth.text.replaceAll('.', '');
    debugPrint("()=> $nonDecimalBalanceInMonth");
    return ExpenseLimit(
      id: -1,
      weekendLimit: int.parse(nonDecimalWeekdend),
      weekdaysLimit: int.parse(nonDecimalWeekdays),
      balanceInMonth: int.parse(nonDecimalBalanceInMonth),
      month: DateTime.now().month,
      year: DateTime.now().year,
    );
  }

  bool isInputDataValid(){
    bool isValid = true;

    if(_controllerWeekdays.text.isEmpty){
      isValid = false;
    }
    if(_controllerWeekend.text.isEmpty){
      isValid = false;
    }
    if(_controllerBalanceInMonth.text.isEmpty){
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
      await _insertExpenseLimitPresenter.insertExpenseLimitEvent(_buildData());

      // Clear Edit Text
      _controllerWeekdays.text = '';
      _controllerWeekend.text = '';
      _controllerBalanceInMonth.text = '';

      _isSaveButtonEnabled = true;
      setState(() {});
      Navigator.pop(context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Some fields are required'), backgroundColor: MyTheme.red,));
    }
  }


  @override
  void initState() {
    super.initState();

    _insertExpenseLimitPresenter = sl<InsertExpenseLimitPresenter>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Material(
            color: Colors.transparent,
            child: FloatingContainer(
                shadowEnabled: false,
                splashEnabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Insert your expense'),
                    const SizedBox(height: 16,),
                    TextField(
                      controller: _controllerWeekdays,
                      style: _theme.textTheme.bodyText1,
                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputAction: TextInputAction.next,
                      onChanged: (str){
                        _processNominalText(str, _controllerWeekdays);
                      },
                      decoration: const InputDecoration(
                          labelText: 'Weekdays Limit',
                          prefix: Text('Rp.'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)))
                      ),
                    ),
                    const SizedBox(height: 16,),
                    TextField(
                      controller: _controllerWeekend,
                      style: _theme.textTheme.bodyText1,
                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputAction: TextInputAction.next,
                      onChanged: (str){
                        _processNominalText(str, _controllerWeekend);
                      },
                      decoration: const InputDecoration(
                          labelText: 'Weekend Limit',
                          prefix: Text('Rp.'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)))
                      ),
                    ),
                    const SizedBox(height: 16,),
                    TextField(
                      controller: _controllerBalanceInMonth,
                      style: _theme.textTheme.bodyText1,
                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputAction: TextInputAction.next,
                      onChanged: (str){
                        _processNominalText(str, _controllerBalanceInMonth);
                      },
                      decoration: const InputDecoration(
                          labelText: 'Balance In Month',
                          prefix: Text('Rp.'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)))
                      ),
                    ),
                    const SizedBox(height: 16,),
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
            ),
          ),
        ),
      ],
    );
  }
}
