import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../trade/data/payment_service.dart';
import '../../trade/data/trade_repository.dart';

enum ContractStatus {
  pending,
  active,
  rejected,
  cancelled,
  completed;

  static ContractStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => pending);

  bool get isClosed =>
      this == rejected || this == cancelled || this == completed;
}

/// One planned delivery. [orderId] is set when the buyer turns it into a
/// real order (payment, truck, OTP and rating then follow the order flow).
class ContractDelivery {
  const ContractDelivery(this.due, this.orderId);
  final DateTime due;
  final String? orderId;

  Map<String, dynamic> toMap() =>
      {'due': Timestamp.fromDate(due), 'orderId': orderId};

  factory ContractDelivery.fromMap(Map<String, dynamic> m) => ContractDelivery(
        (m['due'] as Timestamp?)?.toDate() ?? DateTime.now(),
        m['orderId'] as String?,
      );
}

/// Firestore: contracts/{id} — a buyer's fixed-price supply contract with a
/// farmer (38/39 farmer, 121–123 buyer). Term: 3 months.
class Contract {
  const Contract({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    this.buyerPhoto,
    required this.buyerVerified,
    required this.farmerId,
    required this.farmerName,
    this.farmerPhoto,
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    required this.grade,
    required this.quantityKg,
    required this.pricePerKg,
    required this.monthly,
    required this.pickup,
    required this.dropoff,
    required this.schedule,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String buyerId;
  final String buyerName;
  final String? buyerPhoto;
  final bool buyerVerified;
  final String farmerId;
  final String farmerName;
  final String? farmerPhoto;
  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String grade;

  /// Per delivery.
  final num quantityKg;
  final num pricePerKg;
  final bool monthly;
  final UserLocation pickup;
  final UserLocation dropoff;
  final List<ContractDelivery> schedule;
  final ContractStatus status;
  final DateTime? createdAt;

  String cropName(String lang) => lang == 'bn' ? cropNameBn : cropNameEn;
  DateTime get start => schedule.first.due;
  DateTime get end => schedule.last.due;
  int get doneCount => schedule.where((d) => d.orderId != null).length;

  factory Contract.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    final sched = [
      for (final e in (m['schedule'] as List? ?? const []))
        ContractDelivery.fromMap(Map<String, dynamic>.from(e as Map)),
    ];
    return Contract(
      id: d.id,
      buyerId: m['buyerId'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      buyerPhoto: m['buyerPhoto'] as String?,
      buyerVerified: m['buyerVerified'] as bool? ?? false,
      farmerId: m['farmerId'] as String? ?? '',
      farmerName: m['farmerName'] as String? ?? '',
      farmerPhoto: m['farmerPhoto'] as String?,
      cropKey: m['cropKey'] as String? ?? 'other',
      cropNameBn: m['cropNameBn'] as String? ?? '',
      cropNameEn: m['cropNameEn'] as String? ?? '',
      grade: m['grade'] as String? ?? 'A',
      quantityKg: m['quantityKg'] as num? ?? 0,
      pricePerKg: m['pricePerKg'] as num? ?? 0,
      monthly: m['monthly'] as bool? ?? true,
      pickup: UserLocation.fromMap(m['pickup'] as Map<String, dynamic>?),
      dropoff: UserLocation.fromMap(m['dropoff'] as Map<String, dynamic>?),
      schedule: sched.isEmpty
          ? [ContractDelivery(DateTime.now(), null)]
          : sched,
      status: ContractStatus.parse(m['status'] as String?),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ContractRepository {
  ContractRepository(this._db, this._trade, this._pay);
  final FirebaseFirestore _db;
  final TradeRepository _trade;
  final PaymentService _pay;

  static const termMonths = 3;
  static const weeklyCount = 12;
  static const firstDeliveryDays = 7;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('contracts');

  /// Delivery dates: monthly for 3 months, or weekly for 12 weeks,
  /// starting a week from [from].
  static List<DateTime> plan(bool monthly, DateTime from) {
    final first = DateTime(from.year, from.month, from.day)
        .add(const Duration(days: firstDeliveryDays));
    return monthly
        ? [
            for (var i = 0; i < termMonths; i++) _sameDay(first, i),
          ]
        : [
            for (var i = 0; i < weeklyCount; i++)
              first.add(Duration(days: 7 * i)),
          ];
  }

  /// Same day [months] later; 31 Jan + 1 → 28/29 Feb (not 3 Mar).
  static DateTime _sameDay(DateTime d, int months) {
    final last = DateTime(d.year, d.month + months + 1, 0).day;
    return DateTime(d.year, d.month + months, d.day > last ? last : d.day);
  }

  Stream<List<Contract>> _watch(String field, String uid) => _col
      .where(field, isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((q) => [for (final d in q.docs) Contract.fromDoc(d)]);

  Stream<List<Contract>> watchAsBuyer(String uid) => _watch('buyerId', uid);
  Stream<List<Contract>> watchAsFarmer(String uid) => _watch('farmerId', uid);

  Stream<Contract?> watch(String id) => _col
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? Contract.fromDoc(d) : null);

  /// 122: buyer sends a contract; farmer is notified.
  Future<String> create({
    required AppUser buyer,
    required AppUser farmer,
    required String cropKey,
    required String cropNameBn,
    required String cropNameEn,
    required String grade,
    required num quantityKg,
    required num pricePerKg,
    required bool monthly,
    DateTime? from,
  }) async {
    final ref = _col.doc();
    await ref.set({
      'buyerId': buyer.uid,
      'buyerName': buyer.name,
      'buyerPhoto': buyer.photoUrl,
      'buyerVerified': buyer.isVerified,
      'farmerId': farmer.uid,
      'farmerName': farmer.name,
      'farmerPhoto': farmer.photoUrl,
      'cropKey': cropKey,
      'cropNameBn': cropNameBn,
      'cropNameEn': cropNameEn,
      'grade': grade,
      'quantityKg': quantityKg,
      'pricePerKg': pricePerKg,
      'monthly': monthly,
      'pickup': farmer.location.toMap(),
      'dropoff': buyer.location.toMap(),
      'schedule': [
        for (final d in plan(monthly, from ?? DateTime.now()))
          ContractDelivery(d, null).toMap(),
      ],
      'status': ContractStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _trade.notify(
      toUid: farmer.uid,
      fromUid: buyer.uid,
      type: 'contract_new',
      params: {'buyer': buyer.name, 'cropBn': cropNameBn, 'cropEn': cropNameEn},
      link: 'contract:${ref.id}',
    );
    return ref.id;
  }

  Future<void> _setStatus(Contract c, ContractStatus s, String byUid) async {
    await _col.doc(c.id).update({
      'status': s.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    final toBuyer = byUid == c.farmerId;
    await _trade.notify(
      toUid: toBuyer ? c.buyerId : c.farmerId,
      fromUid: byUid,
      type: 'contract_${s.name}',
      params: {
        'name': toBuyer ? c.farmerName : c.buyerName,
        'cropBn': c.cropNameBn,
        'cropEn': c.cropNameEn,
      },
      link: 'contract:${c.id}',
    );
  }

  /// 39: farmer accepts / rejects (D2) a new contract.
  Future<void> accept(Contract c) =>
      _setStatus(c, ContractStatus.active, c.farmerId);
  Future<void> reject(Contract c) =>
      _setStatus(c, ContractStatus.rejected, c.farmerId);

  /// 123 / D3: either side stops the rest of the supply. Orders already
  /// made stay as they are.
  Future<void> cancel(Contract c, String byUid) =>
      _setStatus(c, ContractStatus.cancelled, byUid);

  /// 123: buyer turns delivery [i] into a real order at the contract price.
  Future<String> orderDelivery(Contract c, int i, AppUser buyer) async {
    final d = c.schedule[i];
    final pay = await _pay.holdForOrder(
      orderNo: c.id,
      amountBdt: c.quantityKg * c.pricePerKg,
      payerUid: buyer.uid,
    );
    if (!pay.success) throw Exception('payment');
    final order = await _trade.placeDemandOrder(
      buyer: buyer,
      src: OrderSource(
        contractId: c.id,
        farmerId: c.farmerId,
        farmerName: c.farmerName,
        cropKey: c.cropKey,
        cropNameBn: c.cropNameBn,
        cropNameEn: c.cropNameEn,
        grade: c.grade,
        pickup: c.pickup,
        pickupDate: d.due,
      ),
      quantityKg: c.quantityKg,
      pricePerKg: c.pricePerKg,
      dropoff: c.dropoff,
      paymentRef: 'contract:${pay.reference ?? ''}',
      notifyType: 'contract_order',
    );
    final sched = [
      for (var j = 0; j < c.schedule.length; j++)
        j == i
            ? ContractDelivery(c.schedule[j].due, order.id).toMap()
            : c.schedule[j].toMap(),
    ];
    final allDone = sched.every((e) => e['orderId'] != null);
    await _col.doc(c.id).update({
      'schedule': sched,
      if (allDone) 'status': ContractStatus.completed.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return order.id;
  }

  /// 123: buyer renews — same terms, a new term starting after the last
  /// delivery (a cancelled one starts from today). Farmer accepts again.
  Future<String> renew(Contract c, AppUser buyer, AppUser farmer) {
    final now = DateTime.now();
    final after = c.status != ContractStatus.cancelled && c.end.isAfter(now)
        ? c.end
        : now;
    return create(
      buyer: buyer,
      farmer: farmer,
      cropKey: c.cropKey,
      cropNameBn: c.cropNameBn,
      cropNameEn: c.cropNameEn,
      grade: c.grade,
      quantityKg: c.quantityKg,
      pricePerKg: c.pricePerKg,
      monthly: c.monthly,
      from: after,
    );
  }
}

final contractRepositoryProvider = Provider<ContractRepository>(
  (ref) => ContractRepository(
    ref.watch(firestoreProvider),
    ref.watch(tradeRepositoryProvider),
    ref.watch(paymentServiceProvider),
  ),
);

/// The signed-in user's contracts (as buyer or as farmer).
final myContractsProvider = StreamProvider<List<Contract>>((ref) {
  final me = ref.watch(currentUserProvider).value;
  if (me == null) return Stream.value(const []);
  final repo = ref.watch(contractRepositoryProvider);
  return me.role == UserRole.farmer
      ? repo.watchAsFarmer(me.uid)
      : repo.watchAsBuyer(me.uid);
});

final contractProvider = StreamProvider.family<Contract?, String>(
  (ref, id) => ref.watch(contractRepositoryProvider).watch(id),
);

/// Farmers a buyer can send a contract to (122).
final farmersProvider = StreamProvider<List<AppUser>>((ref) => ref
    .watch(firestoreProvider)
    .collection('users')
    .where('role', isEqualTo: 'farmer')
    .limit(100)
    .snapshots()
    .map((q) => [
          for (final d in q.docs) AppUser.fromDoc(d),
        ]..sort((a, b) => a.name.compareTo(b.name))));
