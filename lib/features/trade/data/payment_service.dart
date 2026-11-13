import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Result of a payment attempt.
class PaymentResult {
  const PaymentResult({required this.success, this.reference});
  final bool success;
  final String? reference;
}

/// Payment gateway interface. Version 1 uses [PlaceholderPaymentService];
/// bKash / Nagad implementations plug in here in version 2.
abstract interface class PaymentService {
  /// Hold [amountBdt] in "safe payment" (escrow) for an order.
  Future<PaymentResult> holdForOrder({
    required String orderNo,
    required num amountBdt,
    required String payerUid,
  });
}

/// NOT A REAL PAYMENT. Marks the order as paid so the full trade flow can be
/// demonstrated. Replace with a real gateway before going live.
class PlaceholderPaymentService implements PaymentService {
  @override
  Future<PaymentResult> holdForOrder({
    required String orderNo,
    required num amountBdt,
    required String payerUid,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return PaymentResult(
        success: true,
        reference: 'PLACEHOLDER-$orderNo-${DateTime.now().millisecondsSinceEpoch}');
  }
}

final paymentServiceProvider =
    Provider<PaymentService>((_) => PlaceholderPaymentService());
