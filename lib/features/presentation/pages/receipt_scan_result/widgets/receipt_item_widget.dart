import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/domain/entities/expense_categroy.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/domain/entities/receipt_result.dart';
import 'package:expense_app/features/presentation/widgets/fund_source_selectable_list.dart';
import 'package:expense_app/features/presentation/widgets/selectable_category_list_widget.dart';
import 'package:flutter/material.dart';

class ReceiptItemWidget extends StatelessWidget {

  final ReceiptResult entity;
  final Function(FundSource) onFundingSelected;
  final Function(String) onCategorySelected;
  late ThemeData _theme;

  ReceiptItemWidget({Key? key,
    required this.entity,
    required this.onCategorySelected,
    required this.onFundingSelected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return _buildCard(entity.name, entity.nominal);
  }

  Widget _buildCard(String itemName, double nominal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Theme(
          data: _theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              iconColor: _theme.colorScheme.primary,
              collapsedIconColor: _theme.colorScheme.onPrimary,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(itemName, style: _theme.textTheme.headline5),
                  Text("Rp. ${MoneyUtil.getReadableMoney(nominal.toInt())}", style: _theme.textTheme.headline6),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("Category", style: _theme.textTheme.headline6)
                      ),
                      _buildCategoryList(),
                      const SizedBox(height: 16,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text("Funding Source", style: _theme.textTheme.headline6),
                      ),
                      FundSourceSelectableList(
                          onItemSelected: (item, position) {

                          }
                      ),
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16, left: 4, right: 4),
      child: SizedBox(
          height: 60,
          child: SelectableItemListWidget<ExpenseCategory>(
            defaultSelectedItemIndex: null,
            onItemSelected: (selectedPosition) {
            },
            listItem: MoneyUtil.listCategory,
          )
      ),
    );
  }

}
