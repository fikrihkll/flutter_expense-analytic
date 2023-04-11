import 'package:equatable/equatable.dart';

class LogDetail extends Equatable{

  final String category;
  final double nominal;

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