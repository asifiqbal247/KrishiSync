import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../domain/delivery.dart';

String _lang(BuildContext c) => Localizations.localeOf(c).languageCode;

/// District name (falls back to upazila).
String districtOf(BuildContext context, UserLocation loc) {
  final d = BdPlace.display(loc.district, _lang(context));
  return d.isNotEmpty ? d : BdPlace.display(loc.upazila, _lang(context));
}

/// "Upazila, District" for detail rows.
String placeFull(BuildContext context, UserLocation loc) {
  final up = BdPlace.display(loc.upazila, _lang(context));
  final ds = BdPlace.display(loc.district, _lang(context));
  if (up.isEmpty) return ds;
  if (ds.isEmpty || up == ds) return up;
  return '$up, $ds';
}

/// "নেত্রকোনা → ঢাকা"
String routeOf(BuildContext context, Delivery d) =>
    AppLocalizations.of(context)
        .routeLine(districtOf(context, d.pickup), districtOf(context, d.dropoff));

/// 4500 kg → "৪.৫ টন"; small loads stay in kg ("৫০০ কেজি").
String tonsText(BuildContext context, num kg) {
  final l = AppLocalizations.of(context);
  if (kg < 1000) return qtyText(context, kg);
  final t = kg / 1000;
  return l.tonQty(Fmt.number(context, t, decimals: t == t.roundToDouble() ? 0 : 1));
}

String vehicleTypeLabel(AppLocalizations l, String key) => switch (key) {
      'pickup' => l.vt_pickup,
      'small_open' => l.vt_small_open,
      'medium_open' => l.vt_medium_open,
      'medium_covered' => l.vt_medium_covered,
      'large_open' => l.vt_large_open,
      'covered_van' => l.vt_covered_van,
      'refrigerated' => l.vt_refrigerated,
      _ => key,
    };

String deliveryStatusLabel(AppLocalizations l, DeliveryStatus s) =>
    switch (s) {
      DeliveryStatus.open => l.dsOpen,
      DeliveryStatus.assigned => l.dsAssigned,
      DeliveryStatus.pickedUp => l.dsPickedUp,
      DeliveryStatus.delivered => l.dsDelivered,
      DeliveryStatus.cancelled => l.orderStatusCancelled,
    };

/// Fare the driver earns: booked fare, else the suggestion.
num fareOf(Delivery d) => d.fare ?? d.suggestedFare;

/// Load row (143 / 141): truck photo, route, "crop · weight", fare.
class LoadTile extends StatelessWidget {
  const LoadTile({
    super.key,
    required this.d,
    required this.onTap,
    this.highlighted = false,
    this.withDate = false,
  });

  final Delivery d;
  final VoidCallback onTap;
  final bool highlighted;
  final bool withDate;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final crop = d.cropName(_lang(context));
    final qty = tonsText(context, d.weightKg);
    return KsListItem(
      thumb: Image.asset(AppUi.thumbLoad, fit: BoxFit.cover),
      title: routeOf(context, d),
      subtitle: withDate && d.pickupDate != null
          ? l.loadSubDate(crop, qty, Fmt.date(context, d.pickupDate!))
          : l.loadSub(crop, qty),
      trailingText: Fmt.taka(context, fareOf(d)),
      highlighted: highlighted,
      onTap: onTap,
    );
  }
}

/// Start of this week (Saturday, as on the 141 chart).
DateTime weekStart(DateTime now) {
  final day = DateTime(now.year, now.month, now.day);
  final back = (day.weekday - DateTime.saturday) % 7;
  return day.subtract(Duration(days: back));
}

/// Earnings per day Sat..Fri from delivered jobs this week.
List<num> weekEarnings(List<Delivery> jobs, DateTime now) {
  final start = weekStart(now);
  final out = List<num>.filled(7, 0);
  for (final j in jobs) {
    final at = j.timeline['delivered'];
    if (j.status != DeliveryStatus.delivered || at == null) continue;
    final i = DateTime(at.year, at.month, at.day).difference(start).inDays;
    if (i >= 0 && i < 7) out[i] += fareOf(j);
  }
  return out;
}

List<String> weekLabels(AppLocalizations l) =>
    [l.wdSat, l.wdSun, l.wdMon, l.wdTue, l.wdWed, l.wdThu, l.wdFri];

/// Open loads that start in [district] (return-load chances).
List<Delivery> returnLoads(List<Delivery> open, String? district) =>
    district == null
        ? const []
        : open.where((d) => d.pickup.district == district).toList();
