
import 'package:rollin_user/domain/entities/create_user.dart';

abstract class AuthRepository {
  Future<UserEntity> registerUser({
    required String name,
    required String email,
    required String password,
  });
}
