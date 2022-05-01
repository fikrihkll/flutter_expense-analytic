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

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Expense this month'),
              const SizedBox(height: 16,),
              Text('Rp.55.610.000', style: _theme.textTheme.headline3,),
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

  Widget _buildInputExpense(){
    return FloatingContainer(
        shadowEnabled: false,
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
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24,),
              _buildHeader(),
              const SizedBox(height: 32,),
              _buildMoneyLeft(),
              const SizedBox(height: 16,),
              _buildExpenseThisMonth(),
              const SizedBox(height: 16,),
              _buildInputExpense()
            ],
          ),
        ),
      ),
    );
  }
}
