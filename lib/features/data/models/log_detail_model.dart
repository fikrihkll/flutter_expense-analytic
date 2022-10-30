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

  factory LogDetailModel.fromJson(Map<String, dynamic> map){
    return LogDetailModel(
        category: map['category'],
        nominal: map['nominal']
    );
  }

  @override
  List<Object?> get props => [
    category,
    nominal
  ];
}