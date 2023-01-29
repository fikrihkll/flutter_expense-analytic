
import 'package:expense_app/features/injection_container.dart';
import 'package:expense_app/features/presentation/bloc/expense_month/expense_month_bloc.dart';
import 'package:expense_app/features/presentation/bloc/fund_source/transaction/fund_source_bloc.dart';
import 'package:expense_app/features/presentation/bloc/total_expense_month/total_expense_month_bloc.dart';
import 'package:expense_app/features/presentation/bloc/total_funds/total_funds_bloc.dart';
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
                BlocProvider<ExpenseMonthBloc>(
                  create: (context) => sl<ExpenseMonthBloc>(),
                )
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
          builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<FundSourceBloc>(
                    create: (context) => sl<FundSourceBloc>(),
                ),
                BlocProvider<BalanceLeftBloc>(
                    create: (context) => sl<BalanceLeftBloc>(),
                ),
                BlocProvider<LogsBloc>(
                  create: (context) => sl<LogsBloc>(),
                ),
                BlocProvider<ExpenseMonthBloc>(
                  create: (context) => sl<ExpenseMonthBloc>(),
                ),
                BlocProvider<TotalExpenseMonthBloc>(
                  create: (context) => sl<TotalExpenseMonthBloc>(),
                ),
                BlocProvider<TotalFundsBloc>(
                  create: (context) => sl<TotalFundsBloc>(),
                )
              ],
              child: const AllLogsPage()
          )
      );

    default:
      throw ('This route name does not exit');
  }
}