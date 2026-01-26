import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rollin_user/constants.dart';

class StripeService {
  final Dio _dio = Dio();

  /// 1️Call from UI
  Future<void> makePayment(int amountInRupees) async {
    try {
      final amountInPaise = _calculateAmount(amountInRupees);

      // Step 1: Create PaymentIntent
      final paymentIntent =
          await _createPaymentIntent(amountInPaise, 'inr');

      if (paymentIntent == null) {
        throw Exception("PaymentIntent not created.");
      }

      final clientSecret = paymentIntent['client_secret'];

      // Step 2: Init Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Rollin User',
          style: ThemeMode.light,
        ),
      );

      // Step 3: Show payment sheet
      await Stripe.instance.presentPaymentSheet();

      print("PAYMENT SUCCESS ✔");
    } catch (e) {
      print("PAYMENT FAILED ❌: $e");
    }
  }

  /// 2️⃣ Create PaymentIntent — FIXED
  Future<Map<String, dynamic>?> _createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> data = {
        'amount': amount,
        'currency': currency,
        // ❌ Removed 'payment_method_types[]'
        // Stripe auto-detects card for PaymentSheet
      };

      var response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
          },
        ),
      );

      return response.data;
    } catch (e) {
      if (e is DioException) {
        print("Stripe Error → ${e.response?.data}");
      } else {
        print("Unknown Error → $e");
      }
      return null;
    }
  }

  /// 3️⃣ Convert ₹ → paise
  String _calculateAmount(int amount) {
    return (amount * 100).toString();
  }
}
