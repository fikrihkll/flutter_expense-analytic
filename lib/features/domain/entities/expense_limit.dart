import 'package:equatable/equatable.dart';

class FundSource extends Equatable{

  final int id, userId;
  final int? dailyFund, weeklyFund, monthlyFund;
  final String name;

  FundSource({
    required this.id,
    required this.name,
    required this.dailyFund,
    required this.weeklyFund,
    required this.monthlyFund,
    required this.userId
  });

  factory FundSource.idAndNameOnly(int? id, String? name) {
    return FundSource(id: id ?? -1, name: name ?? "", dailyFund: null, weeklyFund: null, monthlyFund: null, userId: 1);
  }

  static int fetchFundNominal(FundSource fund) {
    if (fund.dailyFund != null && fund.dailyFund! >= 0) {
      return fund.dailyFund!;
    }
    if (fund.weeklyFund != null && fund.weeklyFund! >= 0) {
      return fund.weeklyFund!;
    }
    if (fund.monthlyFund != null && fund.monthlyFund! >= 0) {
      return fund.monthlyFund!;
    }
    return 0;
  }

  static int fetchFundType(FundSource fund) {
    if (fund.dailyFund != null && fund.dailyFund! >= 0) {
      return 0;
    }
    if (fund.weeklyFund != null && fund.weeklyFund! >= 0) {
      return 1;
    }
    if (fund.monthlyFund != null && fund.monthlyFund! >= 0) {
      return 2;
    }
    return 0;
  }

  @override
  List<Object?> get props => [id, name, dailyFund, weeklyFund, monthlyFund, userId];
}