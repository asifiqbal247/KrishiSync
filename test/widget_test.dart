import 'package:flutter_test/flutter_test.dart';
import 'package:krishisync/core/l10n/formatters.dart';
import 'package:krishisync/features/auth/presentation/phone_auth_controller.dart';

void main() {
  group('Fmt', () {
    test('Bangla digits round trip', () {
      expect(Fmt.bnDigits('৳ 38 / 12,500'), '৳ ৩৮ / ১২,৫০০');
      expect(Fmt.latinDigits('০১৭১২৩৪৫৬৭৮'), '01712345678');
    });
  });

  group('BdPhone', () {
    test('normalizes valid numbers', () {
      expect(BdPhone.normalizeLocal('01712345678'), '01712345678');
      expect(BdPhone.normalizeLocal('+8801712345678'), '01712345678');
      expect(BdPhone.normalizeLocal('০১৭১২-৩৪৫৬৭৮'), '01712345678');
      expect(BdPhone.toE164('01712345678'), '+8801712345678');
      expect(BdPhone.pretty('01712345678'), '01712-345678');
    });

    test('rejects invalid numbers', () {
      expect(BdPhone.normalizeLocal('0171234567'), isNull);
      expect(BdPhone.normalizeLocal('01212345678'), isNull);
      expect(BdPhone.normalizeLocal('abc'), isNull);
    });
  });
}
