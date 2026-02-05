class ProviderMyBookingsResponse {
  final String status;
  final ProviderMyBookingsData data;

  ProviderMyBookingsResponse({required this.status, required this.data});

  factory ProviderMyBookingsResponse.fromJson(Map<String, dynamic> json) {
    return ProviderMyBookingsResponse(
      status: (json['status'] ?? '').toString(),
      data: ProviderMyBookingsData.fromJson(
        (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class ProviderMyBookingsData {
  final int total;
  final ProviderMyBookingsCounts counts;
  final List<ProviderBookingItem> items;

  ProviderMyBookingsData({
    required this.total,
    required this.counts,
    required this.items,
  });

  factory ProviderMyBookingsData.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    return ProviderMyBookingsData(
      total: _asInt(json['total']),
      counts: ProviderMyBookingsCounts.fromJson(
        (json['counts'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
      items: rawItems
          .whereType<Map>()
          .map((e) => ProviderBookingItem.fromJson(e.cast<String, dynamic>()))
          .toList(),
    );
  }
}

class ProviderMyBookingsCounts {
  final int all;
  final int pending;
  final int active;
  final int completed;
  final int cancelled;

  ProviderMyBookingsCounts({
    required this.all,
    required this.pending,
    required this.active,
    required this.completed,
    required this.cancelled,
  });

  factory ProviderMyBookingsCounts.fromJson(Map<String, dynamic> json) {
    return ProviderMyBookingsCounts(
      all: _asInt(json['all']),
      pending: _asInt(json['pending']),
      active: _asInt(json['active']),
      completed: _asInt(json['completed']),
      cancelled: _asInt(json['cancelled']),
    );
  }
}

class ProviderBookingItem {
  final String id;
  final String status;
  final String customerName;
  final String categoryName;
  final String townName;
  final String scheduledDate;
  final String scheduledTime;
  final String notes;
  final bool paidInApp;

  ProviderBookingItem({
    required this.id,
    required this.status,
    required this.customerName,
    required this.categoryName,
    required this.townName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.notes,
    required this.paidInApp,
  });

  factory ProviderBookingItem.fromJson(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '').toString();
    final status = (json['status'] ?? '').toString();

    final customer = (json['customer'] is Map)
        ? (json['customer'] as Map)
        : null;
    final customerName =
        (json['customerName'] ??
                customer?['fullName'] ??
                customer?['name'] ??
                json['clientName'] ??
                '')
            .toString();

    final service = (json['service'] is Map) ? (json['service'] as Map) : null;
    final category = (json['category'] is Map)
        ? (json['category'] as Map)
        : null;
    final categoryName =
        (json['categoryName'] ?? service?['name'] ?? category?['name'] ?? '')
            .toString();

    final town = (json['town'] is Map) ? (json['town'] as Map) : null;
    final townName = (json['townName'] ?? town?['name'] ?? '').toString();

    String date = (json['scheduledDate'] ?? json['date'] ?? '').toString();
    String time = (json['scheduledTime'] ?? json['time'] ?? '').toString();

    // ISO datetime fallback
    final iso = (json['scheduledAt'] ?? json['scheduleAt'] ?? '').toString();
    if ((date.isEmpty || time.isEmpty) && iso.isNotEmpty) {
      final dt = DateTime.tryParse(iso);
      if (dt != null) {
        date =
            '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
        time =
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    }

    final notes = (json['notes'] ?? json['note'] ?? '').toString();

    final paidInApp =
        (json['paidInApp'] == true) ||
        ((json['paymentStatus'] ?? '').toString().toLowerCase() == 'paid');

    return ProviderBookingItem(
      id: id,
      status: status,
      customerName: customerName,
      categoryName: categoryName,
      townName: townName,
      scheduledDate: date,
      scheduledTime: time,
      notes: notes,
      paidInApp: paidInApp,
    );
  }
}

int _asInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v?.toString() ?? '') ?? 0;
}
