

import 'package:rollin_user/data/repositories/payement_repository.dart';

class CreatePaymentIntentUseCase {
  final PaymentRepository repository;
  CreatePaymentIntentUseCase(this.repository);

  Future<String> call(double amount) async {
    return await repository.createPaymentIntent(amount);
  }
}
