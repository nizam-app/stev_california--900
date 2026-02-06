import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/sellter_bookings_logic.dart';
import '../models/seller_bookings.dart';

final providerMyBookingsApiProvider = Provider<ProviderMyBookingsApi>((ref) {
  return ProviderMyBookingsApi();
});

final providerMyBookingsProvider =
    FutureProvider.autoDispose<ProviderMyBookingsData>((ref) async {
      final api = ref.watch(providerMyBookingsApiProvider);
      return api.fetchMyBookings();
    });
