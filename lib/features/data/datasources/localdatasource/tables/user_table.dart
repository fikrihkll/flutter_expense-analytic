import 'package:floor/floor.dart';

@entity
class UserTable{
  @primaryKey
  final int id;
  final String username;
  final String pass;
  final String name;

  UserTable({
    required this.id,
    required this.username,
    required this.pass,
    required this.name
  });
}