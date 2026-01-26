import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rollin_user/domain/usecases/payement_usecase.dart';

import 'payement_gateway_event.dart';
import 'payement_gateway_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePaymentIntentUseCase useCase;

  PaymentBloc(this.useCase) : super(PaymentInitial()) {
    on<MakePayment>(_onMakePayment);
  }

  Future<void> _onMakePayment(
      MakePayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());

    try {
      final clientSecret = await useCase(event.amount);

      // Initialize PaymentSheet (Card only)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Test Merchant',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailed(e.toString()));
    }
  }
}
