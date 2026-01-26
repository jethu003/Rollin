import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCheckout extends CheckoutEvent {}

class UnlockSeats extends CheckoutEvent {}

class BookSeats extends CheckoutEvent {}
