import 'package:expense_app/features/domain/entities/expense_categroy.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {

  final ExpenseCategory expenseCategory;
  final bool isSelected;
  final int itemPosition;
  final Function(int position) onAreaClicked;

  CategoryListWidget({Key? key,
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
      shadowEnabled: !isSelected,
      onTap: (){
        onAreaClicked(itemPosition);
      },
      border: isSelected ? Border.all(
          color: _theme.colorScheme.primary,
          width: 1
      ) : null,
      child: Row(
        children: [
          Icon(
            expenseCategory.icon,
            color: _theme.colorScheme.onPrimary,
            size: 16,
          ),
          const SizedBox(width: 8,),
          Text(expenseCategory.name, style: _theme.textTheme.subtitle1,)
        ],
      ),
    );
  }
}
