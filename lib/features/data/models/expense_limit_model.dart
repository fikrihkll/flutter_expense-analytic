import 'package:expense_app/core/util/date_util.dart';
import 'package:expense_app/features/domain/entities/expense_limit.dart';

class FundSourceModel extends FundSource{

  final int id, userId;
  final int? dailyFund, weeklyFund, monthlyFund;
  final String name;

  FundSourceModel({
    required this.id,
    required this.name,
    required this.dailyFund,
    required this.weeklyFund,
    required this.monthlyFund,
    required this.userId
  }):super(
    id: id,
    name: name,
    dailyFund: dailyFund,
    weeklyFund: weeklyFund,
    monthlyFund: monthlyFund,
    userId: userId
  );

  factory FundSourceModel.fromMap(Map<String, dynamic> map){
    return FundSourceModel(
        id: map['id'],
        name: map['name'],
        dailyFund: map['daily_fund'],
        weeklyFund: map['weekly_fund'],
        monthlyFund: map['monthly_fund'],
        userId: map['user_id']
    );
  }

  static Map<String, dynamic> toMap(FundSourceModel data){
    return {
      'id': data.id > 0 ? data.id : null,
      'name': data.name,
      'daily_fund': data.dailyFund,
      'weekly_fund': data.weeklyFund,
      'monthly_fund': data.monthlyFund,
      'user_id': -1,
      'created_at': DateUtil.dbFormat.format(DateTime.now()),
      'updated_at': DateUtil.dbFormat.format(DateTime.now()),
      'deleted_at': null
    };
  }

  @override
  List<Object?> get props => [id, name, dailyFund, weeklyFund, monthlyFund, userId];
}