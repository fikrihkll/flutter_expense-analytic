
import 'package:expense_app/features/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';

const homePage = 'home_page';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(
          builder: (context) => const HomePage()
      );

    default:
      throw ('This route name does not exit');
  }
}