import 'package:expense_app/core/util/theme_util.dart';
import 'package:expense_app/features/presentation/widgets/circle_image.dart';
import 'package:expense_app/features/presentation/widgets/floating_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late ThemeData _theme;

  final String _profileUrl = 'https://assets.pikiran-rakyat.com/crop/0x159:1080x864/x/photo/2022/04/03/941016597.jpeg';

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
              // ------------------------------- Header
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
                    size: 32,
                    url: _profileUrl,
                  )
                ],
              ),
              // ------------------------------- Header
              const SizedBox(height: 32,),
              // ------------------------------- Money left
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
              ),
              // ------------------------------- Money left
              const SizedBox(height: 16,),
              FloatingContainer(
                width: double.infinity,
                shadowEnabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Expense this month'),
                    const SizedBox(height: 8,),
                    Center(
                      child: Text('Rp.55.610.000', style: _theme.textTheme.headline1,),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
