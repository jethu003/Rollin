import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentRepository {
 

  Future<String> createPaymentIntent(double amount) async {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': (amount * 100).toInt().toString(), 
        'currency': 'inr',
        'payment_method_types[]': 'card',
      },
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body['client_secret'];
    } else {
      throw Exception(body['error']['message'] ?? 'PaymentIntent creation failed');
    }
  }
}
