import 'package:expense_app/core/util/theme_util.dart';
import 'package:expense_app/features/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/features/presentation/routes/route.dart' as route;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Inject Dependencies
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _){
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Expense Analytics',
            themeMode: themeProvider.themeMode,
            darkTheme: MyTheme.darkTheme,
            theme: MyTheme.darkTheme,
            onGenerateRoute: route.controller,
            initialRoute: route.loginPage,
          );
        },
    );
  }
}

