import 'global_api.dart' as global;

class ProviderApi {
  static String get api => global.api;
  static String get profileScreen => "$api/providers/me/profile";
  static String get dashboard => "$api/providers/me/dashboard";
  static String get myBookings => "$api/bookings/provider/me";
  static String bookingById(String bookingId) => "$api/bookings/provider/$bookingId";
  static String bookingAccept(String bookingId) => "$api/bookings/$bookingId/accept";
  static String bookingReject(String bookingId) => "$api/bookings/$bookingId/rejected";
  static String bookingComplete(String bookingId) => "$api/bookings/$bookingId/complete";
  static String get catalogServices => "$api/catalog/services";
  static Uri catalogSubSectionsUri(String serviceId) {
    return Uri.parse("$api/catalog/subsections").replace(
      queryParameters: {'serviceId': serviceId},
    );
  }
  static Uri catalogAddonsUri(String serviceId) {
    return Uri.parse("$api/catalog/addons").replace(
      queryParameters: {'serviceId': serviceId},
    );
  }
  static String get serviceAreas => "$api/providers/me/service-areas";
  static String get acceptingJobs => "$api/providers/me/accepting-jobs";
  static String publicProfile(String providerUserId) =>
      "$api/providers/public/$providerUserId";
  static String get providerPayout => "$api/providers/me/payout";

  /// POST body: townId, serviceId, subsectionId (List<String>), addonIds (List<String>), scheduledAtISO.
  static String get providerSearch => "$api/bookings/providers/search";

  // Towns
  static String get allTowns => "$api/towns/all";
  static String get createTown => "$api/towns";
  static String updateTown(String townId) => "$api/towns/$townId";
}

