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
    return '$count districts';
  }

  @override
  String locUpazilaCount(String count) {
    return '$count upazilas';
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
    return '$count new offers';
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
    return '$count active listings';
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
    return '$count crops';
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
    return '$count listings';
  }

  @override
  String suggestListingsRange(String count, String min, String max) {
    return '$count listings · ৳ $min–$max';
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
}
