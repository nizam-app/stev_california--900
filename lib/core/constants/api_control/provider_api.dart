// class ProviderApi {
//   static final String _base_api = "$api/providers";
//   static String get profileScreen => _base_api + "/profile_screen";
// }

class ProviderApi {
  static const String api = "http://103.208.183.248:5000/api/v1";
  static String get profileScreen => "$api/providers/me/profile/screen";
  static String get dashboard => "$api/providers/me/dashboard";
  static String get myBookings => "$api/bookings/provider/me";

  // Towns
  static String get allTowns => "$api/towns/all";
  static String get createTown => "$api/towns";
  static String updateTown(String townId) => "$api/towns/$townId";
}
