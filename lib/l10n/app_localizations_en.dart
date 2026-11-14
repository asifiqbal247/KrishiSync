// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Golaghor';

  @override
  String get splashTagline => 'With farming, by your side';

  @override
  String splashVersion(String version) {
    return 'Version $version';
  }

  @override
  String get langTitleBn => 'ভাষা নির্বাচন করুন';

  @override
  String get langTitleEn => 'Choose your language';

  @override
  String get langBangla => 'বাংলা';

  @override
  String get langBanglaSub => 'Bangla';

  @override
  String get langEnglish => 'English';

  @override
  String get langEnglishSub => 'ইংরেজি';

  @override
  String get langContinue => 'Continue';

  @override
  String get onb1Title => 'Sell directly to buyers';

  @override
  String get onb1Body =>
      'Get a fair price without middlemen. Set the price of your own crop.';

  @override
  String get onb2Title => 'Stay worry-free with safe payments';

  @override
  String get onb2Body =>
      'Farmers get paid when the goods are loaded; transporters get paid when they reach the buyer.';

  @override
  String get onb3Title => 'Easy trucks, hassle-free transport';

  @override
  String get onb3Body =>
      'Buyers book the truck. Both farmer and buyer can see where the truck is.';

  @override
  String get onbNext => 'Next';

  @override
  String get onbStart => 'Get started';

  @override
  String get onbSkip => 'Skip';

  @override
  String get loginTitle => 'Login / Sign up';

  @override
  String get loginHeading => 'Enter your mobile number';

  @override
  String get loginSub => 'We will send a 6-digit code';

  @override
  String get loginPhoneLabel => 'Mobile number';

  @override
  String get loginPhoneHint => '01X XXXX XXXX';

  @override
  String get loginCountryCode => '+880';

  @override
  String get loginTerms =>
      'By continuing you agree to the Terms and Privacy Policy.';

  @override
  String get loginSendCode => 'Send code';

  @override
  String get loginInvalidPhone => 'Enter a valid 11-digit mobile number';

  @override
  String get otpTitle => 'Verify code';

  @override
  String get otpHeading => 'Enter code';

  @override
  String otpSub(String phone) {
    return 'Enter the 6-digit code sent to $phone';
  }

  @override
  String get otpNoCode => 'Didn\'t get a code?';

  @override
  String otpResendIn(String time) {
    return 'Resend ($time)';
  }

  @override
  String get otpResend => 'Resend';

  @override
  String get otpVerify => 'Verify';

  @override
  String get otpWrong => 'The code is not correct. Please try again.';

  @override
  String get roleTitle => 'Who are you?';

  @override
  String get roleSub => 'Tap your role';

  @override
  String get roleFarmer => 'Farmer';

  @override
  String get roleFarmerSub => 'Sell crops, find buyers';

  @override
  String get roleBuyer => 'Buyer (Business)';

  @override
  String get roleBuyerSub => 'Buy crops, source supply';

  @override
  String get roleTransporter => 'Transporter';

  @override
  String get roleTransporterSub => 'Find loads, complete trips';

  @override
  String get roleModerator => 'Moderator';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get profileSetupTitle => 'Create profile';

  @override
  String get profileAddPhoto => 'Add profile photo';

  @override
  String get profileFullName => 'Full name';

  @override
  String get profileFullNameHint => 'Enter your name';

  @override
  String get profileDivision => 'Division';

  @override
  String get profileDistrictUpazilaUnion => 'District › Upazila › Union';

  @override
  String get profileVillage => 'Village / Para';

  @override
  String get profileVillageHint => 'Type a name or drop a pin on the map';

  @override
  String get profileNid => 'NID number (optional)';

  @override
  String get profileNidHint => 'For verification';

  @override
  String get profileDone => 'Done';

  @override
  String get selectHint => 'Select';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonRequired => 'Please fill this in';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'No internet connection';

  @override
  String get errorUpload => 'Photo upload failed. Please try again.';

  @override
  String get errorPermission => 'You don\'t have permission for this';

  @override
  String get unitKg => 'kg';

  @override
  String get currencySymbol => '৳';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get locTitleDivision => 'Choose area';

  @override
  String get locTitleDistrict => 'Choose district';

  @override
  String get locTitleUpazila => 'Choose upazila';

  @override
  String get locTitleVillage => 'Village & address';

  @override
  String get locUseGps => 'Use my current location';

  @override
  String get locGps => 'GPS';

  @override
  String get locGpsLocating => 'Finding your location…';

  @override
  String get locGpsFailed =>
      'Could not get your location. Turn on location and try again.';

  @override
  String get locRecent => 'Recent addresses';

  @override
  String get locMapPinSaved => 'map pin saved';

  @override
  String get locSearchAll => 'Search division, district, upazila or village';

  @override
  String get locSearchDistrict => 'Search district';

  @override
  String get locSearchUpazila => 'Search upazila';

  @override
  String locStep(String step, String total, String level) {
    return 'Step $step/$total · $level';
  }

  @override
  String get locLevelDivision => 'Division';

  @override
  String get locLevelDistrict => 'District';

  @override
  String get locLevelUpazila => 'Upazila';

  @override
  String get locLevelUnionVillage => 'Union & village';

  @override
  String locDivisionPill(String name) {
    return '$name Division';
  }

  @override
  String locDistrictCount(String count) {
    return 'Districts: $count';
  }

  @override
  String locUpazilaCount(String count) {
    return 'Upazilas: $count';
  }

  @override
  String get locUnionLabel => 'Union / Municipality';

  @override
  String get locUnionHint => 'Choose from list';

  @override
  String get locVillageLabel => 'Village / Para / Mohalla';

  @override
  String get locVillageHint => 'Type the name or say it';

  @override
  String get locLandmarkLabel => 'Landmark (optional)';

  @override
  String get locLandmarkHint =>
      'e.g. next to the bazaar, in front of the school';

  @override
  String get locWhyTitle => 'Why the exact address matters';

  @override
  String get locWhyBody =>
      'The truck reaches the right place, and nearby buyers and loads match.';

  @override
  String get locSaveAs => 'Save this address (pick it with one tap later)';

  @override
  String get locTagHome => 'Home';

  @override
  String get locTagFarm => 'Farm';

  @override
  String get locTagStore => 'Warehouse';

  @override
  String get locTagOther => 'Other';

  @override
  String get locConfirm => 'Confirm this address';

  @override
  String get locNoResults => 'Nothing found';

  @override
  String get photoCamera => 'Take a photo';

  @override
  String get photoGallery => 'Choose from gallery';

  @override
  String get homeComingSoon => 'This section is being built';

  @override
  String get logout => 'Log out';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get greetingMorning => 'Good morning,';

  @override
  String get greetingAfternoon => 'Good afternoon,';

  @override
  String get greetingEvening => 'Good evening,';

  @override
  String get navHome => 'Home';

  @override
  String get navMarket => 'Market';

  @override
  String get navSell => 'Sell';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Profile';

  @override
  String get navListings => 'Listings';

  @override
  String get navReports => 'Reports';

  @override
  String get navVerify => 'Verify';

  @override
  String get farmerSearchHint => 'Search crops, buyers or areas';

  @override
  String homeNewOffers(String count) {
    return 'New offers: $count';
  }

  @override
  String get homeSee => 'See';

  @override
  String get homeTodayPrices => 'Today\'s market prices';

  @override
  String get homeWhatToDo => 'What do you want to do?';

  @override
  String get homeSellCrop => 'Sell crop';

  @override
  String get homeSellCropSub => 'List in 2 minutes';

  @override
  String get homeMyListings => 'My listings';

  @override
  String homeMyListingsSub(String count) {
    return 'Active listings: $count';
  }

  @override
  String get homeBuyerDemand => 'Buyer demand';

  @override
  String get homeBuyerDemandSub => 'See nearby demand';

  @override
  String get homePayments => 'Payments';

  @override
  String homePaymentsSub(String amount) {
    return '$amount this month';
  }

  @override
  String get homeOngoingOrders => 'Ongoing orders';

  @override
  String get homeBannerExportTitle => 'Sell crops abroad';

  @override
  String get homeBannerExportSub => 'Export guide and foreign buyers';

  @override
  String get homeTips => 'Farming tips';

  @override
  String get tipBetterPrice => 'How to get a better price';

  @override
  String get tipPackaging => 'Packaging tips';

  @override
  String get tipGrading => 'Understanding grades';

  @override
  String tipListen(String time) {
    return 'Listen · $time';
  }

  @override
  String pricePerKg(String price) {
    return '$price/kg';
  }

  @override
  String get sellTitle => 'Sell crop';

  @override
  String get sellStep1 => 'Crop info';

  @override
  String get sellStep2 => 'Price & place';

  @override
  String get sellStep3 => 'Confirm';

  @override
  String get sellChooseCrop => 'Choose crop';

  @override
  String get sellOtherCropHint => 'Type the crop name';

  @override
  String get sellGrade => 'Quality (grade)';

  @override
  String gradeLabel(String grade) {
    return 'Grade $grade';
  }

  @override
  String get sellQuantity => 'Quantity';

  @override
  String get sellAddPhoto => 'Take a photo of the crop';

  @override
  String get sellPrice => 'Price (per kg)';

  @override
  String get sellPriceUnit => '৳/kg';

  @override
  String sellMarketRange(String min, String max) {
    return 'Today\'s market price: ৳ $min–$max / kg';
  }

  @override
  String get sellAvailableFrom => 'Available from';

  @override
  String get sellToday => 'Today';

  @override
  String get sellTomorrow => 'Tomorrow';

  @override
  String get sellPickDate => 'Pick a date';

  @override
  String get sellPickup => 'Pickup address';

  @override
  String get sellNext => 'Next';

  @override
  String get sellEdit => 'Edit';

  @override
  String get sellPublish => 'Publish';

  @override
  String get fieldCrop => 'Crop';

  @override
  String get fieldQuantity => 'Quantity';

  @override
  String get fieldPrice => 'Price';

  @override
  String get fieldAvailability => 'Availability';

  @override
  String get fieldPickup => 'Pickup';

  @override
  String get fieldMyPrice => 'My price';

  @override
  String get fieldMarketPrice => 'Market price';

  @override
  String qtyKg(String qty) {
    return '$qty kg';
  }

  @override
  String priceLine(String price) {
    return '৳ $price / kg';
  }

  @override
  String rangeLine(String min, String max) {
    return '৳ $min–$max / kg';
  }

  @override
  String availableFromDate(String date) {
    return 'From $date';
  }

  @override
  String cropWithGrade(String crop, String grade) {
    return '$crop (Grade $grade)';
  }

  @override
  String get errPhotoRequired => 'Add a photo of the crop';

  @override
  String get errQtyInvalid => 'Enter a valid quantity';

  @override
  String get errPriceInvalid => 'Enter a valid price';

  @override
  String get listingSuccessTitle => 'Crop added to your listings!';

  @override
  String get listingSuccessBody =>
      'Buyers can see your crop and make offers after a moderator approves it.';

  @override
  String get listingSuccessCta => 'See my listings';

  @override
  String get myListingsTitle => 'My listings';

  @override
  String get tabOngoing => 'Ongoing';

  @override
  String get tabSold => 'Sold';

  @override
  String get tabDraft => 'Draft';

  @override
  String get emptyFilter => 'Nothing in this filter yet';

  @override
  String get addNewCrop => '+ Add a new crop';

  @override
  String get statusPending => 'Waiting for approval';

  @override
  String get statusActive => 'Active';

  @override
  String get statusSold => 'Sold';

  @override
  String get statusHidden => 'Rejected';

  @override
  String listingSubtitle(String qty, String price) {
    return '$qty kg · ৳ $price/kg';
  }

  @override
  String get cropDetailsTitle => 'Crop details';

  @override
  String seeBuyerOffers(String count) {
    return 'See buyer offers ($count)';
  }

  @override
  String moderationNote(String note) {
    return 'Moderator note: $note';
  }

  @override
  String get markSold => 'Mark as sold';

  @override
  String get modHomeQueue => 'Listings waiting for approval';

  @override
  String get modStatPending => 'Pending listings';

  @override
  String get modStatActive => 'Active listings';

  @override
  String get modStatHidden => 'Rejected listings';

  @override
  String get modListingsTitle => 'Review listings';

  @override
  String get modReviewTitle => 'Review listing';

  @override
  String get modFarmer => 'Farmer';

  @override
  String get modApprove => 'Approve';

  @override
  String get modReject => 'Reject';

  @override
  String get modRejectReasonTitle => 'Reason for rejecting';

  @override
  String get modRejectReasonHint => 'e.g. blurry photo, unusual price';

  @override
  String get modApproved => 'Listing approved';

  @override
  String get modRejected => 'Listing rejected';

  @override
  String get modQueueEmpty => 'No listings waiting';

  @override
  String submittedOn(String date) {
    return 'Submitted: $date';
  }

  @override
  String get cropOther => 'Other';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileRole => 'Role';

  @override
  String get profilePhone => 'Mobile number';

  @override
  String get tabComingTitle => 'This section is coming in the next step';

  @override
  String get navCollect => 'Orders';

  @override
  String get navDemand => 'Demand';

  @override
  String get buyerSearchHint => 'Search crops, farmers or areas';

  @override
  String get statOngoingOrders => 'Ongoing orders';

  @override
  String get statInTransit => 'On the way';

  @override
  String get statSafePay => 'In safe payment';

  @override
  String get statNewOffers => 'New offers';

  @override
  String countTi(String count) {
    return '$count';
  }

  @override
  String get catAll => 'All';

  @override
  String get catVegetable => 'Vegetables';

  @override
  String get catFruit => 'Fruit';

  @override
  String get catGrain => 'Grains';

  @override
  String get catFish => 'Fish';

  @override
  String get catSpice => 'Spices';

  @override
  String get catPulse => 'Pulses';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get actPostDemand => 'Post a demand';

  @override
  String get actPostDemandSub => 'Farmers will send offers';

  @override
  String get actMarket => 'Market';

  @override
  String actMarketSub(String count) {
    return 'Crops: $count';
  }

  @override
  String get actProcurement => 'Procurement dashboard';

  @override
  String get actProcurementSub => 'Demand and sourcing';

  @override
  String get actBookTruck => 'Book a truck';

  @override
  String get actBookTruckSub => 'Compare fares and book';

  @override
  String get bannerPoolTitle => 'New: digital pooling';

  @override
  String get bannerPoolSub => 'Big orders from several farmers';

  @override
  String get bannerTry => 'Try it';

  @override
  String get topSuppliers => 'Top suppliers';

  @override
  String get recommendedCrops => 'Recommended crops for you';

  @override
  String onTimePct(String pct) {
    return '$pct% on time';
  }

  @override
  String get marketTitle => 'Market';

  @override
  String get marketSearchHint => 'Search crops, areas or farmers';

  @override
  String resultsCount(String count) {
    return 'Results: $count';
  }

  @override
  String get filterLabel => 'Filter: area, quantity, price';

  @override
  String listingLine(String qty, String place) {
    return '$qty kg · $place';
  }

  @override
  String listingLineRated(String qty, String place, String rating) {
    return '$qty kg · $place · $rating';
  }

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterDistrict => 'Area (district)';

  @override
  String get filterAnyDistrict => 'All districts';

  @override
  String get filterMinQty => 'Minimum quantity';

  @override
  String get filterMaxPrice => 'Maximum price (per kg)';

  @override
  String get filterApply => 'Apply filter';

  @override
  String get filterClear => 'Clear';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Potato, tomato, area…';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearRecent => 'Clear';

  @override
  String get popularNow => 'Popular now';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get voiceGuide => 'Press the mic and say the crop name';

  @override
  String suggestListings(String count) {
    return 'Listings: $count';
  }

  @override
  String suggestListingsRange(String count, String min, String max) {
    return 'Listings: $count · ৳ $min–$max';
  }

  @override
  String get noResults => 'No crops found';

  @override
  String marketRangeFair(String min, String max) {
    return 'Market price ৳ $min–$max / kg · within a fair price';
  }

  @override
  String marketRangeOnly(String min, String max) {
    return 'Market price ৳ $min–$max / kg';
  }

  @override
  String qtyAvailable(String qty) {
    return '$qty kg available';
  }

  @override
  String get fieldAvailable => 'Available';

  @override
  String get fieldLocation => 'Location';

  @override
  String placeWithKm(String place, String km) {
    return '$place ($km km)';
  }

  @override
  String get sectionFarmer => 'Farmer';

  @override
  String get sectionDelivery => 'Delivery & transport';

  @override
  String get fieldPayment => 'Payment';

  @override
  String get safePayment => 'Safe payment';

  @override
  String reviewsCount(String count) {
    return 'Reviews ($count)';
  }

  @override
  String get similarCrops => 'Similar crops';

  @override
  String get makeOffer => 'Make offer';

  @override
  String get placeOrder => 'Order';

  @override
  String farmerCardSub(String verified, String rating, String count) {
    return '${verified}Rating $rating · $count trades';
  }

  @override
  String get verifiedDot => 'Verified · ';

  @override
  String get profileLink => 'Profile';

  @override
  String get farmerProfileTitle => 'Farmer profile';

  @override
  String get verifiedNid => 'Verified (NID)';

  @override
  String get notVerified => 'Not verified yet';

  @override
  String get statRating => 'Rating';

  @override
  String get statOnTime => 'On-time delivery';

  @override
  String get statCompleted => 'Completed trades';

  @override
  String get statComplaints => 'Quality complaints';

  @override
  String ratingWithCount(String rating, String count) {
    return '$rating ($count)';
  }

  @override
  String get availableCrops => 'Available crops';

  @override
  String get sendMessage => 'Send message';

  @override
  String get notAvailable => '—';

  @override
  String qtyTon(String t) {
    return '$t t';
  }

  @override
  String get backToHome => 'Home';

  @override
  String get offerTitle => 'Make an offer';

  @override
  String get offerYourPrice => 'Your price';

  @override
  String get offerDeliveryDate => 'Delivery date';

  @override
  String get offerTotal => 'Total price';

  @override
  String get offerSend => 'Send offer';

  @override
  String get offerSent => 'Offer sent';

  @override
  String farmerQty(String farmer, String qty) {
    return '$farmer · $qty';
  }

  @override
  String get offersTitle => 'Buyer offers';

  @override
  String get offerTabAll => 'All';

  @override
  String get offerTabNew => 'New';

  @override
  String get offerTabTalking => 'Negotiating';

  @override
  String marketRangeShort(String min, String max) {
    return 'Market price: ৳ $min–$max / kg';
  }

  @override
  String buyerVerifiedRating(String rating) {
    return 'Verified · Rating $rating';
  }

  @override
  String buyerRating(String rating) {
    return 'Rating $rating';
  }

  @override
  String newBuyerQty(String qty) {
    return 'New buyer · $qty';
  }

  @override
  String pricePerKgShort(String price) {
    return '৳ $price/kg';
  }

  @override
  String get negotiateTitle => 'Negotiate';

  @override
  String get rowBuyer => 'Buyer';

  @override
  String get rowFarmer => 'Farmer';

  @override
  String verifiedSuffix(String name) {
    return '$name (Verified)';
  }

  @override
  String get rowBuyerOffer => 'Buyer\'s offer';

  @override
  String get rowFarmerCounter => 'Farmer\'s counter';

  @override
  String get rowMyOffer => 'My offer';

  @override
  String get rowOfferValidity => 'Offer valid';

  @override
  String hoursLeft(String h) {
    return 'Hours left: $h';
  }

  @override
  String get offerExpired => 'Expired';

  @override
  String get paymentSafeLoad => 'Safe payment · paid when loaded';

  @override
  String get counterLabel => 'Make a counter offer';

  @override
  String get reject => 'Reject';

  @override
  String get counter => 'Counter';

  @override
  String get acceptOffer => 'Accept offer';

  @override
  String get rejectConfirmTitle => 'Reject this?';

  @override
  String get rejectConfirmBody =>
      'The other side will be told. It can\'t be accepted later, but they can send a new offer.';

  @override
  String get noGoBack => 'No, go back';

  @override
  String get yesReject => 'Yes, reject';

  @override
  String get offerAcceptedTitle => 'Offer accepted!';

  @override
  String get offerAcceptedBody =>
      'The order is confirmed when the buyer pays. You will be notified.';

  @override
  String get seeOrder => 'See order';

  @override
  String get counterSent => 'Counter offer sent';

  @override
  String get offerRejected => 'Offer rejected';

  @override
  String get offerStatusPending => 'New';

  @override
  String get offerStatusCountered => 'Negotiating';

  @override
  String get offerStatusAccepted => 'Accepted';

  @override
  String get offerStatusRejected => 'Rejected';

  @override
  String get offerStatusWithdrawn => 'Withdrawn';

  @override
  String get orderNowFromOffer => 'Order at this price';

  @override
  String get placeOrderTitle => 'Confirm order';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String cropQtyTitle(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String farmerPrice(String farmer, String price) {
    return '$farmer · ৳ $price/kg';
  }

  @override
  String get platformTruck => 'Platform truck';

  @override
  String get platformTruckSub => 'Automatic transport booking';

  @override
  String get selfTransport => 'I will transport it myself';

  @override
  String get rowCropPrice => 'Crop price';

  @override
  String get rowTransport => 'Transport';

  @override
  String rowPlatformFee(String pct) {
    return 'Platform fee ($pct%)';
  }

  @override
  String get rowTotal => 'Total';

  @override
  String get payWithSafe => 'Pay with safe payment';

  @override
  String get orderPlacedTitle => 'Order confirmed!';

  @override
  String get orderPlacedBody =>
      'Your money is held safely. The farmer is paid when the goods are loaded.';

  @override
  String get errQtyTooMuch => 'More than the available quantity';

  @override
  String get errAddressRequired => 'Add a delivery address';

  @override
  String get ordersTitle => 'My orders';

  @override
  String get ordersTabAll => 'All';

  @override
  String get ordersTabOngoing => 'Ongoing';

  @override
  String get ordersTabDone => 'Done';

  @override
  String get ordersTabCancelled => 'Cancelled';

  @override
  String qtyPrice(String qty, String price) {
    return '$qty · ৳ $price/kg';
  }

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusTransportBooked => 'Truck booked';

  @override
  String get orderStatusPickedUp => 'Loaded';

  @override
  String get orderStatusInTransit => 'On the way';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderDetailsTitle => 'Order details';

  @override
  String orderNoLine(String no) {
    return 'Order #$no';
  }

  @override
  String get rowPayment => 'Payment';

  @override
  String get paymentHeld => 'Held in safe payment';

  @override
  String get paymentPending => 'Pending';

  @override
  String get rowLoadAndMoney => 'Loading + your money';

  @override
  String get rowPickupDate => 'Pickup';

  @override
  String get orderStatusSection => 'Order status';

  @override
  String get stepConfirmed => 'Order confirmed';

  @override
  String get stepTruckBooked => 'Buyer booked a truck';

  @override
  String get stepTruckBookedSelf => 'Buyer will transport';

  @override
  String get stepLoaded => 'Loaded + your money';

  @override
  String get stepLoadedBuyer => 'Loaded + farmer paid';

  @override
  String get stepDelivered => 'Delivery';

  @override
  String get stepWaiting => 'Waiting';

  @override
  String get orderProblem => 'Problem with the order?';

  @override
  String get orderProblemSub => 'Report a problem or get help';

  @override
  String get trackShipment => 'Track shipment';

  @override
  String dateTime(String date, String time) {
    return '$date, $time';
  }

  @override
  String get notifTitle => 'Notifications';

  @override
  String get notifEmpty => 'No notifications';

  @override
  String nOfferNew(String crop) {
    return 'New offer: $crop';
  }

  @override
  String nOfferNewBody(String buyer, String price, String qty) {
    return '$buyer · ৳ $price/kg · $qty';
  }

  @override
  String nOfferCounter(String crop) {
    return 'Counter offer: $crop';
  }

  @override
  String nOfferCounterBody(String farmer, String price) {
    return '$farmer · ৳ $price/kg';
  }

  @override
  String nOfferAccepted(String crop) {
    return 'Offer accepted: $crop';
  }

  @override
  String nOfferAcceptedBody(String price) {
    return 'Order at ৳ $price/kg';
  }

  @override
  String nOfferRejected(String crop) {
    return 'Offer rejected: $crop';
  }

  @override
  String nOrderNew(String no) {
    return 'New order #$no';
  }

  @override
  String nOrderNewBody(String buyer, String crop, String qty) {
    return '$buyer · $crop $qty';
  }

  @override
  String nListingApproved(String crop) {
    return 'Listing approved: $crop';
  }

  @override
  String nListingRejected(String crop) {
    return 'Listing rejected: $crop';
  }

  @override
  String get nListingApprovedBody => 'Buyers can now see your crop';

  @override
  String homeOffersSub(String crop, String price) {
    return '$crop · up to ৳ $price/kg';
  }

  @override
  String get stateErrorTitle => 'Something went wrong';

  @override
  String get stateErrorBody =>
      'The information you entered is not correct. Please try again.';

  @override
  String get stateGetHelp => 'Get help';

  @override
  String get stateOfflineBody =>
      'Your data is saved. It will be sent automatically when you are back online.';

  @override
  String get emptyOrdersTitle => 'No orders yet';

  @override
  String get emptyOrdersFarmerBody =>
      'List your crops and buyers will send offers.';

  @override
  String get emptyOrdersBuyerBody =>
      'Order the crops you like from the market.';

  @override
  String get emptyOrdersBuyerCta => 'Go to market';

  @override
  String get rowMyCounter => 'My counter offer';

  @override
  String get rowOfferStatus => 'Status';

  @override
  String get navTrip => 'Trips';

  @override
  String get navLoad => 'Loads';

  @override
  String get navEarnings => 'Earnings';

  @override
  String get trStatToday => 'Today\'s earnings';

  @override
  String get trStatOngoing => 'Ongoing trips';

  @override
  String trOngoingTitle(String no) {
    return 'Ongoing: $no';
  }

  @override
  String trOngoingSub(String n, String status) {
    return '$n pickup · $status';
  }

  @override
  String get trContinue => 'Continue';

  @override
  String get trWhatToDo => 'What do you want to do?';

  @override
  String get trFindLoads => 'Find loads';

  @override
  String trFindLoadsSub(String n) {
    return 'Loads nearby: $n';
  }

  @override
  String get trMyJobs => 'My jobs';

  @override
  String trMyJobsSub(String n) {
    return 'Jobs: $n';
  }

  @override
  String get trReturnLoads => 'Return loads';

  @override
  String get trReturnLoadsSub => 'Don\'t return empty';

  @override
  String get trEarnings => 'Earnings';

  @override
  String trEarningsSub(String amount) {
    return 'This week $amount';
  }

  @override
  String get trNearbyLoads => 'Loads near you';

  @override
  String get seeAllLink => 'See all';

  @override
  String get trReturnChances => 'Return load chances';

  @override
  String get trWeekEarnings => 'This week\'s earnings';

  @override
  String get trThisWeek => 'This week';

  @override
  String get trPendingPay => 'Pending';

  @override
  String get wdSat => 'Sat';

  @override
  String get wdSun => 'Sun';

  @override
  String get wdMon => 'Mon';

  @override
  String get wdTue => 'Tue';

  @override
  String get wdWed => 'Wed';

  @override
  String get wdThu => 'Thu';

  @override
  String get wdFri => 'Fri';

  @override
  String routeLine(String from, String to) {
    return '$from → $to';
  }

  @override
  String loadSub(String crop, String qty) {
    return '$crop · $qty';
  }

  @override
  String loadSubDate(String crop, String qty, String date) {
    return '$crop · $qty · $date';
  }

  @override
  String get noLoads => 'No loads right now';

  @override
  String takaAmount(String amount) {
    return '৳ $amount';
  }

  @override
  String get vehicleNeeded => 'Add your vehicle to take loads';

  @override
  String get loadsTitle => 'Available loads';

  @override
  String get filterAll => 'All';

  @override
  String get filterNearby => 'Nearby';

  @override
  String get filterFullLoad => 'Full load';

  @override
  String get filterMultiPickup => 'Multiple pickups';

  @override
  String get loadDetailsTitle => 'Load details';

  @override
  String get rowGoods => 'Goods';

  @override
  String get rowDestination => 'Destination';

  @override
  String get rowDistance => 'Distance';

  @override
  String distanceLine(String km, String h) {
    return '$km km · ~$h h';
  }

  @override
  String get rowFare => 'Fare';

  @override
  String fareSafeLine(String amount) {
    return '$amount (safe payment)';
  }

  @override
  String get rowCustomer => 'Customer';

  @override
  String nameVerified(String name) {
    return '$name · verified';
  }

  @override
  String placeDate(String place, String date) {
    return '$place · $date';
  }

  @override
  String fitsTruck(String cap) {
    return 'Fits your truck: $cap capacity';
  }

  @override
  String tooBigTruck(String cap) {
    return 'Your truck holds $cap — this load is more';
  }

  @override
  String tonQty(String t) {
    return '$t ton';
  }

  @override
  String get sendFareOffer => 'Offer a fare';

  @override
  String get acceptJob => 'Accept job';

  @override
  String myBidLine(String amount) {
    return 'Your offer: $amount · waiting for the buyer';
  }

  @override
  String get bidSent => 'Offer sent';

  @override
  String get loadTaken => 'Another driver got this load';

  @override
  String get fareOfferTitle => 'Offer a fare';

  @override
  String get suggestedFareRow => 'Suggested fare (platform)';

  @override
  String takaRange(String min, String max) {
    return '৳ $min–$max';
  }

  @override
  String get otherBidsRow => 'Other offers';

  @override
  String otherBidsLine(String n, String amount) {
    return '$n · lowest $amount';
  }

  @override
  String get noneYet => 'None yet';

  @override
  String get yourFare => 'Your fare';

  @override
  String get fareNote =>
      'The job is confirmed when the buyer picks your offer and pays into safe payment. The fare can\'t change after that.';

  @override
  String get sendProposal => 'Send offer';

  @override
  String get errFareInvalid => 'Enter a valid fare';

  @override
  String get myJobsTitle => 'My jobs';

  @override
  String get jobsToday => 'Today';

  @override
  String get jobsUpcoming => 'Upcoming';

  @override
  String get jobsDone => 'Done';

  @override
  String jobTitle(String no, String crop, String qty) {
    return '$no · $crop $qty';
  }

  @override
  String get badgeRunning => 'Running';

  @override
  String get badgeScheduled => 'Scheduled';

  @override
  String get badgeDone => 'Done';

  @override
  String get noJobs => 'No jobs';

  @override
  String get scheduleTitle => 'Pickup schedule';

  @override
  String get rowJob => 'Job';

  @override
  String get rowTotalStops => 'Total stops';

  @override
  String get stopsOne => '1 pickup + 1 delivery';

  @override
  String get pickupOrder => 'Pickup order';

  @override
  String stopN(String n, String name) {
    return '$n. $name';
  }

  @override
  String stopSub(String place, String qty, String date) {
    return '$place · $qty · $date';
  }

  @override
  String get stopDelivery => 'Delivery';

  @override
  String get seeRoute => 'See route';

  @override
  String get tripStatusTitle => 'Trip status';

  @override
  String freeSpaceTitle(String t) {
    return '$t ton free on your truck';
  }

  @override
  String get freeSpaceSub => 'Loads on your route · separate fare';

  @override
  String get seeLink => 'See';

  @override
  String stepPickupN(String n, String name) {
    return 'Pickup $n – $name';
  }

  @override
  String get stepLoadedDone => 'Loaded';

  @override
  String stepDeliveryTo(String name) {
    return 'Delivery – $name';
  }

  @override
  String get offlineSafeNote => 'Updates are saved even on a weak network.';

  @override
  String get tripProblem => 'Problem on the trip?';

  @override
  String get startLoading => 'Start loading at pickup';

  @override
  String get loadConfirmTitle => 'Is the crop loaded?';

  @override
  String get loadConfirmBody =>
      'When you confirm, the farmer is paid and the buyer is told.';

  @override
  String get yesLoaded => 'Loaded';

  @override
  String get deliverNow => 'Deliver';

  @override
  String get tripDoneBtn => 'Trip complete';

  @override
  String get podTitle => 'Proof of delivery';

  @override
  String get podPhoto => 'Take a delivery photo';

  @override
  String get deliveredQty => 'Delivered quantity';

  @override
  String get buyerOtp => 'Customer\'s OTP';

  @override
  String get otpHint4 => '4-digit code';

  @override
  String get podNote =>
      'The fare is released as soon as the buyer gives the OTP or GPS and photo prove delivery. It can\'t be held later.';

  @override
  String get podSubmit => 'Delivery complete';

  @override
  String get errOtpWrong => 'Wrong OTP';

  @override
  String get errOtp4 => 'Enter the 4-digit code';

  @override
  String get tripDoneTitle => 'Trip complete';

  @override
  String get tripDoneHeading => 'Delivery complete!';

  @override
  String tripDoneBody(String amount) {
    return '$amount sent to your bKash. This fare is final.';
  }

  @override
  String get seeReceipt => 'See receipt';

  @override
  String receiptSub(String amount) {
    return '$amount · sent to bKash';
  }

  @override
  String get rateCustomer => 'Rate the customer';

  @override
  String nameOrderNo(String name, String no) {
    return '$name · $no';
  }

  @override
  String get dontGoEmpty => 'Don\'t return empty';

  @override
  String get acceptReturnLoad => 'Take a return load';

  @override
  String get seeEarnings => 'See earnings';

  @override
  String get alreadyRated => 'Rated';

  @override
  String get rateTitle => 'Rate';

  @override
  String roleCustomer(String name) {
    return '$name (customer)';
  }

  @override
  String get justFinishedTrip => 'Trip just finished';

  @override
  String get howWasCustomer => 'How was the customer?';

  @override
  String get tagOnTimeLoad => 'On-time loading';

  @override
  String get tagCorrectInfo => 'Correct info';

  @override
  String get tagFastPay => 'Fast payment';

  @override
  String roleFarmerName(String name) {
    return '$name (farmer)';
  }

  @override
  String get howWasSupplier => 'How was the supplier?';

  @override
  String get tagGoodQuality => 'Good quality';

  @override
  String get tagRightWeight => 'Correct weight';

  @override
  String get tagOnTime => 'On time';

  @override
  String roleDriver(String name) {
    return '$name (driver)';
  }

  @override
  String get rateTransport => 'Rate the transport';

  @override
  String get commentOptional => 'Comment (optional)';

  @override
  String get commentHint => 'Write about your experience';

  @override
  String get submit => 'Submit';

  @override
  String get errPickStars => 'Tap the stars to rate';

  @override
  String get ratingThanks => 'Thanks for rating';

  @override
  String get vehicleTitle => 'Vehicle & capacity';

  @override
  String get truckPhoto => 'Truck photo';

  @override
  String get vehicleType => 'Vehicle type';

  @override
  String get regNo => 'Registration number';

  @override
  String get regHint => 'Dhaka Metro-T 12-3456';

  @override
  String get baseLocation => 'Base location (where the truck stays)';

  @override
  String get maxCapacity => 'Maximum capacity';

  @override
  String get tonUnit => 'ton';

  @override
  String get preferredRoute => 'Preferred route';

  @override
  String get vt_pickup => 'Pickup van';

  @override
  String get vt_small_open => 'Small truck (open)';

  @override
  String get vt_medium_open => 'Medium truck (open)';

  @override
  String get vt_medium_covered => 'Medium truck (covered)';

  @override
  String get vt_large_open => 'Large truck (open)';

  @override
  String get vt_covered_van => 'Covered van';

  @override
  String get vt_refrigerated => 'Refrigerated van';

  @override
  String get successTitle => 'Success!';

  @override
  String get successBody => 'Your task was completed successfully.';

  @override
  String get okBtn => 'OK';

  @override
  String get transportTitle => 'Transport';

  @override
  String get tabBooked => 'Booked';

  @override
  String get tabDone => 'Done';

  @override
  String noOrderCrop(String no, String crop) {
    return '$no · $crop';
  }

  @override
  String get dsOpen => 'Finding a truck';

  @override
  String get dsAssigned => 'Scheduled';

  @override
  String get dsPickedUp => 'On the way';

  @override
  String get dsDelivered => 'Delivered';

  @override
  String nameStatus(String name, String status) {
    return '$name · $status';
  }

  @override
  String bidsCountLine(String n) {
    return 'Offers: $n';
  }

  @override
  String get bookTruckBtn => '+ Book a truck';

  @override
  String get noTruckNeeded => 'All orders already have a truck';

  @override
  String get noTransport => 'No transport yet';

  @override
  String get bookTruckTitle => 'Book a truck';

  @override
  String get pickupLocation => 'Pickup location';

  @override
  String get goodsWeight => 'Goods & weight';

  @override
  String get dateLabel => 'Date';

  @override
  String get suggestedTrucks => 'Suggested trucks';

  @override
  String truckSub(String type, String cap, String rating) {
    return '$type · $cap · $rating';
  }

  @override
  String get waitingBids => 'Waiting for truck offers…';

  @override
  String get bookBtn => 'Book';

  @override
  String bookConfirmTitle(String name) {
    return 'Book $name?';
  }

  @override
  String bookConfirmBody(String amount) {
    return 'The fare $amount stays in safe payment.';
  }

  @override
  String get truckBooked => 'Truck booked';

  @override
  String get assignedTitle => 'Assigned transport';

  @override
  String verifiedDriverRating(String r) {
    return 'Verified driver · rating $r';
  }

  @override
  String driverRating(String r) {
    return 'Driver · rating $r';
  }

  @override
  String get rowTruck => 'Truck';

  @override
  String get rowCapacity => 'Capacity';

  @override
  String get callBtn => 'Call';

  @override
  String get trackBtn => 'Track';

  @override
  String get receiveTitle => 'Receive delivery';

  @override
  String get rowOrder => 'Order';

  @override
  String get rowOrdered => 'Ordered';

  @override
  String get rowLoaded => 'Weighed at loading';

  @override
  String yourOtp(String code) {
    return 'Your OTP: $code';
  }

  @override
  String get otpNote =>
      'Give this OTP to the driver when the truck arrives. The fare is released then.';

  @override
  String get qualityFinalTitle => 'Quality and quantity are final at loading';

  @override
  String get qualityFinalBody =>
      'After loading, no refunds for quality or quantity. Confirming delivery releases the fare.';

  @override
  String get deliveryPhotoOpt => 'Delivery photo (optional)';

  @override
  String get otherProblem => 'Report another problem';

  @override
  String get otpGiven => 'I gave the OTP';

  @override
  String get otpWaitDriver => 'Continue after the driver enters the OTP';

  @override
  String get orderBookTruck => 'Book a truck';

  @override
  String get orderReceive => 'Receive delivery';

  @override
  String get orderRate => 'Rate';

  @override
  String get handedOver => 'I handed it over';

  @override
  String get handedOverTitle => 'Handed over the crop?';

  @override
  String get handedOverBody =>
      'Confirm when the crop is on the buyer\'s vehicle.';

  @override
  String get receivedSelf => 'I received it';

  @override
  String get receivedTitle => 'Received the crop?';

  @override
  String get receivedBody => 'The farmer will be told when you confirm.';

  @override
  String get yesConfirm => 'Yes, confirm';

  @override
  String nBidNew(String no) {
    return 'New fare offer: $no';
  }

  @override
  String nBidNewBody(String name, String amount) {
    return '$name · $amount';
  }

  @override
  String nJobAssigned(String no) {
    return 'You got a job: $no';
  }

  @override
  String nTripPicked(String no) {
    return 'Crop loaded: $no';
  }

  @override
  String nTripDelivered(String no) {
    return 'Delivered: $no';
  }

  @override
  String get reportTitle => 'Report a problem';

  @override
  String get reportGeneralTitle => 'Order or trip';

  @override
  String get reportGeneralSub => 'The job you had a problem with';

  @override
  String get reportWhat => 'What went wrong?';

  @override
  String get reason_driver_behavior => 'Driver behaviour';

  @override
  String get reason_late_delivery => 'Late delivery';

  @override
  String get reason_app_problem => 'App problem';

  @override
  String get reason_other => 'Other';

  @override
  String get reportPhoto => 'Add a photo (optional)';

  @override
  String get reportDetails => 'Details (optional)';

  @override
  String get reportDetailsHint => 'Write or record voice';

  @override
  String get reportNote =>
      'Tell us what happened. We reply within 24 hours. Reporting does not change the payment rules.';

  @override
  String get reportSubmit => 'Submit report';

  @override
  String get reportSent => 'Report submitted';

  @override
  String get errPickReason => 'Choose what went wrong';

  @override
  String get safePayTitle => 'Safe payment';

  @override
  String get safePayExplain =>
      'The farmer is paid from safe payment when the crop is loaded, and the transporter when it reaches you. Only the buyer pays the 1% fee, taken at loading. Cancel before the truck leaves and 10% of the fare is kept; Golaghor refunds the rest. After that, a cancelled load refunds the crop price and fee, not the fare.';

  @override
  String get payBank => 'Bank transfer';

  @override
  String get payBkash => 'bKash / Nagad';

  @override
  String get payDemoSub => 'Demo — no real money is taken';

  @override
  String get payAddMethod => 'Add another method';

  @override
  String get payAddMethodSub => 'bKash, Nagad, Rocket or bank';

  @override
  String payNow(String amount) {
    return 'Pay $amount';
  }

  @override
  String orderLine(String no, String crop) {
    return '$no · $crop';
  }

  @override
  String get newOrderLabel => 'New order';

  @override
  String get modStatReports => 'Open reports';

  @override
  String get modStatVerify => 'Pending verification';

  @override
  String get modReportsTitle => 'Reports';

  @override
  String get rs_open => 'New';

  @override
  String get rs_inReview => 'In review';

  @override
  String get rs_resolved => 'Resolved';

  @override
  String get rs_dismissed => 'Dismissed';

  @override
  String get noReports => 'No reports';

  @override
  String get reportDetailTitle => 'Report details';

  @override
  String get rowReason => 'Problem';

  @override
  String get rowReporter => 'Reported by';

  @override
  String get rowDate => 'Date';

  @override
  String get rowDetails => 'Details';

  @override
  String get rowModNote => 'Moderator note';

  @override
  String nameRole(String name, String role) {
    return '$name ($role)';
  }

  @override
  String get startReview => 'Start review';

  @override
  String get resolveReport => 'Mark resolved';

  @override
  String get dismissReport => 'Dismiss';

  @override
  String get escalateReport => 'Escalate to admin';

  @override
  String get escalatedBadge => 'Escalated to admin';

  @override
  String get noteSheetTitle => 'Message to reporter (optional)';

  @override
  String get noteHint => 'Write what was done';

  @override
  String get sendBtn => 'Send';

  @override
  String get doneToast => 'Done';

  @override
  String get verifyTitle => 'Identity verification';

  @override
  String get verifyEmpty => 'No one is waiting for verification';

  @override
  String get rowNid => 'NID number';

  @override
  String get rowJoined => 'Joined';

  @override
  String get verifyApprove => 'Verify';

  @override
  String get verifyRejectBtn => 'Reject';

  @override
  String get verifyRejectTitle => 'Reject verification?';

  @override
  String get verifyRejectBody =>
      'The user will be asked to give a correct NID again.';

  @override
  String nameRolePhone(String role, String phone) {
    return '$role · $phone';
  }

  @override
  String get nVerifyOk => 'Your identity is verified';

  @override
  String get nVerifyOkBody => 'Your profile now shows the verified mark.';

  @override
  String get nVerifyRejected => 'Identity not verified';

  @override
  String get nVerifyRejectedBody =>
      'Please try again with a correct NID number.';

  @override
  String get nReportResolved => 'Your report was resolved';

  @override
  String get nReportDismissed => 'Your report was dismissed';

  @override
  String get navUsers => 'Users';

  @override
  String get navModeration => 'Moderation';

  @override
  String get navPrices => 'Prices';

  @override
  String get adminUsersSection => 'Users';

  @override
  String get statTotalUsers => 'Total users';

  @override
  String get adminListingsSection => 'Listings';

  @override
  String get adminOrdersSection => 'Orders & reports';

  @override
  String get statCompletedOrders => 'Completed orders';

  @override
  String get usersTitle => 'Users';

  @override
  String get userSearchHint => 'Search name or mobile number';

  @override
  String get noUsers => 'No one found';

  @override
  String get noRoleYet => 'No role yet';

  @override
  String get suspendedBadge => 'Suspended';

  @override
  String get userDetailTitle => 'User details';

  @override
  String get statusActiveUser => 'Active';

  @override
  String get rowVerification => 'Verification';

  @override
  String get vNone => 'Not done';

  @override
  String get vPending => 'Pending';

  @override
  String get vVerified => 'Verified';

  @override
  String get vRejected => 'Rejected';

  @override
  String get rowRating => 'Rating';

  @override
  String ratingLine(String avg, String n) {
    return '$avg (ratings: $n)';
  }

  @override
  String get suspendUser => 'Suspend';

  @override
  String get activateUser => 'Activate';

  @override
  String get suspendTitle => 'Suspend this user?';

  @override
  String get suspendBody =>
      'While suspended they can\'t create listings, offers or orders.';

  @override
  String get changeRole => 'Change role';

  @override
  String get roleChanged => 'Role changed';

  @override
  String get cantEditSelf => 'You can\'t change your own account here';

  @override
  String get moderationTitle => 'Moderation';

  @override
  String get pricesTitle => 'Market prices';

  @override
  String priceSub(String price, String min, String max) {
    return 'Today ৳ $price/kg · ৳ $min–$max';
  }

  @override
  String get noPrice => 'No price yet';

  @override
  String get fieldTodayPrice => 'Today\'s price';

  @override
  String get fieldMinPrice => 'Lowest price';

  @override
  String get fieldMaxPrice => 'Highest price';

  @override
  String get priceSaved => 'Price saved';

  @override
  String get errPriceRange => 'Lowest ≤ today ≤ highest';

  @override
  String get cropsTitle => 'Crop catalog';

  @override
  String get addCrop => '+ New crop';

  @override
  String get cropNameBn => 'Name (Bangla)';

  @override
  String get cropNameEn => 'Name (English)';

  @override
  String get cropCategory => 'Category';

  @override
  String get catOther => 'Other';

  @override
  String get cropOn => 'On';

  @override
  String get cropOff => 'Off';

  @override
  String get customCrop => 'Added by admin';

  @override
  String get cropSaved => 'Saved';

  @override
  String get cropsSub => 'Which crops farmers can sell';

  @override
  String get pricesSub => 'Enter today\'s market prices';

  @override
  String get verifiedBadge => 'Verified';

  @override
  String roleDistrict(String role, String district) {
    return '$role · $district';
  }

  @override
  String ratingShort(String avg, String n) {
    return '$avg ($n)';
  }

  @override
  String get statDoneDeals => 'Completed deals';

  @override
  String get statTotalOrders => 'Total orders';

  @override
  String get statDoneTrips => 'Completed trips';

  @override
  String get shareTrack => 'Share my track record';

  @override
  String get shareTrackSub => 'Verified summary · QR & link';

  @override
  String get shareLink => 'Share';

  @override
  String get rowNidVerify => 'Verification (NID)';

  @override
  String get rowBizVerify => 'Business verification';

  @override
  String get rowVerifyRating => 'Verification & rating';

  @override
  String get verifyDone => 'Verified';

  @override
  String get verifyPendingSub => 'Waiting for verification';

  @override
  String get verifyNoneSub => 'Not verified';

  @override
  String get verifyRejectedSub => 'Not verified — try again';

  @override
  String get rowMyRatings => 'My ratings & reviews';

  @override
  String get rowRatings => 'Ratings & reviews';

  @override
  String profileReviews(String n) {
    return 'Reviews: $n';
  }

  @override
  String get rowMyContracts => 'My contracts';

  @override
  String get rowContracts => 'Contracts';

  @override
  String get rowPayMethod => 'Payment methods';

  @override
  String get rowPayAccount => 'Payment account';

  @override
  String get rowLanguage => 'ভাষা / Language';

  @override
  String languageSub(String lang) {
    return '$lang · tap to change the language';
  }

  @override
  String get rowHelp => 'Help';

  @override
  String get helpSub => 'Voice guide, helpline';

  @override
  String get logoutTitle => 'Log out?';

  @override
  String get logoutBody =>
      'You\'ll need your mobile number and OTP to come back. Your trade history stays saved.';

  @override
  String get langSheetTitle => 'ভাষা পরিবর্তন / Change language';

  @override
  String get langBnSub => 'Bangla';

  @override
  String get langEnSub => 'ইংরেজি';

  @override
  String get langSheetNote =>
      'You can change the language again from your profile.';
}
