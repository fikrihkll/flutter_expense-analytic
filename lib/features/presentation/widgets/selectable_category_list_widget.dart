import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/category_list_widget.dart';
import 'package:flutter/material.dart';

class SelectableCategoryListWidget extends StatefulWidget {

  final Function(String category) onItemSelected;

  const SelectableCategoryListWidget({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  State<SelectableCategoryListWidget> createState() => _SelectableCategoryListWidgetState();
}

class _SelectableCategoryListWidgetState extends State<SelectableCategoryListWidget> {

  int _selectedCategoryPosition = -1;

  @override
  Widget build(BuildContext context) {
    return _buildCategoryList();
  }

  Widget _buildCategoryList() {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: SizedBox(
          height: 50,
          child: ListView.builder(
              itemCount: MoneyUtil.listCategory.length,
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
        expenseCategory: MoneyUtil.listCategory[position],
        onAreaClicked: (itemPosition){
          // Change selected item
          _selectedCategoryPosition = itemPosition;
          widget.onItemSelected(MoneyUtil.listCategory[position].name);
          setState(() {
          });
        },
      ),
    );
  }

}
