import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MakePayment extends PaymentEvent {
  final double amount;

  MakePayment(this.amount);

  @override
  List<Object?> get props => [amount];
}
