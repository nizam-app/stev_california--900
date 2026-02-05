import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:renizo/core/models/town.dart';
import 'package:renizo/core/utils/auth_local_storage.dart';

import '../../../core/constants/api_control/provider_api.dart';

class TownRepository {
  final http.Client _client;
  TownRepository(this._client);

  // ✅ GET /towns/all
  Future<List<Town>> getAllTowns() async {
    final res = await _client.get(
      Uri.parse(ProviderApi.allTowns),
      headers: await AuthLocalStorage.authHeaders(),
    );

    Map<String, dynamic> body;
    try {
      body =
          (res.body.isNotEmpty ? jsonDecode(res.body) : {})
              as Map<String, dynamic>;
    } catch (_) {
      throw Exception("Server returned invalid JSON (${res.statusCode}).");
    }

    if (res.statusCode >= 400) {
      throw Exception(body["message"] ?? "Failed to load towns");
    }

    final data = body["data"];
    if (data is! List) return <Town>[];

    return data.map((e) => Town.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ✅ POST /towns
  Future<Town> createTown({required String name}) async {
    final res = await _client.post(
      Uri.parse(ProviderApi.createTown),
      headers: await AuthLocalStorage.authHeaders(),
      body: jsonEncode({"name": name}),
    );

    Map<String, dynamic> body;
    try {
      body =
          (res.body.isNotEmpty ? jsonDecode(res.body) : {})
              as Map<String, dynamic>;
    } catch (_) {
      throw Exception("Server returned invalid JSON (${res.statusCode}).");
    }

    if (res.statusCode >= 400) {
      throw Exception(body["message"] ?? "Failed to create town");
    }

    final data = body["data"];
    if (data is! Map<String, dynamic>) {
      throw Exception("Invalid response: 'data' is missing.");
    }

    return Town.fromJson(data);
  }

  // ✅ PATCH /towns/:id
  Future<Town> updateTown({
    required String townId,
    String? name,
    bool? isActive,
  }) async {
    final payload = <String, dynamic>{};
    if (name != null) payload["name"] = name;
    if (isActive != null) payload["isActive"] = isActive;

    final res = await _client.patch(
      Uri.parse(ProviderApi.updateTown(townId)),
      headers: await AuthLocalStorage.authHeaders(),
      body: jsonEncode(payload),
    );

    Map<String, dynamic> body;
    try {
      body =
          (res.body.isNotEmpty ? jsonDecode(res.body) : {})
              as Map<String, dynamic>;
    } catch (_) {
      throw Exception("Server returned invalid JSON (${res.statusCode}).");
    }

    if (res.statusCode >= 400) {
      throw Exception(body["message"] ?? "Failed to update town");
    }

    final data = body["data"];
    if (data is! Map<String, dynamic>) {
      throw Exception("Invalid response: 'data' is missing.");
    }

    return Town.fromJson(data);
  }
}
