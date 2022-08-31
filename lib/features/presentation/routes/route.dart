
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/pages/all_logs/all_logs_page.dart';
import 'package:expense_app/features/presentation/pages/beta_page.dart';
import 'package:expense_app/features/presentation/pages/date_selection/date_selection_bottomsheet.dart';
import 'package:expense_app/features/presentation/bloc/balance_left/balance_left_bloc.dart';
import 'package:expense_app/features/presentation/bloc/logs/logs_bloc.dart';
import 'package:expense_app/features/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const homePage = 'home_page';
const allLogsPage = 'all_logs_page';
const dateSelectionPage = 'date_selection_page';
const betaPage = 'beta_page';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<LogsBloc>(
                    create: (context)=> sl<LogsBloc>()
                ),
                BlocProvider<BalanceLeftBloc>(
                    create: (context)=> sl<BalanceLeftBloc>()
                ),
                BlocProvider<FundSourceBloc>(
                    create: (context)=> sl<FundSourceBloc>()
                ),
              ],
              child: const HomePage()
          )
      );
    case dateSelectionPage:
      return MaterialPageRoute(
          builder: (context) => const DateSelectionBottomSheet()
      );
    case betaPage:
      return MaterialPageRoute(
          builder: (context) => BlocProvider<FundSourceBloc>(
              create: (context) => sl<FundSourceBloc>(),
              child: const BetaPage()
          )
      );
    case allLogsPage:
      return MaterialPageRoute(
          builder: (context) => AllLogsPage()
      );

    default:
      throw ('This route name does not exit');
  }
}