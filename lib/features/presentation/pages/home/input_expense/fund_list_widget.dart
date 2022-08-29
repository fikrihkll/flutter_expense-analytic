import 'package:expense_app/core/util/icon_util.dart';
import 'package:expense_app/features/domain/entities/expense_categroy.dart';
import 'package:expense_app/features/domain/entities/fund_source_entity.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';

class FundListWidget extends StatelessWidget {

  final FundSource item;
  final bool isSelected;
  final int itemPosition;
  final Function(int position) onAreaClicked;

  FundListWidget({Key? key,
    required this.item,
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
        onAreaClicked(itemPosition);
      },
      // Border will be shown if the item is selected
      border: isSelected ? Border.all(
          color: _theme.colorScheme.primary,
          width: 1
      ) : null,
      child: Text(item.name, style: _theme.textTheme.subtitle1,)
    );
  }
}
