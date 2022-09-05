import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/routes/route.dart';
import 'package:expense_app/features/presentation/widgets/confirmation_dialog.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FundSourceSelectableList extends StatefulWidget {

  List<FundSource> listData;
  Function(FundSource item) onItemSelected;
  FundSource? defaultSelected;
  bool showNominal;
  FundSourceSelectableListController? controller;

  FundSourceSelectableList({Key? key, required this.listData, required this.onItemSelected, this.defaultSelected, this.showNominal = false, this.controller}) : super(key: key);

  @override
  State<FundSourceSelectableList> createState() => _FundSourceSelectableListState();
}

class _FundSourceSelectableListState extends State<FundSourceSelectableList> with FundSourceSelectableListOnSelected{

  late ThemeData _theme;
  late FundSourceBloc _bloc;
  int _selectedItem = -1;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FundSourceBloc>(context);

    if (widget.defaultSelected != null) {
      _selectedItem = _getIndexFromSelected(widget.defaultSelected!);
    }
    widget.controller?.initListener(this);
  }

  @override
  void onSelected(FundSource? fund) {
    if (fund == null) {
      _selectedItem = -1;
      setState(() {
      });
    } else {
      _selectedItem = _getIndexFromSelected(fund);
      setState(() {
      });
    }
  }

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
          onLongPress: () async {
            if (widget.showNominal) {
              var res = await showDialog(
                  context: context,
                  builder: (builder) =>
                      ConfirmationDialogWidget(
                          title: "Delete Fund Source",
                          message: "Are you sure?",
                          positiveAction: "Yes",
                      )
              );
              if (res is bool && res) {
                _bloc.add(DeleteFundSourceEvent(id: widget.listData[position].id));
                Navigator.pop(context);
              }
            }
          },
          border: position == _selectedItem ? Border.all(color: _theme.primaryColor, width: 1) : null,
          padding: const EdgeInsets.all(16),
          shadowEnabled: true,
          child: widget.showNominal ?
              Text("$item - Rp.${MoneyUtil.getReadableMoney(FundSource.fetchFundNominal(widget.listData[position]))}") :
              Text(item)
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

  int _getIndexFromSelected(FundSource source) {
    int selected = -1;
    widget.listData.asMap().forEach((i, value) {
      if (source.id == value.id) {
        selected = i;
      }
    });
    return selected;
  }

}

abstract class FundSourceSelectableListOnSelected {

  void onSelected(FundSource? fund);

}

class FundSourceSelectableListController {

  FundSourceSelectableListOnSelected? listener;

  void initListener(FundSourceSelectableListOnSelected newListener) {
    listener = newListener;
  }

  void select(FundSource? fund) {
    listener?.onSelected(fund);
  }

}
