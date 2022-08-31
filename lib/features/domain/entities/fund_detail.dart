class FundDetail {
  final int id;
  final int nominal;
  final String name;
  final int? dailyFund;
  final int? weeklyFund;
  final int? monthlyFund;
  final int days;
  final int weeks;

  FundDetail({
    required this.id,
    required this.nominal,
    required this.name,
    required this.dailyFund,
    required this.weeklyFund,
    required this.monthlyFund,
    required this.days,
    required this.weeks
  });
}