import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_assets.dart';

/// One place in the Bangladesh admin ladder (bundled data:
/// github.com/nuhil/bangladesh-geocode, MIT).
class BdPlace {
  const BdPlace({
    required this.id,
    required this.en,
    required this.bn,
    this.lat,
    this.lng,
    this.children = const [],
  });

  final String id;
  final String en;
  final String bn;
  final double? lat;
  final double? lng;
  final List<BdPlace> children;

  String name(String lang) => lang == 'bn' ? bn : en;

  /// Stored in Firestore as "bn|en" so both languages can be shown.
  String get stored => '$bn|$en';

  static String display(String? stored, String lang) {
    if (stored == null) return '';
    final p = stored.split('|');
    if (p.length < 2) return stored;
    return lang == 'bn' ? p[0] : p[1];
  }

  bool matches(String q) {
    final s = q.trim().toLowerCase();
    return s.isEmpty || bn.contains(s) || en.toLowerCase().contains(s);
  }

  factory BdPlace._fromJson(Map<String, dynamic> j, String childKey) {
    final ll = j['ll'] as List<dynamic>?;
    final kids = (j[childKey] as List<dynamic>? ?? const []);
    final nextKey = switch (childKey) {
      'districts' => 'upazilas',
      'upazilas' => 'unions',
      _ => '',
    };
    return BdPlace(
      id: j['id'] as String,
      en: j['en'] as String,
      bn: j['bn'] as String,
      lat: (ll?[0] as num?)?.toDouble(),
      lng: (ll?[1] as num?)?.toDouble(),
      children: [
        for (final k in kids)
          BdPlace._fromJson(k as Map<String, dynamic>, nextKey),
      ],
    );
  }
}

/// Result of a nearest-upazila lookup for the GPS button.
class BdPath {
  const BdPath(this.division, this.district, this.upazila);
  final BdPlace division;
  final BdPlace district;
  final BdPlace upazila;
}

class BdLocations {
  BdLocations(this.divisions);
  final List<BdPlace> divisions;

  static Future<BdLocations> load() async {
    final raw = await rootBundle.loadString(AppData.bdLocations);
    final j = jsonDecode(raw) as Map<String, dynamic>;
    final divs = [
      for (final d in j['divisions'] as List<dynamic>)
        BdPlace._fromJson(d as Map<String, dynamic>, 'districts'),
    ];
    return BdLocations(divs);
  }

  /// Nearest upazila centre to a GPS point (no internet geocoding needed).
  BdPath? nearest(double lat, double lng) {
    BdPath? best;
    var bestD = double.infinity;
    for (final dv in divisions) {
      for (final ds in dv.children) {
        for (final up in ds.children) {
          if (up.lat == null || up.lng == null) continue;
          final d = _dist(lat, lng, up.lat!, up.lng!);
          if (d < bestD) {
            bestD = d;
            best = BdPath(dv, ds, up);
          }
        }
      }
    }
    return best;
  }

  static double _dist(double a1, double o1, double a2, double o2) {
    final dLat = a1 - a2;
    final dLng = (o1 - o2) * math.cos(a1 * math.pi / 180);
    return dLat * dLat + dLng * dLng;
  }
}

final bdLocationsProvider = FutureProvider<BdLocations>((_) => BdLocations.load());
