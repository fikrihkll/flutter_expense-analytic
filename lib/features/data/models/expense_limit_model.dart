import 'package:expense_app/core/util/date_util.dart';

/// LOCAL TABLE
/// fund_sources
class FundSourceModel {

  final double? dailyFund, weeklyFund, monthlyFund;
  final String id, name, userId;
  final String? budgetId;

  FundSourceModel({
    required this.id,
    required this.name,
    required this.dailyFund,
    required this.weeklyFund,
    required this.monthlyFund,
    required this.userId,
    required this.budgetId
  });

  factory FundSourceModel.fromMap(Map<String, dynamic> map){
    return FundSourceModel(
        id: map['id'].toString(),
        name: map['name'],
        dailyFund: map['daily_fund'],
        weeklyFund: map['weekly_fund'],
        monthlyFund: map['monthly_fund'],
        userId: map['user_id'].toString(),
        budgetId: map['budget_id']
    );
  }

  static Map<String, dynamic> toMap(FundSourceModel data){
    return {
      'id': data.id.isNotEmpty ? data.id : null,
      'name': data.name,
      'daily_fund': data.dailyFund,
      'weekly_fund': data.weeklyFund,
      'monthly_fund': data.monthlyFund,
      'user_id': '1',
      'budget_id': data.budgetId,
      'created_at': DateUtil.dbFormat.format(DateTime.now()),
      'updated_at': DateUtil.dbFormat.format(DateTime.now()),
      'deleted_at': null
    };
  }

  @override
  List<Object?> get props => [id, name, budgetId, dailyFund, weeklyFund, monthlyFund, userId];
}