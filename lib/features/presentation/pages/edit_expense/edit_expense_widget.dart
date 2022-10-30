import 'package:expense_app/features/domain/entities/log.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/input_expense_section.dart';
import 'package:flutter/material.dart';

class EditExpenseBottomSheet extends StatefulWidget {

  final Log log;
  const EditExpenseBottomSheet({Key? key, required this.log}) : super(key: key);

  @override
  State<EditExpenseBottomSheet> createState() => _EditExpenseBottomSheetState();
}

class _EditExpenseBottomSheetState extends State<EditExpenseBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: InputExpenseSection(
        log: widget.log,
      ),
    );
  }
}
