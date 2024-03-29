import 'package:expense_app/core/util/icon_util.dart';
import 'package:expense_app/features/domain/entities/expense_categroy.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';

class FundListItemWidget extends StatelessWidget {

  final FundSource expenseCategory;
  final bool isSelected;
  final int itemPosition;
  final Function(int position) onAreaClicked;

  FundListItemWidget({Key? key,
    required this.expenseCategory,
    required this.isSelected,
    required this.onAreaClicked,
    required this.itemPosition
  }) : super(key: key);

  late ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return FloatingContainer(
      // Shadow will be vanished if the item is selected
      shadowEnabled: !isSelected,
      onTap: (){
        // Give callback with the item position parameter to the list
        onAreaClicked(isSelected ? -1 : itemPosition);
      },
      // Border will be shown if the item is selected
      border: isSelected ? Border.all(
          color: _theme.colorScheme.primary,
          width: 1
      ) : null,
      child: Row(
        children: [
          Text(expenseCategory.name, style: _theme.textTheme.subtitle1,)
        ],
      ),
    );
  }
}
