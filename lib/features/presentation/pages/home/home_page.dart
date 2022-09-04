import 'package:expense_app/core/util/money_util.dart';
import 'package:expense_app/features/data/datasources/localdatasource/database_handler.dart';
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/bloc/balance_left/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/bloc/logs/logs_bloc.dart';
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
  late LogsBloc _logsBloc;
  late BalanceLeftBloc _balanceLeftBloc;

  late ThemeData _theme;

  final String _profileUrl = 'https://assets.pikiran-rakyat.com/crop/0x159:1080x864/x/photo/2022/04/03/941016597.jpeg';

  @override
  void initState() {
    super.initState();

    _logsBloc = BlocProvider.of<LogsBloc>(context);
    _balanceLeftBloc = BlocProvider.of<BalanceLeftBloc>(context);
    _logsBloc.add(GetRecentLogsEvent());
    _balanceLeftBloc.add(GetBalanceLeftEvent());
    _balanceLeftBloc.add(GetExpenseInMonthEvent());
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
            await showDialog(
                context: context, builder: (context) {
              return BlocProvider<FundSourceBloc>(
                create: (context)=> sl<FundSourceBloc>(),
                child: InputExpenseLimitDialog(),
              );
            }
            );
            _balanceLeftBloc.add(GetBalanceLeftEvent());
            BlocProvider.of<FundSourceBloc>(context).add(GetFundSourceEvent());
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Balance remaining today'),
              const SizedBox(width: 16,),
              BlocBuilder<BalanceLeftBloc, BalanceLeftState>(
                buildWhen: (context, state) => state is BalanceLeftLoaded ||
                    state is BalanceLeftError ||
                    state is BalanceLeftInitial,
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
                      child: BlocBuilder<BalanceLeftBloc, BalanceLeftState>(
                        buildWhen: (context, state) => state is ExpenseInMonthLoaded ||
                            state is ExpenseInMonthError ||
                            state is BalanceLeftInitial,
                        builder: (context, state){
                          if(state is ExpenseInMonthLoaded){
                            return Text('Rp.${MoneyUtil.getReadableMoney(state.data)}', style: _theme.textTheme.headline3,);
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
}
