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

  @override
  List<Object?> get props => [id, name, dailyFund, weeklyFund, monthlyFund, userId];
}