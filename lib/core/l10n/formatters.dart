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

  /// Vehicle plate in the app's language: "DHA-METRO-T-12-3456" →
  /// "ঢাকা-মেট্রো-ট-১২-৩৪৫৬" in Bangla. The first part is the city, the
  /// part after it (or after METRO) the vehicle class letter; unknown parts
  /// stay as typed.
  static String plate(BuildContext context, String plate) {
    if (!isBn(context)) return plate;
    final parts = plate.split(RegExp(r'([-\s])'));
    final seps = RegExp(r'[-\s]').allMatches(plate).map((m) => m[0]!).toList();
    final out = StringBuffer();
    for (var i = 0; i < parts.length; i++) {
      final t = parts[i].toUpperCase();
      final mapped = i == 0
          ? _plateCity[t]
          : t == 'METRO'
          ? 'মেট্রো'
          : _plateClass[t];
      out.write(mapped ?? bnDigits(parts[i]));
      if (i < seps.length) out.write(seps[i]);
    }
    return out.toString();
  }

  static const _plateCity = {
    'DHA': 'ঢাকা',
    'DHAKA': 'ঢাকা',
    'CTG': 'চট্ট',
    'CHATTA': 'চট্ট',
    'KHU': 'খুলনা',
    'KHULNA': 'খুলনা',
    'RAJ': 'রাজ',
    'RAJSHAHI': 'রাজ',
    'SYL': 'সিলেট',
    'SYLHET': 'সিলেট',
    'BAR': 'বরিশাল',
    'BARISAL': 'বরিশাল',
    'MYM': 'ময়মনসিংহ',
    'RANG': 'রংপুর',
    'RANGPUR': 'রংপুর',
    'GAZ': 'গাজীপুর',
    'NAR': 'নারায়ণগঞ্জ',
    'COM': 'কুমিল্লা',
    'BOG': 'বগুড়া',
  };

  static const _plateClass = {
    'KA': 'ক',
    'KHA': 'খ',
    'GA': 'গ',
    'GHA': 'ঘ',
    'CHA': 'চ',
    'CHHA': 'ছ',
    'JA': 'জ',
    'JHA': 'ঝ',
    'TA': 'ত',
    'THA': 'থ',
    'T': 'ট',
    'TH': 'ঠ',
    'D': 'ড',
    'DA': 'দ',
    'DHA': 'ঢ',
    'NA': 'ন',
    'PA': 'প',
    'FA': 'ফ',
    'BA': 'ব',
    'BHA': 'ভ',
    'MA': 'ম',
    'LA': 'ল',
    'SHA': 'শ',
    'SA': 'স',
    'HA': 'হ',
    'U': 'উ',
    'E': 'এ',
  };

  /// 12500 → "12,500" / "১২,৫০০".
  static String number(BuildContext context, num n, {int decimals = 0}) {
    final f = NumberFormat.decimalPatternDigits(
      locale: 'en_US',
      decimalDigits: decimals,
    );
    return digits(context, f.format(n));
  }

  /// 38 → "৳ 38" / "৳ ৩৮".
  static String taka(BuildContext context, num n) => '৳ ${number(context, n)}';

  /// mm:ss timer, e.g. 45 → "0:45" / "০:৪৫".
  static String timer(BuildContext context, int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return digits(context, '$m:$s');
  }

  /// Figma style: "১২ সেপ্টেম্বর" (year only when not this year).
  static String date(BuildContext context, DateTime d) {
    final loc = Localizations.localeOf(context).languageCode;
    final pattern = d.year == DateTime.now().year ? 'd MMMM' : 'd MMMM y';
    return digits(context, DateFormat(pattern, loc).format(d));
  }

  /// "৮:২০" (24-hour, as elsewhere in the app).
  static String time(BuildContext context, DateTime d) =>
      digits(context, DateFormat('H:mm').format(d));

  /// Short month, always with year: "১২ অক্টো. ২০২৬" (207 papers).
  static String dateFull(BuildContext context, DateTime d) {
    final loc = Localizations.localeOf(context).languageCode;
    return digits(context, DateFormat('d MMM y', loc).format(d));
  }
}
