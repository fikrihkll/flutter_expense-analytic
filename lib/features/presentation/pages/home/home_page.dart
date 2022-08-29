import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/data/repositories/dummy_repository_impl.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/recent_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/input_expense/input_expense_section.dart';
import 'package:expense_app/features/presentation/pages/home/logs_list/logs_list_section.dart';
import 'package:expense_app/features/presentation/pages/input_expense_limit/input_expense_limit_dialog.dart';
import 'package:expense_app/features/presentation/pages/profile_expand/profile_expand_dialog.dart';
import 'package:expense_app/features/presentation/widgets/circle_image.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_app/features/presentation/routes/route.dart' as route;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Bloc or Presenter
  late RecentLogsBloc _recentLogsBloc;
  late BalanceLeftBloc _balanceLeftBloc;

  late ThemeData _theme;

  final String _profileUrl = 'https://assets.pikiran-rakyat.com/crop/0x159:1080x864/x/photo/2022/04/03/941016597.jpeg';

  Widget _buildHeader(){
    return // ------------------------------- Header
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hey, glad to see you back', style: _theme.textTheme.headline4,),
            ],
          ),
          GestureDetector(
            onTap: (){
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => ProfileExpandDialog()
              );
            },
            child: CircleImage(
              size: 44,
              url: _profileUrl,
            ),
          )
        ],
      );
    // ------------------------------- Header
  }

  Widget _buildMoneyLeft(){
    return // ------------------------------- Money left
      FloatingContainer(
          shadowEnabled: false,
          splashEnabled: true,
          onTap: ()async{
            await showDialog(context: context, builder: (context) => InputExpenseLimitDialog());
            _balanceLeftBloc.add(GetBalanceLeftEvent());
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Query masi gagal\nSaran gw rombak ulang ERD\nBalance remaining today'),
              const SizedBox(width: 16,),
              BlocBuilder<BalanceLeftBloc, BalanceLeftState>(
                builder: (context, state){
                  if(state is BalanceLeftLoaded){
                    return Text('Rp.${MoneyUtil.getReadableMoney(state.data)} 😘', style: _theme.textTheme.headline5,);
                  }else{
                    return Text('🥰', style: _theme.textTheme.headline5,);
                  }
                },
              )
            ],
          )
      );
    // ------------------------------- Money left
  }

  Widget _buildExpenseThisMonth(){
    return // ------------------------------- Expense This Month
      FloatingContainer(
          width: double.infinity,
          shadowEnabled: false,
          splashEnabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Expense this month'),
              const SizedBox(height: 16,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: BlocBuilder<ExpenseMonthBloc, ExpenseMonthState>(
                        builder: (context, state){
                          if(state is ExpenseMonthLoaded){
                            return Text('Rp.${MoneyUtil.getReadableMoney(state.nominal)}', style: _theme.textTheme.headline3,);
                          }else{
                            return Text('Rp.0', style: _theme.textTheme.headline3,);
                          }
                        },
                      )
                  ),
                  IconButton(onPressed: (){

                  }, icon: Icon(Icons.arrow_drop_down, color: _theme.colorScheme.onPrimary,))
                ],
              ),
              const SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          )
                      ),
                    ),
                    onPressed: (){
                      Navigator.pushNamed(context, route.allLogsPage);
                    }, child: const Text('All Logs')
                ),
              )
            ],
          )
      );
    // ------------------------------- Expense This Month
  }


  @override
  void initState() {
    super.initState();

    _recentLogsBloc = BlocProvider.of<RecentLogsBloc>(context);
    _balanceLeftBloc = BlocProvider.of<BalanceLeftBloc>(context);
    _recentLogsBloc.add(GetRecentLogsEvent());
    _balanceLeftBloc.add(GetBalanceLeftEvent());

    // loadDummy();

  }

  void loadDummy() async {
    var dummy = DummyRepositoryImpl();
    await dummy.initDb();

    // await dummy.insertDummyData();

    await dummy.insertUser();

    debugPrint("TOTAL FUND ${(await dummy.db!.fundSourceDao.getFundSources()).length}");
    debugPrint("TOTAL EXP ${(await dummy.db!.userDao.getUsers()).length}");
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40,),
              _buildHeader(),
              const SizedBox(height: 32,),
              _buildMoneyLeft(),
              const SizedBox(height: 16,),
              _buildExpenseThisMonth(),
              const SizedBox(height: 16,),
              const InputExpenseSection(),
              const SizedBox(height: 32,),
              const LogsListSection()
            ],
          ),
        ),
      ),
    );
  }
}
