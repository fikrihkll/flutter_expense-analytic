import 'package:floor/floor.dart';

@entity
class FundSourceResultDTO {

  @primaryKey
  int id;
  int nominal;
  String name;
  int? daily_fund;
  int? weekly_fund;
  int? monthly_fund;
  int days;
  int weeks;

  FundSourceResultDTO({
    required this.id,
    required this.nominal,
    required this.name,
    required this.daily_fund,
    required this.weekly_fund,
    required this.monthly_fund,
    required this.days,
    required this.weeks});

}