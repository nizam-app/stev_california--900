import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:renizo/core/constants/api_control/provider_api.dart';
import 'package:renizo/core/utils/auth_local_storage.dart';

import '../models/seller_provider_model.dart';

class ProviderProfileApi {
  ProviderProfileApi({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<SellerProviderModel> fetchProfileScreen() async {
    final token = await AuthLocalStorage.getToken();

    // ✅ 1) token না থাকলে পরিষ্কার error
    if (token == null || token.trim().isEmpty) {
      throw Exception('No token found. Please login as provider again.');
    }

    final uri = Uri.parse(ProviderApi.profileScreen);

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

      // ✅ 2) body debug-friendly parse
      Map<String, dynamic>? decoded;
      try {
        decoded = jsonDecode(res.body) as Map<String, dynamic>;
      } catch (_) {
        decoded = null;
      }

      if (res.statusCode == 200 && decoded != null) {
        return SellerProviderModel.fromJson(decoded);
      }

      final serverMsg = (decoded?['message'] ?? decoded?['error'])?.toString();
      throw HttpException(serverMsg ?? 'HTTP ${res.statusCode}', uri: uri);
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on SocketException {
      throw Exception('Network error: cannot reach server.');
    }
  }
}

final providerProfileApiProvider = Provider<ProviderProfileApi>((ref) {
  return ProviderProfileApi();
});

final providerProfileScreenProvider = FutureProvider<SellerProviderModel>((
  ref,
) async {
  return ref.watch(providerProfileApiProvider).fetchProfileScreen();
});
