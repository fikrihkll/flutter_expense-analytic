import 'package:expense_app/core/util/theme_util.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  final bool isButtonEnabled;
  final Function onPressed;
  final String text;

  ButtonWidget({Key? key, required this.onPressed, this.isButtonEnabled = true, required this.text}) : super(key: key);

  late ThemeData _theme;

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
          onPressed();
        },
        child: Text(text,)
    );
  }
}
