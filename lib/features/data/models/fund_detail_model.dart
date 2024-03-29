import 'package:expense_app/features/domain/entities/fund_detail.dart';

class FundDetailModel extends FundDetail{

  final int id;
  final int nominal;
  final String name;
  final int? dailyFundTotal;
  final int? weeklyFundTotal;
  final int? monthlyFundTotal;
  final int days;
  final int weeks;
  final int months;
  final int? dailyFund;
  final int? weeklyFund;
  final int? monthlyFund;

  FundDetailModel({
    required this.id,
    required this.nominal,
    required this.name,
    required this.dailyFund,
    required this.weeklyFund,
    required this.monthlyFund,
    required this.days,
    required this.weeks,
    required this.months,
    required this.dailyFundTotal,
    required this.weeklyFundTotal,
    required this.monthlyFundTotal,
  }):super(
    id: id,
    nominal: nominal,
    name: name,
    dailyFund: dailyFund,
    weeklyFund: weeklyFund,
    monthlyFund: monthlyFund,
    days: days,
    weeks: weeks,
    months: months,
    dailyFundTotal: dailyFundTotal,
    weeklyFundTotal: weeklyFundTotal,
    monthlyFundTotal: monthlyFundTotal
  );

  factory FundDetailModel.fromJson(Map<String, dynamic> json) {
    return FundDetailModel(
        id: json['id'],
        nominal: json['nominal'],
        name: json['name'],
        dailyFundTotal: json['daily_fund_total'] != null ? double.parse(json['daily_fund_total'].toString()).toInt() : null,
        weeklyFundTotal: json['weekly_fund_total'] != null ? double.parse(json['weekly_fund_total'].toString()).toInt() : null,
        monthlyFundTotal: json['monthly_fund_total'] != null ? double.parse(json['monthly_fund_total'].toString()).toInt() : null,
        days: json['days'] != null ? (json['days'] as double).toInt() : 0,
        weeks: json['weeks'],
        months: json['months'],
        dailyFund: json['daily_fund'],
        weeklyFund: json['weekly_fund'],
        monthlyFund: json['monthly_fund'],
    );
  }
}