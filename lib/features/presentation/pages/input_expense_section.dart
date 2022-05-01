import 'package:expense_app/features/domain/entities/expense_categroy.dart';
import 'package:expense_app/features/presentation/pages/category_list_widget.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';

class InputExpenseSection extends StatefulWidget {
  const InputExpenseSection({Key? key}) : super(key: key);

  @override
  State<InputExpenseSection> createState() => _InputExpenseSectionState();
}

class _InputExpenseSectionState extends State<InputExpenseSection> {

  late ThemeData _theme;

  final List<ExpenseCategory> _listCategory = [
    ExpenseCategory(name: 'Yuhu', icon: Icons.fastfood_rounded),
    ExpenseCategory(name: 'Yuhu', icon: Icons.fastfood_rounded),
    ExpenseCategory(name: 'Yuhu', icon: Icons.fastfood_rounded),
  ];

  int _selectedItemPosition = -1;

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();

  Widget _buildCategoryList(){
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: SizedBox(
          height: 50,
          child: ListView.builder(
              itemCount: _listCategory.length,
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
        isSelected: _selectedItemPosition == position,
        expenseCategory: _listCategory[position],
        onAreaClicked: (itemPosition){
          // Change selected item
          _selectedItemPosition = itemPosition;
          setState(() {
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return FloatingContainer(
        shadowEnabled: false,
        splashEnabled: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Insert your expense'),
            const SizedBox(height: 16,),
            TextField(
              controller: _controllerTitle,
              style: _theme.textTheme.bodyText1,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefix: Text('Rp.'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))
              ),
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: _controllerDesc,
              style: _theme.textTheme.bodyText1,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))
              ),
            ),
            const SizedBox(height: 16,),
            const Text('Category'),
            _buildCategoryList(),
          ],
        )
    );
  }
}
