import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Number / money / date formatting that follows the app language.
/// Bangla mode shows Bangla digits (e.g. ৳ ৩৮/কেজি), as in Figma.
abstract final class Fmt {
  static const _bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

  static bool isBn(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'bn';

  /// Replace 0-9 with Bangla digits.
  static String bnDigits(String s) {
    final b = StringBuffer();
    for (final r in s.runes) {
      final c = String.fromCharCode(r);
      final d = int.tryParse(c);
      b.write(d == null ? c : _bn[d]);
    }
    return b.toString();
  }

  /// Convert Bangla digits back to 0-9 (for parsing user input).
  static String latinDigits(String s) {
    var out = s;
    for (var i = 0; i < 10; i++) {
      out = out.replaceAll(_bn[i], '$i');
    }
    return out;
  }

  static String digits(BuildContext context, String s) =>
      isBn(context) ? bnDigits(s) : s;

  /// 12500 → "12,500" / "১২,৫০০".
  static String number(BuildContext context, num n, {int decimals = 0}) {
    final f = NumberFormat.decimalPatternDigits(
        locale: 'en_US', decimalDigits: decimals);
    return digits(context, f.format(n));
  }

  /// 38 → "৳ 38" / "৳ ৩৮".
  static String taka(BuildContext context, num n) =>
      '৳ ${number(context, n)}';

  /// mm:ss timer, e.g. 45 → "0:45" / "০:৪৫".
  static String timer(BuildContext context, int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return digits(context, '$m:$s');
  }

  static String date(BuildContext context, DateTime d) {
    final loc = Localizations.localeOf(context).languageCode;
    return digits(context, DateFormat.yMMMd(loc).format(d));
  }
}
