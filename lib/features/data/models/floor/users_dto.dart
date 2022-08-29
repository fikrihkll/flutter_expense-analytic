import 'package:floor/floor.dart';

@Entity(tableName: "users", primaryKeys: ["id"])
class UsersDTO {

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String username;
  final String password;

  UsersDTO({
    required this.id,
    required this.name,
    required this.username,
    required this.password
  });

}