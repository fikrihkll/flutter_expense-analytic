import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/domain/entities/expense_categroy.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/category_list_item_widget.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/fund_list_item_widget.dart';
import 'package:flutter/material.dart';

class SelectableCategoryListWidget<Item> extends StatefulWidget {

  final Function(int selectedPosition) onItemSelected;
  final List<Item> listItem;
  final int? defaultSelectedItemIndex;

  const SelectableCategoryListWidget({Key? key, required this.onItemSelected, required this.listItem, this.defaultSelectedItemIndex}) : super(key: key);

  @override
  State<SelectableCategoryListWidget> createState() => _SelectableCategoryListWidgetState();
}

class _SelectableCategoryListWidgetState extends State<SelectableCategoryListWidget> {

  int _selectedCategoryPosition = -1;


  @override
  void initState() {
    super.initState();
     _selectedCategoryPosition = widget.defaultSelectedItemIndex ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return _buildCategoryList();
  }

  Widget _buildCategoryList() {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 58,
        child: ListView.builder(
            itemCount: widget.listItem.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, position){
              return _buildItemList(position);
            }
        ),
      ),
    );
  }

  Widget _buildItemList(int position){
    if (widget.listItem[position] is FundSource) {
      return Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
        child: FundListItemWidget(
          itemPosition: position,
          isSelected: _selectedCategoryPosition == position,
          expenseCategory: widget.listItem[position],
          onAreaClicked: (itemPosition){
            // Change selected item
            _selectedCategoryPosition = itemPosition;
            widget.onItemSelected(position);
            setState(() {
            });
          },
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
      child: CategoryListItemWidget(
        itemPosition: position,
        isSelected: _selectedCategoryPosition == position,
        expenseCategory: widget.listItem[position],
        onAreaClicked: (itemPosition){
          // Change selected item
          _selectedCategoryPosition = itemPosition;
          widget.onItemSelected(position);
          setState(() {
          });
        },
      ),
    );
  }

}
