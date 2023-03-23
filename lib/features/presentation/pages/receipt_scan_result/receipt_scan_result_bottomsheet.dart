import 'package:expense_app/core/util/camera_util.dart';
import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/core/util/regex_receipt_processor.dart';
import 'package:expense_app/core/util/text_recognition_handler.dart';
import 'package:expense_app/features/domain/entities/receipt_result.dart';
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/transaction/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/pages/camera/camera_page.dart';
import 'package:expense_app/features/presentation/pages/receipt_scan_result/widgets/receipt_item_widget.dart';
import 'package:expense_app/features/presentation/widgets/button_widget.dart';
import 'package:expense_app/features/presentation/widgets/splash_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_app/features/presentation/routes/route.dart' as route;

class ReceiptScanResultBottomSheet extends StatefulWidget {

  final List<ReceiptResult> receiptItemList;
  const ReceiptScanResultBottomSheet({Key? key, required this.receiptItemList}) : super(key: key);

  @override
  State<ReceiptScanResultBottomSheet> createState() => _ReceiptScanResultBottomSheetState();
}

class _ReceiptScanResultBottomSheetState extends State<ReceiptScanResultBottomSheet> {

  late ThemeData _theme;
  late FundSourceBloc _bloc;
  late TextRecognitionHandler _textRecognitionHandler;
  late RegexReceiptProcessor _regexReceiptProcessor;
  List<ReceiptResult> receiptItemList = [];

  @override
  void initState() {
    super.initState();

    receiptItemList = widget.receiptItemList;

    _bloc = BlocProvider.of<FundSourceBloc>(context);
    _textRecognitionHandler = sl<TextRecognitionHandler>();
    _regexReceiptProcessor = sl<RegexReceiptProcessor>();

    _bloc.add(GetFundSourceEvent());
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12))
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24,),
              _buildTitle(),
              const SizedBox(height: 16,),
              ..._buildReceiptItems(),
              const SizedBox(height: 24,),
              _buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Expense", style: _theme.textTheme.headline4,),
            const SizedBox(height: 4,),
            Text("Rp.${MoneyUtil.getReadableMoney(_calculateTotalExpense().toInt())}", style: _theme.textTheme.headline5,),
          ],
        ),
        ButtonWidget(
            onPressed: () {

            },
            text: "Save"
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Receipt Scan Result", style: _theme.textTheme.headline3,),
        SplashEffectWidget(
          onTap: _onScanTapped,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/ic_scan.png", height: 24, width: 24),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildReceiptItems() {
    var listWidget = <Widget>[];
    for (var element in receiptItemList) {
      listWidget.add(
          ReceiptItemWidget(
              entity: ReceiptResult(name: element.name, nominal: element.nominal),
              onCategorySelected: (category) {

              },
              onFundingSelected: (funding) {

              }
          )
      );
    }
    return listWidget;
  }

  Future<void> _checkPermissionAndInitialize() async {
    await CameraUtil.checkPermissionAndInitialize(context);
  }

  void _onScanTapped() async {
    await _checkPermissionAndInitialize();
    var result = await Navigator.pushNamed(context, route.scanPage);
    if (result is ImageResult) {
      var textResult = await _textRecognitionHandler.getTextFromImageBytes(result.bytes);
      var regexResult = _regexReceiptProcessor.convertTextToReceipt(textResult?.text ?? "");
      receiptItemList = regexResult;
      setState(() {
      });
    }
  }

  double _calculateTotalExpense() {
    double total = 0;
    for (var element in receiptItemList) {
      total += element.nominal;
    }
    return total;
  }
}
