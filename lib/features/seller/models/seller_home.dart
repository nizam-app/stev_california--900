class ProviderDashboardModel {
  final ProviderDashUser user;
  final ProviderDashStats stats;
  final ProviderDashCounts counts;
  final ProviderDashAvailability availability;
  final List<ProviderServiceCard> serviceCards;
  final List<dynamic> coverageAreas;
  final List<dynamic> recentJobs;

  const ProviderDashboardModel({
    required this.user,
    required this.stats,
    required this.counts,
    required this.availability,
    required this.serviceCards,
    required this.coverageAreas,
    required this.recentJobs,
  });

  factory ProviderDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? {};

    final userJson = (data['user'] as Map<String, dynamic>?) ?? {};
    final statsJson = (data['stats'] as Map<String, dynamic>?) ?? {};
    final countsJson = (data['counts'] as Map<String, dynamic>?) ?? {};
    final availabilityJson =
        (data['availability'] as Map<String, dynamic>?) ?? {};

    final rawServiceCards = (data['serviceCards'] as List?) ?? const [];
    final rawCoverageAreas = (data['coverageAreas'] as List?) ?? const [];
    final rawRecentJobs = (data['recentJobs'] as List?) ?? const [];

    final cards = rawServiceCards
        .whereType<Map>()
        .map((e) => ProviderServiceCard.fromJson(e.cast<String, dynamic>()))
        .toList();

    return ProviderDashboardModel(
      user: ProviderDashUser.fromJson(userJson),
      stats: ProviderDashStats.fromJson(statsJson),
      counts: ProviderDashCounts.fromJson(countsJson),
      availability: ProviderDashAvailability.fromJson(availabilityJson),
      serviceCards: cards,
      coverageAreas: rawCoverageAreas.toList(),
      recentJobs: rawRecentJobs.toList(),
    );
  }
}

class ProviderDashUser {
  final String fullName;
  final String role;

  const ProviderDashUser({required this.fullName, required this.role});

  factory ProviderDashUser.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => (v ?? '').toString();
    return ProviderDashUser(
      fullName: s(json['fullName']),
      role: s(json['role']),
    );
  }
}

class ProviderDashStats {
  final int pending;
  final int active;
  final int completed;
  final int totalJobs;
  final double rating;
  final int ratingCount;
  final int successRate;

  const ProviderDashStats({
    required this.pending,
    required this.active,
    required this.completed,
    required this.totalJobs,
    required this.rating,
    required this.ratingCount,
    required this.successRate,
  });

  factory ProviderDashStats.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '0') ?? 0;
    double toDouble(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '0') ?? 0;

    return ProviderDashStats(
      pending: toInt(json['pending']),
      active: toInt(json['active']),
      completed: toInt(json['completed']),
      totalJobs: toInt(json['totalJobs']),
      rating: toDouble(json['rating']),
      ratingCount: toInt(json['ratingCount']),
      successRate: toInt(json['successRate']),
    );
  }
}

class ProviderDashCounts {
  final int all;
  final int pending;
  final int active;
  final int completed;
  final int cancelled;

  const ProviderDashCounts({
    required this.all,
    required this.pending,
    required this.active,
    required this.completed,
    required this.cancelled,
  });

  factory ProviderDashCounts.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '0') ?? 0;
    return ProviderDashCounts(
      all: toInt(json['all']),
      pending: toInt(json['pending']),
      active: toInt(json['active']),
      completed: toInt(json['completed']),
      cancelled: toInt(json['cancelled']),
    );
  }
}

class ProviderDashAvailability {
  final bool acceptingJobs;

  const ProviderDashAvailability({required this.acceptingJobs});

  factory ProviderDashAvailability.fromJson(Map<String, dynamic> json) {
    final v = json['acceptingJobs'];
    return ProviderDashAvailability(acceptingJobs: v == true);
  }
}

class ProviderServiceCard {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final List<ProviderSubsection> subsections;

  const ProviderServiceCard({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.subsections,
  });

  factory ProviderServiceCard.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => (v ?? '').toString();
    final raw = (json['subsections'] as List?) ?? const [];
    final subs = raw
        .whereType<Map>()
        .map((e) => ProviderSubsection.fromJson(e.cast<String, dynamic>()))
        .toList();

    return ProviderServiceCard(
      id: s(json['_id']),
      name: s(json['name']),
      description: s(json['description']),
      iconUrl: s(json['iconUrl']),
      subsections: subs,
    );
  }
}

class ProviderSubsection {
  final String id;
  final String name;
  final String description;

  const ProviderSubsection({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ProviderSubsection.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => (v ?? '').toString();
    return ProviderSubsection(
      id: s(json['_id']),
      name: s(json['name']),
      description: s(json['description']),
    );
  }
}
