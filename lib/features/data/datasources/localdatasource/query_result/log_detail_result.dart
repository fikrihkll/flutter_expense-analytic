import 'package:equatable/equatable.dart';
import 'package:expense_app/features/domain/entities/log_detail.dart';
import 'package:floor/floor.dart';

class LogDetailResult{

  @ColumnInfo(name: 'category')
  final String category;
  @ColumnInfo(name: 'total')
  final int total;

  LogDetailResult({
    required this.category,
    required this.total
  });
}