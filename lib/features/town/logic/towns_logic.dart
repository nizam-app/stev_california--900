// lib/core/logic/towns_logic.dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:renizo/core/constants/api_control/user_api.dart';

import '../../../core/models/town.dart';

final townsControllerProvider = FutureProvider<List<Town>>((ref) async {
  final response = await http.get(
    Uri.parse('${UserApi.townApi}'),
    headers: {
      'Authorization':
          'Bearer ${CustomAPI.providerToken}', // Inject actual token
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final List data = body['data'];
    return data.map((e) => Town.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load towns');
  }
});
