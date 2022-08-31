import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';

class FundSourceSelectableList extends StatefulWidget {

  List<FundSource> listData;
  Function(FundSource item) onItemSelected;

  FundSourceSelectableList({Key? key, required this.listData, required this.onItemSelected}) : super(key: key);

  @override
  State<FundSourceSelectableList> createState() => _FundSourceSelectableListState();
}

class _FundSourceSelectableListState extends State<FundSourceSelectableList> {

  late ThemeData _theme;
  int _selectedItem = -1;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ..._buildItems()
        ],
      ),
    );
  }

  Widget _buildItem(int position, String item) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingContainer(
          onTap: () {
            widget.onItemSelected(widget.listData[position]);
            _selectedItem = position;
            setState(() {
            });
          },
          border: position == _selectedItem ? Border.all(color: _theme.primaryColor, width: 1) : null,
          padding: const EdgeInsets.all(16),
          shadowEnabled: true,
          child: Text(item)
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> listWidget = [];

    widget.listData.asMap().forEach((index, value) {
      listWidget.add(_buildItem(index, value.name));
    });

    return listWidget;
  }
}
