import 'dart:convert';

import 'package:http/http.dart' as http;

/// Live wholesale prices from the Department of Agricultural Marketing
/// (DAM, Ministry of Agriculture) — the government's daily national
/// average from field offices in all 8 divisions. Public JSON, no key.
/// Source: https://moa-services.com/agri-service (Krishi Sheba / DAM).
///
/// A day's report usually appears around midday, so "today" falls back to
/// the latest day that has data.
class DamPriceService {
  DamPriceService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static const sourceUrl = 'https://moa-services.com/agri-service';
  static const _report =
      '$sourceUrl/crop-price-info/reports/price-report/'
      'division-wise-average-price-report';
  static const _timeout = Duration(seconds: 10);

  /// How far back to look for the latest report.
  static const lookBackDays = 10;

  /// App crop key → DAM commodity ids, best match first (the first one
  /// with a price that day is used). Crops not listed (e.g. mango, which
  /// DAM does not report) keep the admin's price.
  static const commodities = <String, List<int>>{
    'tomato': [981, 983],
    'potato': [943, 947, 945],
    'rice': [2995, 597, 596, 594, 595], // paddy (ধান)
    'eggplant': [949, 950],
    'onion': [831, 833],
    'chili': [837, 1001, 21012], // green chili
  };

  /// DAM unit codes → kg (1 = quintal, 2 = kg).
  static const _kgPerUnit = {1: 100, 2: 1};

  final _cache = <String, Future<Map<int, DamPrice>>>{};

  static String dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// All commodity prices for one day (empty when not published).
  /// Past days are cached for the app session; today is fetched fresh.
  Future<Map<int, DamPrice>> day(DateTime d) {
    final key = dayKey(d);
    final isToday = key == dayKey(DateTime.now());
    if (!isToday && _cache.containsKey(key)) return _cache[key]!;
    final f = _fetch(key);
    if (!isToday) {
      _cache[key] = f;
      // A failed fetch must not stay cached.
      f.catchError((_) {
        _cache.remove(key);
        return <int, DamPrice>{};
      });
    }
    return f;
  }

  Future<Map<int, DamPrice>> _fetch(String key) async {
    final uri = Uri.parse(_report).replace(queryParameters: {
      'com_grp_id': '0',
      'com_subgrp_id': '0',
      'start_date': key,
      'end_date': key,
    });
    final res = await _client.get(uri).timeout(_timeout);
    if (res.statusCode != 200) throw DamException('http_${res.statusCode}');
    final body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    if (body['success'] != true) return const {};
    final out = <int, DamPrice>{};
    for (final r in (body['data'] as List? ?? const [])) {
      final p = DamPrice.fromRow(r as Map<String, dynamic>);
      if (p != null) out[p.commodityId] = p;
    }
    return out;
  }

  /// Price of [cropKey] in one day's report, or null.
  static DamPrice? pick(Map<int, DamPrice> day, String cropKey) {
    for (final id in commodities[cropKey] ?? const <int>[]) {
      final p = day[id];
      if (p != null) return p;
    }
    return null;
  }
}

/// One commodity's national average for a day, per kg (wholesale; retail
/// when DAM has no wholesale figure).
class DamPrice {
  const DamPrice(this.commodityId, this.min, this.max, this.updatedAt);
  final int commodityId;
  final double min;
  final double max;
  final DateTime? updatedAt;

  double get mid => (min + max) / 2;

  static double _num(Object? v) => double.tryParse('${v ?? ''}') ?? 0;

  static DamPrice? fromRow(Map<String, dynamic> r) {
    final id = r['commodity_id'] as int?;
    if (id == null) return null;
    (double, double)? range(Object? unit, Object? lo, Object? hi) {
      final kg = DamPriceService._kgPerUnit[unit];
      if (kg == null) return null;
      var a = _num(lo) / kg, b = _num(hi) / kg;
      if (a > b) (a, b) = (b, a);
      // DAM data has typing errors: drop empty or wild ranges.
      if (a <= 0 || b > a * 3) return null;
      return (a, b);
    }

    final r2 = range(r['unit_whole_sale'], r['avg_wholesale_lowestPrice'],
            r['avg_wholesale_highestPrice']) ??
        range(r['unit_retail'], r['avg_retail_lowestPrice'],
            r['avg_retail_howestPrice']); // sic: DAM's field name
    if (r2 == null) return null;
    return DamPrice(
      id,
      r2.$1,
      r2.$2,
      DateTime.tryParse('${r['created_at'] ?? ''}')?.toLocal(),
    );
  }
}

class DamException implements Exception {
  const DamException(this.code);
  final String code;
  @override
  String toString() => 'DamException($code)';
}
