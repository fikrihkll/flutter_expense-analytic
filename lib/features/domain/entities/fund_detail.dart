import 'package:flutter/material.dart';

class FundDetail {
  final int id;
  final double nominal;
  final String name;
  final double? dailyFundTotal;
  final double? weeklyFundTotal;
  final double? monthlyFundTotal;
  final int days;
  final int weeks;
  final int months;
  final double? dailyFund;
  final double? weeklyFund;
  final double? monthlyFund;

  FundDetail({
    required this.id,
    required this.nominal,
    required this.name,
    required this.dailyFundTotal,
    required this.weeklyFundTotal,
    required this.monthlyFundTotal,
    required this.days,
    required this.weeks,
    required this.months,
    required this.dailyFund,
    required this.weeklyFund,
    required this.monthlyFund
  });

  static double fetchFundTotalNominal(FundDetail fundDetail) {
    if (fundDetail.dailyFundTotal != null) {
      return fundDetail.dailyFundTotal!;
    }
    if (fundDetail.weeklyFundTotal != null) {
      return fundDetail.weeklyFundTotal!;
    }
    if (fundDetail.monthlyFundTotal != null) {
      return fundDetail.monthlyFundTotal!;
    }
    return 0;
  }

  static double fetchFundNominal(FundDetail fundDetail) {
    if (fundDetail.dailyFund != null) {
      debugPrint("HERE MAP D ${fundDetail.dailyFund}");
      return fundDetail.dailyFund!;
    }
    if (fundDetail.weeklyFund != null) {
      debugPrint("HERE MAP W ${fundDetail.weeklyFund}");
      return fundDetail.weeklyFund!;
    }
    if (fundDetail.monthlyFund != null) {
      debugPrint("HERE MAP M ${fundDetail.monthlyFund}");
      return fundDetail.monthlyFund!;
    }
    return 0;
  }

  static String fetchFundType(FundDetail fundDetail) {
    if (fundDetail.dailyFund != null) {
      return "Daily";
    }
    if (fundDetail.weeklyFund != null) {
      return "Weekly";
    }
    if (fundDetail.monthlyFund != null) {
      return "Monthly";
    }
    if (fundDetail.dailyFundTotal != null) {
      return "Daily";
    }
    if (fundDetail.weeklyFundTotal != null) {
      return "Weekly";
    }
    if (fundDetail.monthlyFundTotal != null) {
      return "Monthly";
    }
    return "None Fund Type";
  }
}