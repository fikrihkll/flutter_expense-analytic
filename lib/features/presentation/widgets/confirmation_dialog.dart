import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  String title;
  String message;
  String positiveAction;
  ConfirmationDialogWidget({Key? key, required this.title, required this.message, required this.positiveAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed:  () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text(positiveAction),
            onPressed:  () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
