import 'package:material_ui/material_ui.dart';

/// Disposes text controllers used by a bottom sheet once its closing
/// animation is over. Disposing right after `await showModalBottomSheet`
/// can crash when the page behind rebuilds while the sheet is still
/// sliding away ("A TextEditingController was used after being disposed").
void disposeAfterSheet(List<ChangeNotifier> controllers) {
  Future<void>.delayed(const Duration(milliseconds: 600), () {
    for (final c in controllers) {
      c.dispose();
    }
  });
}
