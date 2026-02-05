import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:renizo/core/constants/api_control/provider_api.dart';
import 'package:renizo/core/utils/auth_local_storage.dart';

import '../models/seller_home.dart';

class ProviderDashboardApi {
  ProviderDashboardApi({http.Client? client})
    : _client = client ?? http.Client();
  final http.Client _client;

  Future<ProviderDashboardModel> fetchDashboard() async {
    final token = await AuthLocalStorage.getToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        'No provider token found. Please login as provider again.',
      );
    }

    final uri = Uri.parse(ProviderApi.dashboard);

    try {
      final res = await _client
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 20));

      final decoded = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return ProviderDashboardModel.fromJson(decoded as Map<String, dynamic>);
      }

      final msg = (decoded is Map && decoded['message'] != null)
          ? decoded['message'].toString()
          : 'HTTP ${res.statusCode}';

      throw HttpException(msg, uri: uri);
    } on TimeoutException {
      throw Exception('Request timeout. Try again.');
    } on SocketException {
      throw Exception('Network error: cannot reach server.');
    }
  }
}

final providerDashboardApiProvider = Provider<ProviderDashboardApi>((ref) {
  return ProviderDashboardApi();
});

final providerDashboardProvider = FutureProvider<ProviderDashboardModel>((
  ref,
) async {
  return ref.watch(providerDashboardApiProvider).fetchDashboard();
});

// ✅ Switch-এর জন্য optional override (লোকালি টগল দেখাতে)
final providerAvailabilityOverrideProvider = StateProvider<bool?>(
  (ref) => null,
);
