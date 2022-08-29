import 'package:expense_app/features/data/models/floor/users_dto.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {

  @Query("SELECT * FROM users")
  Future<List<UsersDTO>> getUsers();

  @insert
  Future<void> insertUsers(UsersDTO user);

}