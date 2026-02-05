import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:renizo/core/constants/api_control/provider_api.dart';
import 'package:renizo/core/utils/auth_local_storage.dart';

import '../models/seller_bookings.dart';

class ProviderMyBookingsApi {
  Future<ProviderMyBookingsData> fetchMyBookings() async {
    final token = await AuthLocalStorage.getToken();

    final uri = Uri.parse(ProviderApi.myBookings);
    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(res.body);

    if (res.statusCode == 200) {
      final parsed = ProviderMyBookingsResponse.fromJson(
        decoded as Map<String, dynamic>,
      );
      return parsed.data;
    }

    final msg = (decoded is Map && decoded['message'] != null)
        ? decoded['message'].toString()
        : 'Request failed (${res.statusCode})';

    throw Exception(msg);
  }
}
