import 'package:expense_app/features/data/models/floor/fund_sources_dto.dart';
import 'package:expense_app/features/domain/entities/fund_source_entity.dart';

class FundSourceModel extends FundSource {
  final int id;
  final String name;
  final int nominal;
  final FundSourceType type;

  FundSourceModel({
    required this.id,
    required this.name,
    required this.nominal,
    required this.type
  }):super(id: id, name: name, nominal: nominal, type: type);

  factory FundSourceModel.fromDTO(FundSourcesDTO dto) {
    return FundSourceModel(id: dto.id!, name: dto.name, nominal: _getNominal(dto), type: _getType(dto));
  }

  // static FundSourcesDTO toDTO(FundSourceModel model) {
  //   return FundSourcesDTO(id: model.id, user_id: 1, name: model.name, daily_fund: daily_fund, weekly_fund: weekly_fund, monthly_fund: monthly_fund, created_at: created_at, updated_at: updated_at)
  // }

  static int _getNominal(FundSourcesDTO dto) {
    if (dto.daily_fund != null) {
      return dto.daily_fund!;
    }
    if (dto.weekly_fund != null) {
      return dto.weekly_fund!;
    }
    if (dto.monthly_fund != null) {
      return dto.monthly_fund!;
    }
    return 0;
  }

  static FundSourceType _getType(FundSourcesDTO dto) {
    if (dto.daily_fund != null) {
      return FundSourceType.DAILY;
    }
    if (dto.weekly_fund != null) {
      return FundSourceType.WEEKLY;
    }
    if (dto.monthly_fund != null) {
      return FundSourceType.MONTHLY;
    }
    return FundSourceType.DAILY;
  }
}

enum FundSourceType {
  MONTHLY,
  WEEKLY,
  DAILY
}