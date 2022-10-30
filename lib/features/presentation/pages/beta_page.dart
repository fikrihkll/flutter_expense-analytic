import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/data/models/expense_limit_model.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:expense_app/features/presentation/widgets/fund_source_selectable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BetaPage extends StatefulWidget {
  const BetaPage({Key? key}) : super(key: key);

  @override
  State<BetaPage> createState() => _BetaPageState();
}

class _BetaPageState extends State<BetaPage> {

  late ThemeData _theme;

  List<String> listData = ["Kuntul", "Ngews", "Moan"];
  int _selectedItem = 0;

  late FundSourceBloc _fundSourceBloc;


  @override
  void initState() {
    super.initState();
    DatabaseHandler().insertUser();
    _fundSourceBloc = BlocProvider.of<FundSourceBloc>(context);
    _fundSourceBloc.add(
        InsertFundSourceEvent(
            fundSourceModel: FundSourceModel(
              userId: 1,
              name: "Kuluk",
              monthlyFund: null,
              weeklyFund: null,
              dailyFund: 40000,
              id: -1
            )
        )
    );
    _fundSourceBloc.add(GetFundSourceEvent());
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<FundSourceBloc, FundSourceState>(
                builder: (context, state) {
                  if (state is GetFundSourceLoaded) {
                    return FundSourceSelectableList(
                        listData: state.data,
                        onItemSelected: (item) {

                        }
                    );
                  } else {
                    return Text("SOMETHING WRONG");
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int position, String item) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingContainer(
          onTap: () {
            _selectedItem = position;
            setState(() {
            });
          },
          border: position == _selectedItem ? Border.all(color: _theme.primaryColor, width: 1) : null,
          padding: const EdgeInsets.all(12),
          shadowEnabled: true,
          child: Text(item)
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> listWidget = [];

    listData.asMap().forEach((index, value) {
      listWidget.add(_buildItem(index, value));
    });

    return listWidget;
  }
}
