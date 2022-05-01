import 'package:expense_app/features/presentation/pages/home/input_expense/input_expense_section.dart';
import 'package:expense_app/features/presentation/pages/home/recent_expense_list/recent_expense_list_section.dart';
import 'package:expense_app/features/presentation/widgets/circle_image.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
          CircleImage(
            size: 44,
            url: _profileUrl,
          )
        ],
      );
    // ------------------------------- Header
  }

  Widget _buildMoneyLeft(){
    return // ------------------------------- Money left
      FloatingContainer(
          shadowEnabled: false,
          splashEnabled: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Balance remaining today'),
              const SizedBox(width: 16,),
              Text('Rp.12.000.000', style: _theme.textTheme.headline5,)
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
                      child: Text('Rp.55.610.000', style: _theme.textTheme.headline3,)
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

                    }, child: const Text('All Logs')
                ),
              )
            ],
          )
      );
    // ------------------------------- Expense This Month
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
              const SizedBox(height: 24,),
              _buildHeader(),
              const SizedBox(height: 32,),
              _buildMoneyLeft(),
              const SizedBox(height: 16,),
              _buildExpenseThisMonth(),
              const SizedBox(height: 16,),
              const InputExpenseSection(),
              const SizedBox(height: 32,),
              const RecentExpenseListSection()
            ],
          ),
        ),
      ),
    );
  }
}
