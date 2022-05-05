
import 'package:expense_app/features/presentation/pages/all_logs/all_logs_page.dart';
import 'package:expense_app/features/presentation/pages/date_selection/date_selection_bottomsheet.dart';
import 'package:expense_app/features/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';

const homePage = 'home_page';
const allLogsPage = 'all_logs_page';
const dateSelectionPage = 'date_selection_page';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(
          builder: (context) => const HomePage()
      );
    case dateSelectionPage:
      return MaterialPageRoute(
          builder: (context) => const DateSelectionBottomSheet()
      );
    case allLogsPage:
      return MaterialPageRoute(
          builder: (context) => const AllLogsPage()
      );

    default:
      throw ('This route name does not exit');
  }
}