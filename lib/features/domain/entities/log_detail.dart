import 'package:equatable/equatable.dart';

class LogDetail extends Equatable{

  final String category;
  final int nominal;

  LogDetail({
    required this.category,
    required this.nominal
  });

  @override
  List<Object?> get props => [
    category,
    nominal
  ];
}