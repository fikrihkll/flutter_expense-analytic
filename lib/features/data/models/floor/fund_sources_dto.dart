import 'package:floor/floor.dart';

@Entity(tableName: "fund_sources", primaryKeys: ["id"])
class FundSourcesDTO {

  @PrimaryKey(autoGenerate: true)
  int? id;
  int user_id;
  String name;
  int? daily_fund;
  int? weekly_fund;
  int? monthly_fund;
  String created_at;
  String updated_at;

  FundSourcesDTO({
    required this.id,
    required this.user_id,
    required this.name,
    required this.daily_fund,
    required this.weekly_fund,
    required this.monthly_fund,
    required this.created_at,
    required this.updated_at});
}