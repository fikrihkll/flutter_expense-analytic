import 'package:expense_app/features/data/datasources/localdatasource/query_result/log_detail_result.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';

class LogDetailModel extends LogDetail{

  final String category;
  final int nominal;

  LogDetailModel({
    required this.category,
    required this.nominal
  }):super(
    category: category,
    nominal: nominal
  );

  factory LogDetailModel.fromEntity(LogDetailResult entity){
    return LogDetailModel(category: entity.category, nominal: entity.total);
  }

  @override
  List<Object?> get props => [
    category,
    nominal
  ];
}