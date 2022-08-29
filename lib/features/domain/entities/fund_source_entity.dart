import 'package:expense_app/features/data/models/fund_source_model.dart';

class FundSource {
  final int id;
  final String name;
  final int nominal;
  final FundSourceType type;

  FundSource({
    required this.id,
    required this.name,
    required this.nominal,
    required this.type
  });

  factory FundSource.fromModel(FundSourceModel model) {
    return FundSource(id: model.id, name: model.name, nominal: model.nominal, type: model.type);
  }
}