
import 'package:rollin_user/domain/entities/create_user.dart';

import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return repository.registerUser(name: name, email: email, password: password);
  }
}
