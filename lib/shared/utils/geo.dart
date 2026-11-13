import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Straight-line distance in km between two points (haversine).
double? distanceKm(GeoPoint? a, GeoPoint? b) {
  if (a == null || b == null) return null;
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(b.latitude - a.latitude);
  final dLng = rad(b.longitude - a.longitude);
  final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(rad(a.latitude)) *
          math.cos(rad(b.latitude)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  return 2 * r * math.asin(math.sqrt(h));
}
