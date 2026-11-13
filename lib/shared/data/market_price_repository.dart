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

  /// Admin only (enforced by rules).
  Future<void> set(String cropKey,
          {required num price, required num min, required num max, required num prevPrice}) =>
      _col.doc(cropKey).set({
        'price': price,
        'min': min,
        'max': max,
        'prevPrice': prevPrice,
        'updatedAt': FieldValue.serverTimestamp(),
      });
}

final marketPriceRepositoryProvider = Provider<MarketPriceRepository>(
    (ref) => MarketPriceRepository(ref.watch(firestoreProvider)));

final marketPricesProvider = StreamProvider<List<MarketPrice>>(
    (ref) => ref.watch(marketPriceRepositoryProvider).watchAll());

final marketPriceProvider = StreamProvider.family<MarketPrice?, String>(
    (ref, key) => ref.watch(marketPriceRepositoryProvider).watch(key));
