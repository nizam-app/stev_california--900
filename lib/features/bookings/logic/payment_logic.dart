import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:renizo/core/constants/api_control/user_api.dart';
import 'package:renizo/core/utils/auth_local_storage.dart';

/// POST /payments/intent – returns clientSecret for Stripe confirmation.
Future<String> createPaymentIntent({
  required String bookingId,
  String? paymentMethodId,
}) async {
  final token = await AuthLocalStorage.getToken();
  final res = await http.post(
    Uri.parse(UserApi.paymentIntent),
    headers: {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'bookingId': bookingId,
      if (paymentMethodId != null && paymentMethodId.isNotEmpty)
        'paymentMethodId': paymentMethodId,
    }),
  );
  final decoded = jsonDecode(res.body) as Map<String, dynamic>?;
  if (res.statusCode >= 400) {
    final msg = (decoded?['message'] ?? 'HTTP ${res.statusCode}').toString();
    throw Exception(msg);
  }
  final data = decoded?['data'] as Map<String, dynamic>?;
  final clientSecret = (data?['clientSecret'] ?? '').toString();
  if (clientSecret.isEmpty) {
    throw Exception('Missing clientSecret from payments/intent');
  }
  return clientSecret;
}
