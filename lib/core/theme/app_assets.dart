/// Asset paths. Icons are exported from Figma page "DS – Icons" (24px stroke,
/// stroke colour #1F1F1F, recoloured at runtime). Images from "HF – Assets".
abstract final class AppIcons {
  static const _p = 'assets/icons';
  static const home = '$_p/home.svg';
  static const market = '$_p/market.svg';
  static const orders = '$_p/orders.svg';
  static const profile = '$_p/profile.svg';
  static const bell = '$_p/bell.svg';
  static const chat = '$_p/chat.svg';
  static const search = '$_p/search.svg';
  static const mic = '$_p/mic.svg';
  static const back = '$_p/back.svg';
  static const chevronRight = '$_p/chevron_right.svg';
  static const starOn = '$_p/star_on.svg';
  static const starOff = '$_p/star_off.svg';
  /// Transporter bottom-nav FAB (HF/Bottom Nav / Transporter, 292:263).
  static const loadBox = '$_p/load_box.svg';
  static const video = '$_p/video.svg';
  static const chevronDown = '$_p/chevron_down.svg';
  static const camera = '$_p/camera.svg';
  static const truck = '$_p/truck.svg';
  static const leaf = '$_p/leaf.svg';
  static const wallet = '$_p/wallet.svg';
  static const star = '$_p/star.svg';
  static const check = '$_p/check.svg';
  static const close = '$_p/close.svg';
  static const location = '$_p/location.svg';
  static const phone = '$_p/phone.svg';
  static const speaker = '$_p/speaker.svg';
  static const plus = '$_p/plus.svg';
  static const filter = '$_p/filter.svg';
  static const calendar = '$_p/calendar.svg';
  static const trendUp = '$_p/trend_up.svg';
  static const trendDown = '$_p/trend_down.svg';
  static const shield = '$_p/shield.svg';
  static const globe = '$_p/globe.svg';
  static const map = '$_p/map.svg';
  static const upload = '$_p/upload.svg';
  static const download = '$_p/download.svg';
  static const alert = '$_p/alert.svg';
  static const info = '$_p/info.svg';
  static const send = '$_p/send.svg';
  static const verified = '$_p/verified.svg';
  static const package = '$_p/package.svg';

  /// HF/App Bar back button (44×44 box, stroke 2).
  static const appBack = '$_p/app_back.svg';
}

abstract final class AppImages {
  static const _p = 'assets/images';
  static const splash = '$_p/splash.webp';
  static const splashThreeUsers = '$_p/splash_three_users.webp';
  static const splashIllustrationThreeUsers =
      '$_p/splash_illustration_three_users.webp';
  static const farmerField = '$_p/farmer_field.webp';
  static const buyerWarehouse = '$_p/buyer_warehouse.webp';
  static const truckRoad = '$_p/truck_road.webp';
  static const tomato = '$_p/tomato.webp';
  static const potato = '$_p/potato.webp';
  static const onion = '$_p/onion.webp';
  static const rice = '$_p/rice.webp';
  static const eggplant = '$_p/eggplant.webp';
  static const chili = '$_p/chili.webp';
  static const mango = '$_p/mango.webp';
  static const farmerM = '$_p/farmer_m.webp';
  static const farmerF = '$_p/farmer_f.webp';
  static const buyerP = '$_p/buyer_p.webp';
  static const driver = '$_p/driver.webp';
  static const map = '$_p/map.webp';
  static const scale = '$_p/scale.webp';
  static const port = '$_p/port.webp';
  static const handshake = '$_p/handshake.webp';

  // State screens: 41 Empty, 212 Error, 214 No Internet.
  static const stateEmpty = '$_p/state_empty.webp';
  static const stateError = '$_p/state_error.webp';
  static const stateOffline = '$_p/state_offline.webp';

  /// HF/Logo/Golaghor (599:9448), exported @3x (160×156 logical).
  static const logo = '$_p/logo_golaghor.webp';

  // Small UI images used inside HF screens.
  static const dotActive = '$_p/dot_active.webp';
  static const langIcon = '$_p/lang_icon.webp';
  static const cameraUpload = '$_p/camera_upload.webp';
  static const toastCheck = '$_p/ui/toast_check.webp';
  static const successCheck = '$_p/ui/success_check.webp';
  static const locationThumb = '$_p/location_thumb.webp';
  /// Static map art used before a map pin exists (screen 12).
  static const mapStrip = '$_p/map_strip.webp';
}

/// Figma HF – Assets images used inside screens (assets/images/ui).
abstract final class AppUi {
  static const _p = 'assets/images/ui';
  static const navOnHome = '$_p/nav_on_home.webp';
  static const navOffHome = '$_p/nav_off_home.webp';
  static const navOnMarket = '$_p/nav_on_market.webp';
  static const navOffMarket = '$_p/nav_off_market.webp';
  static const navOnOrders = '$_p/nav_on_orders.webp';
  static const navOffOrders = '$_p/nav_off_orders.webp';
  static const navOnProfile = '$_p/nav_on_profile.webp';
  static const navOffProfile = '$_p/nav_off_profile.webp';
  static const navOnWallet = '$_p/nav_on_wallet.webp';
  static const navOffWallet = '$_p/nav_off_wallet.webp';
  static const navOnTruck = '$_p/nav_on_truck.webp';
  static const navOffTruck = '$_p/nav_off_truck.webp';
  static const glyphLeaf = '$_p/glyph_leaf.webp';
  static const glyphList = '$_p/glyph_list.webp';
  static const glyphTrendUp = '$_p/glyph_trend_up.webp';
  static const glyphWallet = '$_p/glyph_wallet.webp';
  static const tileBell = '$_p/tile_bell.webp';
  static const tipClipboard = '$_p/tip_clipboard.webp';
  static const tipStar = '$_p/tip_star.webp';
  static const avatarFarmer = '$_p/avatar_farmer.webp';
  static const avatarBuyer = '$_p/avatar_buyer.webp';
  static const catAll = '$_p/cat_all.webp';
  static const catVegetable = '$_p/cat_vegetable.webp';
  static const catFruit = '$_p/cat_fruit.webp';
  static const catGrain = '$_p/cat_grain.webp';
  static const catSpice = '$_p/cat_spice.webp';
  static const glyphDemand = '$_p/glyph_demand.webp';
  static const glyphMarket = '$_p/glyph_market.webp';
  static const glyphTruck = '$_p/glyph_truck.webp';
  static const speaker = '$_p/speaker.webp';
  static const alertIcon = '$_p/alert_icon.webp';
  static const timelineDone = '$_p/timeline_done.webp';

  // Transporter (141).
  static const glyphBox = '$_p/glyph_box.webp';
  static const glyphMap = '$_p/glyph_map.webp';
  static const thumbTrip = '$_p/thumb_trip.webp';
  static const thumbLoad = '$_p/thumb_load.webp';
  static const avatarDriver = '$_p/avatar_driver.webp';
  // Chat composer (66): 44px voice + send buttons.
  static const chatVoice = '$_p/chat_voice.webp';
  static const chatSend = '$_p/chat_send.webp';

  // 216 Chat – attach file sheet: 44px option tiles.
  static const attachImage = '$_p/attach_img.webp';
  static const attachVideo = '$_p/attach_vid.webp';
  static const attachDoc = '$_p/attach_doc.webp';
}

abstract final class AppData {
  static const bdLocations = 'assets/data/bd_locations.json';
}
