import 'package:expense_app/features/domain/entities/fund_detail.dart';

class FundDetailModel extends FundDetail{

  final int id;
  final int nominal;
  final String name;
  final int? dailyFund;
  final int? weeklyFund;
  final int? monthlyFund;
  final int days;
  final int weeks;

  FundDetailModel({
    required this.id,
    required this.nominal,
    required this.name,
    required this.dailyFund,
    required this.weeklyFund,
    required this.monthlyFund,
    required this.days,
    required this.weeks
  }):super(
    id: id,
    nominal: nominal,
    name: name,
    dailyFund: dailyFund,
    weeklyFund: weeklyFund,
    monthlyFund: monthlyFund,
    days: days,
    weeks: weeks
  );

  factory FundDetailModel.fromJson(Map<String, dynamic> json) {
    return FundDetailModel(
        id: json['id'],
        nominal: json['nominal'],
        name: json['name'],
        dailyFund: json['daily_fund'],
        weeklyFund: json['weekly_fund'],
        monthlyFund: json['monthly_fund'],
        days: json['days'],
        weeks: json['weeks']
    );
  }
}