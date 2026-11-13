import '../../core/theme/app_assets.dart';

enum CropCategory { vegetable, fruit, grain, other }

/// Reference list of crops shown as chips in Sell Crop (18) and used for
/// market prices. Like the location list, this is bundled reference data.
/// A listing stores cropKey + names, so "other" crops keep the typed name.
class Crop {
  const Crop(this.key, this.bn, this.en, this.category, this.image);
  final String key;
  final String bn;
  final String en;
  final CropCategory category;
  final String? image;

  String name(String lang) => lang == 'bn' ? bn : en;
}

abstract final class CropCatalog {
  static const other = 'other';

  /// Order = Figma chip order in screen 18.
  static const sellChips = <Crop>[
    Crop('tomato', 'টমেটো', 'Tomato', CropCategory.vegetable, AppImages.tomato),
    Crop('potato', 'আলু', 'Potato', CropCategory.vegetable, AppImages.potato),
    Crop('rice', 'ধান', 'Paddy', CropCategory.grain, AppImages.rice),
    Crop('eggplant', 'বেগুন', 'Eggplant', CropCategory.vegetable,
        AppImages.eggplant),
    Crop('onion', 'পেঁয়াজ', 'Onion', CropCategory.vegetable, AppImages.onion),
  ];

  static const extra = <Crop>[
    Crop('chili', 'মরিচ', 'Chili', CropCategory.vegetable, AppImages.chili),
    Crop('mango', 'আম', 'Mango', CropCategory.fruit, AppImages.mango),
  ];

  static const all = [...sellChips, ...extra];

  static Crop? byKey(String key) {
    for (final c in all) {
      if (c.key == key) return c;
    }
    return null;
  }

  static String? imageFor(String key) => byKey(key)?.image;
}
