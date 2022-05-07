
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/pages/all_logs/all_logs_page.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/all_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/all_logs/bloc/selected_date_bloc.dart';
import 'package:expense_app/features/presentation/pages/date_selection/date_selection_bottomsheet.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/bloc/recent_logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const homePage = 'home_page';
const allLogsPage = 'all_logs_page';
const dateSelectionPage = 'date_selection_page';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<RecentLogsBloc>(
                    create: (context)=> sl<RecentLogsBloc>()
                ),
                BlocProvider<ExpenseMonthBloc>(
                    create: (context)=> sl<ExpenseMonthBloc>()
                )
              ],
              child: const HomePage()
          )
      );
    case dateSelectionPage:
      return MaterialPageRoute(
          builder: (context) => const DateSelectionBottomSheet()
      );
    case allLogsPage:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<AllLogsBloc>(
                    create: (context)=> sl<AllLogsBloc>()
                ),
                BlocProvider<ExpenseMonthBloc>(
                    create: (context)=> sl<ExpenseMonthBloc>()
                ),
                BlocProvider<SelectedDateBloc>(
                    create: (context)=> sl<SelectedDateBloc>()
                )
              ],
              child: const AllLogsPage()
          )
      );

    default:
      throw ('This route name does not exit');
  }
}