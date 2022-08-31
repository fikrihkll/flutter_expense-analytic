import 'package:expense_app/core/util/theme_util.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {

  final Function onPressed;
  final String text;
  final ButtonWidgetController? controller;

  ButtonWidget({Key? key, required this.onPressed, required this.text, this.controller}) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> with ButtonWidgetListener {

  late ThemeData _theme;
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.setListenerReference(this);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: isButtonEnabled
              ? MaterialStateProperty.all(_theme.colorScheme.primary)
              : MaterialStateProperty.all(MyTheme.gray),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              )
          ),
        ),
        onPressed: () {
          widget.onPressed();
        },
        child: Text(widget.text,)
    );
  }

  @override
  void onLoadingStatusChanged(bool isLoading) {
    isButtonEnabled = !isLoading;
    setState(() {});
  }
}
class ButtonWidgetController {

  ButtonWidgetListener? _listener;

  void setListenerReference(ButtonWidgetListener listener) {
    _listener = listener;
  }

  void showLoading() {
    _listener?.onLoadingStatusChanged(true);
  }

  void hideLoading() {
    _listener?.onLoadingStatusChanged(false);
  }

}

abstract class ButtonWidgetListener {

  void onLoadingStatusChanged(bool isLoading);

}