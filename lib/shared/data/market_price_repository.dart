import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/user_repository.dart';

/// Firestore: marketPrices/{cropKey} — typed in daily by Admin (A5).
class MarketPrice {
  const MarketPrice({
    required this.cropKey,
    required this.price,
    required this.min,
    required this.max,
    required this.prevPrice,
    this.updatedAt,
  });

  final String cropKey;
  final num price;
  final num min;
  final num max;
  final num prevPrice;
  final DateTime? updatedAt;

  /// Percent change vs previous price, e.g. 12 or -8.
  int get changePct =>
      prevPrice == 0 ? 0 : (((price - prevPrice) / prevPrice) * 100).round();

  factory MarketPrice.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    final price = m['price'] as num? ?? 0;
    return MarketPrice(
      cropKey: d.id,
      price: price,
      min: m['min'] as num? ?? price,
      max: m['max'] as num? ?? price,
      prevPrice: m['prevPrice'] as num? ?? price,
      updatedAt: (m['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}

class MarketPriceRepository {
  MarketPriceRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('marketPrices');

  Stream<List<MarketPrice>> watchAll() => _col
      .snapshots()
      .map((q) => [for (final d in q.docs) MarketPrice.fromDoc(d)]);

  Stream<MarketPrice?> watch(String cropKey) => _col
      .doc(cropKey)
      .snapshots()
      .map((d) => d.exists ? MarketPrice.fromDoc(d) : null);

  static String dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Admin only (enforced by rules). Saves the day's price in history;
  /// today's price also becomes the current price shown everywhere.
  Future<void> set(String cropKey,
      {required num price,
      required num min,
      required num max,
      required num prevPrice,
      DateTime? day}) async {
    final d = day ?? DateTime.now();
    final now = DateTime.now();
    final isToday =
        d.year == now.year && d.month == now.month && d.day == now.day;
    final b = _db.batch();
    b.set(_col.doc(cropKey).collection('history').doc(dayKey(d)), {
      'price': price,
      'min': min,
      'max': max,
      'date': Timestamp.fromDate(DateTime(d.year, d.month, d.day)),
    });
    if (isToday) {
      b.set(_col.doc(cropKey), {
        'price': price,
        'min': min,
        'max': max,
        'prevPrice': prevPrice,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await b.commit();
  }

  /// Last [days] days of history, oldest first.
  Stream<List<PricePoint>> watchHistory(String cropKey, int days) {
    final from = DateTime.now().subtract(Duration(days: days));
    return _col
        .doc(cropKey)
        .collection('history')
        .where('date',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(from.year, from.month, from.day)))
        .orderBy('date')
        .snapshots()
        .map((q) => [
              for (final d in q.docs)
                PricePoint(
                  (d.data()['date'] as Timestamp).toDate(),
                  d.data()['price'] as num? ?? 0,
                ),
            ]);
  }
}

/// One day's price (Price Trend 30).
class PricePoint {
  const PricePoint(this.date, this.price);
  final DateTime date;
  final num price;
}

final marketPriceRepositoryProvider = Provider<MarketPriceRepository>(
    (ref) => MarketPriceRepository(ref.watch(firestoreProvider)));

final marketPricesProvider = StreamProvider<List<MarketPrice>>(
    (ref) => ref.watch(marketPriceRepositoryProvider).watchAll());

final marketPriceProvider = StreamProvider.family<MarketPrice?, String>(
    (ref, key) => ref.watch(marketPriceRepositoryProvider).watch(key));

final priceHistoryProvider =
    StreamProvider.family<List<PricePoint>, (String, int)>((ref, k) =>
        ref.watch(marketPriceRepositoryProvider).watchHistory(k.$1, k.$2));
