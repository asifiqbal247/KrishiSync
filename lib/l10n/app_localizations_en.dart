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
  String get loginCountryCode => '+88';

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
      'Buyers can now see your crop and make offers.';

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
  String get modHomeQueue => 'New listings';

  @override
  String get modStatPending => 'Pending listings';

  @override
  String get modStatActive => 'Active listings';

  @override
  String get modStatHidden => 'Rejected listings';

  @override
  String get modListingsTitle => 'All listings';

  @override
  String get modReviewTitle => 'Review listing';

  @override
  String get modFarmer => 'Farmer';

  @override
  String get modApprove => 'Approve';

  @override
  String get modReject => 'Hide listing';

  @override
  String get modRejectReasonTitle => 'Reason for rejecting';

  @override
  String get modRejectReasonHint => 'e.g. blurry photo, unusual price';

  @override
  String get modApproved => 'Listing approved';

  @override
  String get modRejected => 'Listing hidden';

  @override
  String get modQueueEmpty => 'No listings yet';

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
  String get statOnTime => 'On-time supply';

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
    return 'Listing hidden: $crop';
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

  @override
  String get loginTermsPre => 'By continuing you agree to the ';

  @override
  String get loginTermsLink => 'Terms and Privacy Policy';

  @override
  String get loginTermsPost => '.';

  @override
  String get termsTitle => 'Terms and Privacy Policy';

  @override
  String get termsUpdated => 'Last updated: November 2026';

  @override
  String get termsS1Title => '1. What Golaghor is';

  @override
  String get termsS1Body =>
      'Golaghor connects farmers, buyers and transporters directly, so crops are traded at fair prices without middlemen. You sign up with your mobile number and OTP; one account per number.';

  @override
  String get termsS2Title => '2. Listings and moderation';

  @override
  String get termsS2Body =>
      'Farmers must give the correct crop, grade, quantity, price and photo. Buyers see a listing as soon as it is published. A moderator may hide wrong or misleading listings, and repeated cases can lead to suspension.';

  @override
  String get termsS3Title => '3. Safe payment and fees';

  @override
  String get termsS3Body =>
      'The buyer\'s money is held in safe payment. The farmer is paid when the crop is loaded, and the transporter when the delivery OTP is given. Only the buyer pays the 1% platform fee. Quality and quantity are final at loading.';

  @override
  String get termsS4Title => '4. Cancellation and refunds';

  @override
  String get termsS4Body =>
      'If you cancel before the truck leaves, 10% of the fare is kept and the rest is refunded. After that, a cancelled load refunds the crop price and fee, not the fare. Report problems in the app; we reply within 24 hours.';

  @override
  String get termsS5Title => '5. Transport and delivery';

  @override
  String get termsS5Body =>
      'Transporters must give correct vehicle details and can\'t mark a delivery done without the buyer\'s OTP. Buyers should give the OTP only when the truck has arrived.';

  @override
  String get termsS6Title => '6. Your data';

  @override
  String get termsS6Body =>
      'We keep your name, mobile number, address, photos, NID number (optional) and trade records only to run the app, verify users and settle disputes. Trade partners see only what they need (name, area, rating). We never sell your data.';

  @override
  String get termsS7Title => '7. Conduct and ratings';

  @override
  String get termsS7Body =>
      'Everyone must act honestly and respectfully. Ratings can be given after each trade; fake ratings or harassment can lead to suspension.';

  @override
  String get mpTitle => 'Market prices';

  @override
  String get mpSearchHint => 'Search crops';

  @override
  String get mpWholesale => 'Wholesale market prices';

  @override
  String mpUpdated(String when) {
    return 'Updated: $when';
  }

  @override
  String mpUpdatedDam(String when) {
    return 'Source: DAM · $when';
  }

  @override
  String pctChange(String sign, String pct) {
    return '$sign$pct%';
  }

  @override
  String get mpEmpty => 'No prices yet';

  @override
  String trendTitle(String crop) {
    return '$crop – price trend';
  }

  @override
  String get period7 => '7 days';

  @override
  String get period30 => '30 days';

  @override
  String get period90 => '3 months';

  @override
  String sinceWeek(String pct) {
    return '$pct since last week';
  }

  @override
  String sinceMonth(String pct) {
    return '$pct since last month';
  }

  @override
  String since3Months(String pct) {
    return '$pct since 3 months ago';
  }

  @override
  String get rowHighest => 'Highest';

  @override
  String get rowLowest => 'Lowest';

  @override
  String get rowAverage => 'Average';

  @override
  String priceAlert(String price) {
    return 'Set price alert (notify at $price)';
  }

  @override
  String get sellAtPrice => 'Sell crop at this price';

  @override
  String get findInMarket => 'Find in market';

  @override
  String get trendNoData => 'No price data for this period yet';

  @override
  String get payTitle => 'Payments';

  @override
  String get payHeldFarmer => 'Held in safe payment';

  @override
  String get payReceivedMonth => 'Received this month';

  @override
  String get payHeldBuyer => 'In safe payment';

  @override
  String get payPaidMonth => 'Paid this month';

  @override
  String get payReceiveMethod => 'Payout method';

  @override
  String payMethodSub(String phone) {
    return 'bKash · $phone';
  }

  @override
  String get changeLink => 'Change';

  @override
  String get payHistory => 'Transaction history';

  @override
  String payItemTitle(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String payHeldSub(String date) {
    return 'Safe payment · $date';
  }

  @override
  String paySentSub(String date) {
    return 'Sent to bKash · $date';
  }

  @override
  String payPaidSub(String date) {
    return 'Paid · $date';
  }

  @override
  String payTransportTitle(String name) {
    return 'Transport – $name';
  }

  @override
  String get payEmpty => 'No transactions yet';

  @override
  String get receiptTitle => 'Receipt';

  @override
  String receiptPaid(String method) {
    return 'Payment successful · $method';
  }

  @override
  String get receiptHeld => 'Held in safe payment';

  @override
  String get methodBkash => 'bKash';

  @override
  String get methodBank => 'Bank';

  @override
  String get rowReceiptNo => 'Receipt no.';

  @override
  String get rowCrop => 'Crop';

  @override
  String get rowPrice => 'Price';

  @override
  String get rowFareLabel => 'Transport fare';

  @override
  String get rowRoute => 'Route';

  @override
  String get pdfDownload => 'Download PDF';

  @override
  String cropQty(String crop, String qty) {
    return '$crop, $qty';
  }

  @override
  String get earnTitle => 'Earnings';

  @override
  String get earnHistory => 'Earnings history';

  @override
  String get earnHeldSub => 'Held in safe payment';

  @override
  String get earnPaidSub => 'Paid · bKash';

  @override
  String get earnEmpty => 'No earnings yet';

  @override
  String get nidVerifyTitle => 'NID verification';

  @override
  String get nidVerifyIntro => 'A verified profile builds buyers\' trust.';

  @override
  String get nidNumberLabel => 'NID number';

  @override
  String get nidNumberHint => '10 or 17 digits';

  @override
  String get nidFront => 'Front of NID card';

  @override
  String get nidBack => 'Back of NID card';

  @override
  String get selfie => 'Your selfie';

  @override
  String get submitVerify => 'Submit for verification';

  @override
  String get errNid => 'Enter a valid NID (10 or 17 digits)';

  @override
  String get errPhotoNeeded => 'Add a photo';

  @override
  String get verifySent => 'Submitted for verification';

  @override
  String get bizVerifyTitle => 'Business verification';

  @override
  String get bizVerifyIntro => 'A verified business builds farmers\' trust.';

  @override
  String get bizName => 'Business name';

  @override
  String get bizAddress => 'Business address';

  @override
  String get bizAddressHint => 'Division › District › Upazila › Area';

  @override
  String get tradeLicense => 'Trade license number';

  @override
  String get tinLabel => 'TIN / BIN number';

  @override
  String get tinHint => '12 digits';

  @override
  String get licensePhoto => 'Trade license photo';

  @override
  String get verifyStatusTitle => 'Verification & rating';

  @override
  String get drivingLicense => 'Driving license';

  @override
  String get vehiclePapers => 'Vehicle papers (fitness)';

  @override
  String get inReview => 'In review';

  @override
  String get rowDocs => 'Documents';

  @override
  String get rowBizName => 'Business';

  @override
  String get ratingsTitle => 'Ratings & reviews';

  @override
  String outOf5(String avg) {
    return '$avg / 5';
  }

  @override
  String outOf5Count(String avg, String n) {
    return '$avg / 5 (reviews: $n)';
  }

  @override
  String reviewsOnlyDone(String n) {
    return 'Reviews: $n · only from completed trades';
  }

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get tag_good_quality => 'Good quality';

  @override
  String get tag_right_weight => 'Correct weight';

  @override
  String get tag_on_time => 'On time';

  @override
  String get tag_on_time_load => 'On-time loading';

  @override
  String get tag_correct_info => 'Correct info';

  @override
  String get tag_fast_pay => 'Fast payment';

  @override
  String get trackTitle => 'Shipment tracking';

  @override
  String truckCapRating(String type, String cap, String rating) {
    return '$type · $cap · $rating';
  }

  @override
  String get rowEta => 'Reaches you';

  @override
  String get rowStatus => 'Status';

  @override
  String get rowRemaining => 'Total distance';

  @override
  String kmOnly(String km) {
    return '$km km';
  }

  @override
  String get tsWaitingPickup => 'Waiting for pickup';

  @override
  String get tsOnWay => 'Coming to you';

  @override
  String get tsDelivered => 'Delivered';

  @override
  String get messageBtn => 'Message';

  @override
  String get buyerProfileTitle => 'Buyer profile';

  @override
  String get verifiedBusiness => 'Verified business · trade license';

  @override
  String get unverifiedBuyer => 'Buyer (business)';

  @override
  String get statReviews => 'Reviews';

  @override
  String get statVerification => 'Verification';

  @override
  String get seeDemands => 'See demands';

  @override
  String get messageShort => 'Message';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get cancelOrderTitle => 'Cancel the order?';

  @override
  String cancelOrderBody(String fee, String refund) {
    return 'If you cancel before the truck leaves, the transporter gets 10% of the fare ($fee) and Golaghor refunds the rest ($refund).';
  }

  @override
  String cancelOrderBodyNoFee(String refund) {
    return 'If you cancel, Golaghor refunds the full $refund.';
  }

  @override
  String get yesCancel => 'Yes, cancel';

  @override
  String get orderCancelled => 'Order cancelled';

  @override
  String nOrderCancelled(String no) {
    return 'Order cancelled: $no';
  }

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get postDemandTitle => 'Post a demand';

  @override
  String get stepProductQty => 'Product & quantity';

  @override
  String get stepDelivery => 'Delivery';

  @override
  String get fieldCropName => 'Crop';

  @override
  String get fieldGradeSize => 'Grade / quality';

  @override
  String get fieldTargetPrice => 'Target price';

  @override
  String marketRateLine(String min, String max) {
    return 'Market rate: ৳ $min–$max / kg';
  }

  @override
  String get deliveryLocation => 'Delivery location';

  @override
  String get deliveryDate => 'Delivery date';

  @override
  String get repeatOnce => 'Once';

  @override
  String get repeatOnceSub => 'This order only';

  @override
  String get repeatMonthly => 'Regular (repeat)';

  @override
  String get repeatMonthlySub => 'Every month';

  @override
  String get publishDemand => 'Publish demand';

  @override
  String get demandPosted => 'Demand published';

  @override
  String get myDemandsTitle => 'My demands';

  @override
  String get noDemands => 'No demands';

  @override
  String demandLine(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String demandSubTarget(String date, String price) {
    return '$date · target ৳ $price';
  }

  @override
  String offersReceived(String n) {
    return 'Offers received ($n)';
  }

  @override
  String get sortPrice => 'Price';

  @override
  String get sortQuality => 'Quality';

  @override
  String get sortRating => 'Rating';

  @override
  String commitSub(String qty, String grade, String rating) {
    return '$qty · grade $grade · $rating';
  }

  @override
  String get selectedTotal => 'Selected total';

  @override
  String ofKg(String a, String b) {
    return '$a / $b kg';
  }

  @override
  String get acceptSelected => 'Accept selected offers';

  @override
  String get noCommits => 'No farmer offers yet';

  @override
  String get commitsAccepted => 'Offers accepted, orders created';

  @override
  String get selectCommit => 'Pick at least one offer';

  @override
  String get acceptedBadge => 'Accepted';

  @override
  String get closeDemand => 'Close demand';

  @override
  String get demandClosed => 'Closed';

  @override
  String get demandOpen => 'Open';

  @override
  String get demandFilled => 'Filled';

  @override
  String get buyerDemandsTitle => 'Buyer demands';

  @override
  String get demandSearchHint => 'Search crop or area';

  @override
  String get filterBigOrder => 'Large orders';

  @override
  String get filterExport => 'Export';

  @override
  String demandRowSub(String buyer, String date) {
    return '$buyer · $date';
  }

  @override
  String poolingSub(String pct) {
    return 'Pooling · $pct% filled';
  }

  @override
  String get demandDetailsTitle => 'Demand details';

  @override
  String get rowNeed => 'Needed';

  @override
  String get rowDelivery => 'Delivery';

  @override
  String ratingTrades(String avg, String n) {
    return '$avg ($n trades)';
  }

  @override
  String get poolingProgress => 'Pooling progress';

  @override
  String get poolingNote => 'Several farmers together can fill this order.';

  @override
  String get futureHarvest => 'Supply from future harvest';

  @override
  String get wantToSupply => 'I want to supply';

  @override
  String get howMuchSupply => 'How many kg can you supply?';

  @override
  String get readyFrom => 'Ready on';

  @override
  String get estTotal => 'You\'ll get (approx.)';

  @override
  String get commitSent => 'Supply offer sent';

  @override
  String myCommitLine(String qty, String status) {
    return 'Your offer: $qty · $status';
  }

  @override
  String get commitPending => 'Pending';

  @override
  String errQtyLeft(String qty) {
    return 'Only $qty left';
  }

  @override
  String nCommitNew(String crop) {
    return 'New supply offer: $crop';
  }

  @override
  String nCommitNewBody(String farmer, String qty) {
    return '$farmer · $qty';
  }

  @override
  String nCommitAccepted(String no) {
    return 'Your supply accepted: $no';
  }

  @override
  String get closeDemandBody =>
      'Farmers can\'t offer supply after you close it. Accepted orders continue.';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get searchNameHint => 'Search name';

  @override
  String get noChats => 'No messages yet';

  @override
  String get typeMessage => 'Type a message…';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get chatStart => 'Start the conversation';

  @override
  String nameWithRole(String name, String role) {
    return '$name ($role)';
  }

  @override
  String get roleDriverShort => 'driver';

  @override
  String get helpTitle => 'Help & support';

  @override
  String get callHelpline => 'Call helpline';

  @override
  String get commonQuestions => 'Common questions';

  @override
  String listenTime(String t) {
    return 'Listen · $t';
  }

  @override
  String get chatHelp => 'Get help in chat';

  @override
  String get faqTitle => 'Questions & answers';

  @override
  String get faqUseful => 'Was this answer useful?';

  @override
  String get faqYes => 'Yes 👍';

  @override
  String get faqNo => 'No 👎';

  @override
  String get faqThanks => 'Thanks for your feedback';

  @override
  String get supportName => 'Golaghor support';

  @override
  String get q1 => 'How to sell your crop';

  @override
  String get q1Farmer =>
      'Tap the \"Sell\" button → add crop, grade, quantity and photo → set price, date and pickup address → publish. Buyers can see it and make offers right away.';

  @override
  String get q2 => 'How you get paid';

  @override
  String get q2Farmer =>
      'As soon as the crop is loaded on the truck, your money is released from safe payment. This payment is final — it can\'t be held or taken back later.';

  @override
  String get q2Transporter =>
      'You get the fare when the crop reaches the buyer and you enter the buyer\'s OTP. If the order is cancelled before you leave, you get 10% of the fare.';

  @override
  String get q2Buyer =>
      'Your order money is held in safe payment. Quality and quantity are final at loading, so check before loading.';

  @override
  String get q3 => 'Who books the truck?';

  @override
  String get q3Buyer =>
      'If you choose \"platform truck\", drivers offer fares and you book one. If you choose \"own transport\", you collect the crop yourself.';

  @override
  String get q4 => 'What is safe payment?';

  @override
  String get q4Body =>
      'The buyer\'s money is held by Golaghor. The farmer is paid when the crop is loaded and the transporter when it is delivered, so no one is cheated.';

  @override
  String get q5 => 'What happens if an offer is rejected?';

  @override
  String get q5Body =>
      'A rejected offer can\'t be accepted again, but the buyer can make a new one. No money is taken before an order is placed.';

  @override
  String get voiceGuideTitle => 'Voice guide';

  @override
  String get pmTitle => 'Payment methods';

  @override
  String get pmIntro =>
      'Farmers & transporters: where you get paid · Buyers: where you pay from';

  @override
  String get pmDefault => 'Default';

  @override
  String get pmMakeDefault => 'Change';

  @override
  String pmNameMatched(String name) {
    return 'Name matched: $name';
  }

  @override
  String pmWalletLine(String type, String number) {
    return '$type · $number';
  }

  @override
  String pmBankSub(String name, String branch) {
    return '$name · $branch branch';
  }

  @override
  String get pmAdd => '+ Add a new method';

  @override
  String get pmSafetyTitle => 'Safety';

  @override
  String get pmSafetyBody =>
      'Money never goes to a new method without a name match. After a change, money goes to the old method for 24 hours, so no one can cheat.';

  @override
  String get pmNone => 'No method added yet';

  @override
  String get pmAddTitle => 'Add a method';

  @override
  String get pmWhich => 'Which method?';

  @override
  String get pmBkash => 'bKash';

  @override
  String get pmNagad => 'Nagad';

  @override
  String get pmRocket => 'Rocket';

  @override
  String get pmBank => 'Bank account';

  @override
  String get pmWalletInstant => 'Mobile wallet · instant money';

  @override
  String get pmWallet => 'Mobile wallet';

  @override
  String get pmBankSlow => 'For large amounts · 1 working day';

  @override
  String pmNumberTitle(String type) {
    return '$type number';
  }

  @override
  String get pmOwnNumber =>
      'The number must be in your own name. Money can\'t be sent to someone else\'s number.';

  @override
  String get pmWhyTitle => 'Why';

  @override
  String get pmWhyBody =>
      'To stop money going to a wrong number and to stop fraud.';

  @override
  String get pmVerifyTitle => 'Verify number';

  @override
  String pmVerifySub(String type) {
    return '$type account name and profile name match';
  }

  @override
  String pmVerifyIntro(String number) {
    return '$number will be added under your profile name.';
  }

  @override
  String get pmSetDefault => 'Make this the default method';

  @override
  String get pmSaved => 'Payment method saved';

  @override
  String get pmBankTitle => 'Bank account';

  @override
  String get pmBankName => 'Bank';

  @override
  String get pmBranch => 'Branch';

  @override
  String get pmAccName => 'Account name';

  @override
  String get pmAccNameHint => 'Must match your profile name';

  @override
  String get pmAccNo => 'Account number';

  @override
  String get pmAccNoHint => '13–17 digits';

  @override
  String get pmBankNote =>
      'The routing number comes from the branch. ৳1 is sent to verify (1 working day).';

  @override
  String get pmStartVerify => 'Start verification';

  @override
  String get pmErrAccNo => 'Enter a 13–17 digit account number';

  @override
  String get pmErrName => 'Name doesn\'t match your profile';

  @override
  String get pmSendCode => 'Send verification code';

  @override
  String get pmSave => 'Save';

  @override
  String get pmVerifying => 'Verifying';

  @override
  String get pmVerifiedShort => 'verified';

  @override
  String get tipTitle => 'Farming tips';

  @override
  String get tipPriceBody1 =>
      'Check \"Market prices\" before selling. A price inside the market range gets offers faster.';

  @override
  String get tipPriceBody2 =>
      'Add a clear photo of the crop — in daylight, up close. Good photos get better prices.';

  @override
  String get tipPriceBody3 =>
      'Check buyer demands and supply together; pooling with other farmers cuts transport cost.';

  @override
  String get tipPackBody1 =>
      'Keep tomatoes and soft vegetables in 20 kg crates, not sacks — less damage.';

  @override
  String get tipPackBody2 => 'Keep potatoes and onions in dry, airy sacks.';

  @override
  String get tipPackBody3 =>
      'Remove wet or rotten produce before loading — quality is final at loading.';

  @override
  String get tipGradeBody1 =>
      'Grade A: even size, no marks, ripeness as agreed.';

  @override
  String get tipGradeBody2 =>
      'Grade B: small marks or uneven size, but good to eat.';

  @override
  String get tipGradeBody3 =>
      'Grade C: more marks or small size — for processing.';

  @override
  String get globalBuyersTitle => 'Global buyers';

  @override
  String get globalBuyersIntro =>
      'Sell your crops to foreign buyers and importers.';

  @override
  String get noExportDemand =>
      'No foreign buyer demand yet. See the guide to get ready for export.';

  @override
  String get seeExportGuide => 'See export guide';

  @override
  String get exportGuideTitle => 'Export guide';

  @override
  String get exportSteps => 'Steps';

  @override
  String get exStep1 => 'Profile verification';

  @override
  String get exStep1Sub => 'NID and land details';

  @override
  String get exStep2 => 'Quality certificate';

  @override
  String get exStep2Sub => 'Phytosanitary certificate';

  @override
  String get exStep3 => 'Packaging';

  @override
  String get exStep3Sub => 'To export standard';

  @override
  String get exStep4 => 'Contract & payment';

  @override
  String get exStep4Sub => 'Safe payment or LC';

  @override
  String get exDocs => 'Required documents';

  @override
  String get exDoc1 => 'Phytosanitary certificate';

  @override
  String get exDoc1Sub => 'Department of Agricultural Extension';

  @override
  String get exDoc2 => 'Trade license';

  @override
  String get exDoc2Sub => 'Or farmers\' cooperative certificate';

  @override
  String get shareTitle => 'Share track record';

  @override
  String statRatingReviews(String n) {
    return 'Rating ($n reviews)';
  }

  @override
  String memberSince(String year) {
    return 'Since $year';
  }

  @override
  String get memberLabel => 'Member';

  @override
  String shareCode(String code) {
    return 'Golaghor ID: $code';
  }

  @override
  String get shareVerifiedToday => 'Golaghor verified · updated: today';

  @override
  String get shareQrNote => 'Scan the QR to see this record';

  @override
  String get whatToShow => 'What to show';

  @override
  String get showDeals => 'Number of trades & on-time %';

  @override
  String get showRatings => 'Ratings & reviews';

  @override
  String get showMoney => 'Money amount';

  @override
  String get visibleAll => 'Everyone can see';

  @override
  String get hiddenPrivacy => 'Off for privacy';

  @override
  String get onLabel => 'On';

  @override
  String get offLabel => 'Off';

  @override
  String get loanNote =>
      'You can show this to a bank or NGO for a loan yourself (the app gives no loans).';

  @override
  String get copyLink => 'Copy';

  @override
  String get shareNow => 'Share';

  @override
  String get copied => 'Copied';

  @override
  String get shareHeader => 'Golaghor track record';

  @override
  String shareMoneyLine(String amount) {
    return 'Total traded: $amount';
  }

  @override
  String get historyTitle => 'Transaction history';

  @override
  String get histIncomeMonth => 'Income this month';

  @override
  String get histBuyMonth => 'Bought this month';

  @override
  String get histSearchHint => 'Search order no., crop or name';

  @override
  String get histReceived => 'Received';

  @override
  String get histPaid => 'Paid';

  @override
  String get histHeld => 'In safe payment';

  @override
  String get histCancelled => 'Cancelled';

  @override
  String monthTotal(String amount) {
    return 'Total $amount';
  }

  @override
  String histRowSub(String party, String date, String status) {
    return '$party · $date · $status';
  }

  @override
  String get histEmpty => 'No transactions in this period';

  @override
  String get statementBtn => 'Statement download / share';

  @override
  String get statementTitle => 'Create statement';

  @override
  String get periodLabel => 'Period';

  @override
  String get periodThisMonth => 'This month';

  @override
  String get periodLast3 => 'Last 3 months';

  @override
  String get period12 => '12 months · for bank';

  @override
  String get periodCustom => 'Choose dates';

  @override
  String get rowPeriod => 'Period';

  @override
  String get rowTotalDeals => 'Total trades';

  @override
  String get rowTotalIncome => 'Total income';

  @override
  String get rowTotalSpent => 'Total spent';

  @override
  String dateRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get statementPrivacy =>
      'Your phone number and NID stay hidden in the statement.';

  @override
  String get shareLabel => 'Share';

  @override
  String get shareWhatsapp => 'WhatsApp';

  @override
  String get shareEmail => 'Email';

  @override
  String get shareMessenger => 'Messenger';

  @override
  String get shareOther => 'Other';

  @override
  String get pdfDownloadFull => 'Download PDF';

  @override
  String get statementHeader => 'Golaghor statement';

  @override
  String get statementVerified => 'Golaghor verified';

  @override
  String priceAlertOn(String price) {
    return 'Price alert on · $price · turn off';
  }

  @override
  String get priceAlertTitle => 'Price alert';

  @override
  String get priceAlertHintUp =>
      'You get an in-app notification when the price reaches this target or more.';

  @override
  String get priceAlertHintDown =>
      'You get an in-app notification when the price drops to this target or less.';

  @override
  String get priceAlertSet => 'Price alert set';

  @override
  String get priceAlertRemoveQ => 'Turn off price alert?';

  @override
  String get priceAlertRemoveBody =>
      'You will no longer be notified about this crop\'s price.';

  @override
  String get priceAlertRemove => 'Turn off';

  @override
  String nPriceAlert(String crop) {
    return '$crop price reached your target';
  }

  @override
  String nPriceAlertBody(String price) {
    return 'Today\'s price $price/kg';
  }

  @override
  String get contractsTitle => 'Contracts';

  @override
  String get contractNew => 'New';

  @override
  String get contractActive => 'Ongoing';

  @override
  String get contractPending => 'Pending';

  @override
  String get contractDone => 'Completed';

  @override
  String get contractRejected => 'Rejected';

  @override
  String get contractCancelled => 'Cancelled';

  @override
  String get contractsEmpty => 'No contracts here';

  @override
  String get freqMonthly => 'Monthly';

  @override
  String get freqWeekly => 'Weekly';

  @override
  String contractFarmerSub(String freq, String crop, String months) {
    return '$freq $crop supply · $months months';
  }

  @override
  String contractLine(String crop, String freq, String qty) {
    return '$crop – $freq $qty';
  }

  @override
  String contractBuyerSub(String name, String range) {
    return '$name · $range';
  }

  @override
  String get newContractBtn => '+ New contract';

  @override
  String get contractDetailsTitle => 'Contract details';

  @override
  String buyerVerifiedLine(String name) {
    return '$name (verified)';
  }

  @override
  String contractPriceFixed(String price) {
    return '$price / kg (fixed)';
  }

  @override
  String get contractTerms => 'Contract terms';

  @override
  String get rowTerm => 'Term';

  @override
  String perMonthQty(String qty) {
    return '$qty per month';
  }

  @override
  String perWeekQty(String qty) {
    return '$qty per week';
  }

  @override
  String get contractPayValue => 'At each load (from safe payment)';

  @override
  String get acceptContract => 'Accept contract';

  @override
  String get rejectContractQ => 'Reject the contract?';

  @override
  String get rejectContractBody =>
      'The other side will be told. It can\'t be accepted later, but they can send a new offer.';

  @override
  String get cancelContractQ => 'Cancel the contract?';

  @override
  String get cancelContractBody =>
      'The rest of the supply stops. Payment for loads already done is not returned — what happened is final.';

  @override
  String get yesCancelIt => 'Yes, cancel';

  @override
  String get contractAccepted => 'Contract accepted';

  @override
  String get newContractTitle => 'New contract';

  @override
  String get fieldSupplier => 'Supplier';

  @override
  String get fieldCropGrade => 'Crop & grade';

  @override
  String cropGradeValue(String crop, String grade) {
    return '$crop, grade $grade';
  }

  @override
  String get fieldQtyPerDelivery => 'Quantity (per delivery)';

  @override
  String get fieldFixedPrice => 'Fixed price';

  @override
  String get sendContract => 'Send contract';

  @override
  String get contractSent => 'Contract sent';

  @override
  String get errSelectSupplier => 'Choose a supplier';

  @override
  String get errSelectCrop => 'Choose a crop';

  @override
  String get searchFarmerHint => 'Search farmer name';

  @override
  String get contractStatusTitle => 'Contract status';

  @override
  String get rowContract => 'Contract';

  @override
  String get rowSupplier => 'Supplier';

  @override
  String get rowBuyerLabel => 'Buyer';

  @override
  String get deliverySchedule => 'Delivery schedule';

  @override
  String monthDelivery(String month) {
    return '$month delivery';
  }

  @override
  String weekDelivery(String n) {
    return 'Week $n delivery';
  }

  @override
  String deliveryOrdered(String qty) {
    return '$qty · ordered';
  }

  @override
  String deliveryDue(String date) {
    return 'Scheduled: $date';
  }

  @override
  String get cancelContract => 'Cancel contract';

  @override
  String get renewContract => 'Renew';

  @override
  String get orderDeliveryQ => 'Order this delivery?';

  @override
  String orderDeliveryBody(String qty, String amount) {
    return '$qty · $amount is held in safe payment and goes to the farmer on delivery.';
  }

  @override
  String get orderNow => 'Place order';

  @override
  String get contractRenewed => 'Renewal sent';

  @override
  String nContractNew(String crop) {
    return 'New contract offer: $crop';
  }

  @override
  String nContractActive(String crop) {
    return 'Contract accepted: $crop';
  }

  @override
  String nContractRejected(String crop) {
    return 'Contract rejected: $crop';
  }

  @override
  String nContractCancelled(String crop) {
    return 'Contract cancelled: $crop';
  }

  @override
  String nContractOrder(String no) {
    return 'Contract delivery order: $no';
  }

  @override
  String get truckComingTitle => 'Truck for your crop';

  @override
  String get truckBookedByBuyer => 'Buyer booked a truck';

  @override
  String truckBookedBody(String name) {
    return '$name is sending this truck. The buyer pays the fare; you don\'t book or pay anything.';
  }

  @override
  String get truckNotBooked => 'No truck booked yet';

  @override
  String get truckNotBookedBody =>
      'When the buyer books a truck, the driver and your OTP show here.';

  @override
  String get rowWhenComes => 'When';

  @override
  String get rowWhereComes => 'Where';

  @override
  String cropQtyComma(String a, String b) {
    return '$a, $b';
  }

  @override
  String nameDistrict(String name, String district) {
    return '$name, $district';
  }

  @override
  String get truckComingSection => 'Truck coming';

  @override
  String yourLoadOtp(String code) {
    return 'Your OTP: $code';
  }

  @override
  String get yourLoadOtpBody =>
      'Keep the crop ready. Give this OTP to the driver only after checking the weight — you get paid right away.';

  @override
  String get weightMoreTitle => 'Extra weight';

  @override
  String get waitingBuyer => 'Waiting for the buyer';

  @override
  String waitingBuyerBody(String qty) {
    return 'The scale shows $qty more. If the buyer approves, you get paid for the extra too.';
  }

  @override
  String get rowWeighed => 'Weighed';

  @override
  String get rowExtraPrice => 'Extra price';

  @override
  String get rowReplyTime => 'Reply time';

  @override
  String minutes(String n) {
    return '$n minutes';
  }

  @override
  String get ifNoReply => 'If there is no reply';

  @override
  String ifNoReplyBody(String n, String qty) {
    return 'If the buyer doesn\'t reply in $n minutes, only $qty is loaded.';
  }

  @override
  String get trackChalan => 'Track shipment';

  @override
  String get goHome => 'Go home';

  @override
  String get weightLessTitle => 'Weight less';

  @override
  String get loadedTitle => 'Crop loaded';

  @override
  String get weightLessHeading => 'Weight came out less';

  @override
  String get weightLessBody =>
      'You were paid for exactly what the digital scale weighed.';

  @override
  String get moneySent => 'Money sent!';

  @override
  String get moneySentBody =>
      'Your money was released as soon as the crop was loaded.';

  @override
  String get rowWeightDigital => 'Weight (digital)';

  @override
  String get rowReceivedTotal => 'Total received';

  @override
  String get rowMethod => 'Method';

  @override
  String get moneyFinal => 'This money is final';

  @override
  String get moneyFinalBody =>
      'Even if a problem comes up later, this money can\'t be held or taken back.';

  @override
  String get moneyFinalLessBody =>
      'Weight and photos are saved. The buyer gets the rest back.';

  @override
  String get seePayments => 'See payments';

  @override
  String get weighTitle => 'Pickup: load & weigh';

  @override
  String nameDot(String a, String b) {
    return '$a · $b';
  }

  @override
  String gradeStop(String grade, String i, String n) {
    return 'Grade $grade · stop $i/$n';
  }

  @override
  String get oneMon => '1 maund';

  @override
  String monFixed(String kg) {
    return '$kg kg (fixed)';
  }

  @override
  String get scaleNote => 'Digital scale · saved with time and location';

  @override
  String scalePhotos(String n, String max) {
    return 'Photos of scale and crop ($n/$max)';
  }

  @override
  String get farmerOtp => 'Farmer\'s OTP';

  @override
  String get weighNote =>
      'With the farmer\'s OTP the load is confirmed and money released. If less, the buyer gets the rest back; if more, the buyer must approve first.';

  @override
  String get notLoadedReport => 'Not loaded? Report';

  @override
  String get otpAndLoad => 'Enter OTP & confirm load';

  @override
  String extraWaitNote(String extra, String qty) {
    return '$extra more — waiting for the buyer. Without a reply only $qty is loaded.';
  }

  @override
  String extraLoadOrdered(String qty) {
    return 'Load only the ordered $qty';
  }

  @override
  String extraApprovedNote(String qty) {
    return 'Buyer approved — load $qty';
  }

  @override
  String loadDone(String qty) {
    return '$qty loaded';
  }

  @override
  String get weightDiffTitle => 'Weight difference';

  @override
  String weightLessRefund(String amount) {
    return 'Weight was less: you get $amount back';
  }

  @override
  String weightLessRefundBody(String no, String crop) {
    return '$no · $crop. You pay only for what the digital scale weighed.';
  }

  @override
  String get rowOrderedKg => 'You ordered';

  @override
  String get rowLoadWeighed => 'Weighed at loading';

  @override
  String get rowLess => 'Less';

  @override
  String rowCropRefund(String price) {
    return 'Crop refund (৳ $price/kg)';
  }

  @override
  String rowFeeRefund(String pct) {
    return 'Fee refund ($pct%)';
  }

  @override
  String get rowTotalRefund => 'Total refund';

  @override
  String weightLessNote(String qty) {
    return 'The farmer was paid for $qty. The fare stays the same. The money comes back the same way within 3 working days.';
  }

  @override
  String get seeWeighReport => 'See weight & photo report';

  @override
  String get seeRefundStatus => 'See refund status';

  @override
  String get noLoadPhotos => 'No photos were taken at loading';

  @override
  String weighReportTitle(String qty) {
    return 'Weight report · $qty';
  }

  @override
  String extraNeedApproval(String qty) {
    return 'Approval needed: $qty more';
  }

  @override
  String extraNeedApprovalBody(String farmer, String crop) {
    return '$farmer · $crop. To take the extra, pay for it; then the load is confirmed.';
  }

  @override
  String get rowScaleWeighed => 'Scale weighed';

  @override
  String get rowMore => 'More';

  @override
  String rowExtraPriceAt(String price) {
    return 'Extra price (৳ $price/kg)';
  }

  @override
  String rowFeePct(String pct) {
    return 'Fee ($pct%)';
  }

  @override
  String get rowTotalToPay => 'Total to pay';

  @override
  String extraNote(String n) {
    return 'Without a reply in $n minutes only the ordered amount is loaded. Once loaded after approval, the farmer gets this money and it can\'t be returned.';
  }

  @override
  String approveAndPay(String amount) {
    return 'Approve & pay $amount';
  }

  @override
  String keepOrdered(String qty) {
    return 'No, keep $qty';
  }

  @override
  String get extraApproved => 'Extra weight approved';

  @override
  String get extraDeclined => 'Only the ordered amount will load';

  @override
  String extraExpiredNote(String qty) {
    return 'Time is up — only $qty will load';
  }

  @override
  String get refundTitle => 'Refund';

  @override
  String refundSubCancel(String crop, String qty) {
    return '$crop – $qty · order cancelled (before the truck left)';
  }

  @override
  String refundSubWeight(String crop, String qty) {
    return '$crop · weighed $qty less';
  }

  @override
  String get rowCropValue => 'Crop value';

  @override
  String get rowTransportCut => 'Transport (10% kept)';

  @override
  String rowPlatformFeePct(String pct) {
    return 'Platform fee ($pct%)';
  }

  @override
  String get refundStepCancelled => 'Order cancelled';

  @override
  String get refundStepWeighed => 'Weight came out less';

  @override
  String get refundStepProcessing => 'Refund in progress';

  @override
  String get refundWithin3Days => 'Within 3 working days';

  @override
  String get refundStepArrived => 'Refund received';

  @override
  String get rowRefundTo => 'Refund goes to';

  @override
  String get refundSameMethod => 'The way you paid';

  @override
  String get refundNote => 'Golaghor sends it back the same way you paid.';

  @override
  String get getHelp => 'Get help';

  @override
  String get rowWeightDiff => 'Weight difference';

  @override
  String get rowRefundLink => 'Refund';

  @override
  String get answerExtraBtn => 'Extra weight: reply';

  @override
  String get startWeighing => 'Start loading & weighing';

  @override
  String nTruckBooked(String no) {
    return 'Truck booked: $no';
  }

  @override
  String nTruckBookedBody(String name) {
    return '$name is coming — see your OTP';
  }

  @override
  String nExtraRequest(String no) {
    return 'Extra weight: $no';
  }

  @override
  String nExtraRequestBody(String qty) {
    return 'Scale shows $qty more — approve?';
  }

  @override
  String nExtraApproved(String no) {
    return 'Extra weight approved: $no';
  }

  @override
  String nExtraDeclined(String no) {
    return 'Load only the ordered amount: $no';
  }

  @override
  String nWeightLess(String no) {
    return 'Weight less, refund due: $no';
  }

  @override
  String nLoadedPaid(String no) {
    return 'Loaded and paid: $no';
  }

  @override
  String get traceTitle => 'Traceability record';

  @override
  String traceOrderTitle(String no, String crop, String qty) {
    return '$no · $crop $qty';
  }

  @override
  String traceFarmers(String n) {
    return '$n farmer(s)';
  }

  @override
  String traceDelivered(String date) {
    return 'Delivered $date';
  }

  @override
  String get qrLabel => 'QR';

  @override
  String traceFarmer(String name, String district) {
    return 'Farmer: $name · $district';
  }

  @override
  String traceReady(String date, String grade) {
    return 'Ready $date · grade $grade';
  }

  @override
  String get traceLoadWeigh => 'Loading & digital weight';

  @override
  String traceTransport(String name) {
    return 'Transport: $name';
  }

  @override
  String get traceSelfTransport => 'Transport: buyer\'s own vehicle';

  @override
  String traceDelivery(String place) {
    return 'Delivery: $place';
  }

  @override
  String traceOtpVerified(String time) {
    return '$time · OTP verified';
  }

  @override
  String traceReceived(String time) {
    return '$time · received by buyer';
  }

  @override
  String get traceHeader => 'Golaghor traceability record';

  @override
  String traceOrderLine(String no, String crop, String qty) {
    return '$no · $crop $qty';
  }

  @override
  String traceFarmerLine(
    String name,
    String district,
    String qty,
    String grade,
  ) {
    return 'Farmer: $name, $district · $qty · $grade';
  }

  @override
  String get pdfShort => 'PDF';

  @override
  String get qrShare => 'Share QR';

  @override
  String get oppTitle => 'Market opportunities';

  @override
  String get oppFilterDemand => 'High demand';

  @override
  String get oppFilterPrice => 'Price rising';

  @override
  String get oppFilterBuyer => 'Buyers looking';

  @override
  String oppHighDemand(String crop) {
    return 'High demand · $crop';
  }

  @override
  String oppHighDemandSub(String district, String n) {
    return '$district · $n buyers looking';
  }

  @override
  String oppPriceUp(String crop) {
    return 'Price rising · $crop';
  }

  @override
  String oppPriceUpSub(String pct, String price) {
    return '$pct vs last price · $price/kg';
  }

  @override
  String get oppSell => 'Sell';

  @override
  String oppBuyerSeeking(String crop, String qty) {
    return 'Buyer looking · $crop $qty';
  }

  @override
  String get oppSupply => 'Supply';

  @override
  String oppUpcoming(String crop, String qty) {
    return 'Upcoming demand · $crop $qty';
  }

  @override
  String oppUpcomingSub(String buyer, String month) {
    return '$buyer · needed in $month';
  }

  @override
  String get oppPlan => 'Plan';

  @override
  String get oppEmpty => 'No opportunities right now — check again later';

  @override
  String get planTitle => 'Production planning';

  @override
  String get planIntro => 'Before sowing, see which crops have sure demand';

  @override
  String get seasonRabi => 'Rabi (Nov–Feb)';

  @override
  String get seasonKharif1 => 'Kharif-1';

  @override
  String get seasonKharif2 => 'Kharif-2';

  @override
  String planCropLine(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String planBuyersMore(String name, String n) {
    return '$name +$n';
  }

  @override
  String get planHighDemand => 'high demand';

  @override
  String priceRangeTk(String min, String max) {
    return '৳ $min–$max';
  }

  @override
  String get planEmpty => 'No demand for this season yet';

  @override
  String get planWhenPaid => 'When you get paid';

  @override
  String get planWhenPaidBody =>
      'As soon as the crop is loaded after harvest. No advance money.';

  @override
  String get planCta => 'See demands & take part';

  @override
  String get rescueTitle => 'Other buyers';

  @override
  String get rescueCancelled => 'Order cancelled (before loading)';

  @override
  String rescueCancelledBody(String buyer, String qty, String crop, String no) {
    return '$buyer cancelled the order for $qty $crop ($no). Nothing is cut from you.';
  }

  @override
  String rescueFinding(String crop) {
    return 'Finding buyers for your $crop';
  }

  @override
  String get rescueNone => 'No open demand for this crop right now';

  @override
  String kmShort(String n) {
    return '$n km';
  }

  @override
  String rescueOldPrice(String price) {
    return 'Old price ৳$price/kg';
  }

  @override
  String rescueOldAndMarket(String price, String min, String max) {
    return 'Old price ৳$price/kg · market ৳$min–$max';
  }

  @override
  String get rescueTakeBest => 'Take the best offer';

  @override
  String get rescueRelist => 'Publish again at my price';

  @override
  String get rowTrace => 'Traceability';

  @override
  String get rowRescue => 'Other buyers';

  @override
  String get seeLinkShort => 'See';

  @override
  String get bannerOppTitle => 'Market opportunities';

  @override
  String get bannerOppSub => 'Crops in high demand or rising price';

  @override
  String get bannerPlanTitle => 'Plan your farming';

  @override
  String get bannerPlanSub => 'See sure demand before sowing';

  @override
  String get assignInspTitle => 'Send an inspector';

  @override
  String get assignInspBody =>
      'Your person checks quality and weight at loading. They log in to Golaghor with this number.';

  @override
  String get fieldInspName => 'Inspector\'s name';

  @override
  String get fieldInspPhone => 'Inspector\'s mobile number';

  @override
  String get sendInvite => 'Send invite';

  @override
  String get errNameRequired => 'Enter a name';

  @override
  String get errInspNotSelf => 'You can\'t use your own number';

  @override
  String inspInviteText(String name, String no, String crop, String phone) {
    return '$name, you are the inspector for $no · $crop on Golaghor. Open the app and log in with this number: $phone';
  }

  @override
  String get inspHomeTitle => 'Inspector\'s work';

  @override
  String inspInvitedBy(String buyer) {
    return '$buyer made you the inspector';
  }

  @override
  String inspOrderLine(String no, String crop, String qty, String date) {
    return '$no · $crop $qty · $date';
  }

  @override
  String inspTruckBooked(String name) {
    return 'Truck booked · $name';
  }

  @override
  String inspTruckBookedBody(String place) {
    return '$place · start the quality check when the truck arrives';
  }

  @override
  String inspPickups(String n) {
    return 'Pickups ($n)';
  }

  @override
  String get inspNone => 'No inspection work yet';

  @override
  String numberedName(String n, String name) {
    return '$n. $name';
  }

  @override
  String get inspStart => 'Start';

  @override
  String get inspClosed => 'Closed';

  @override
  String get inspChalan => 'Shipment info';

  @override
  String get inspGrade => 'Grade';

  @override
  String inspGradeValue(String grade) {
    return 'Grade $grade (as agreed)';
  }

  @override
  String get inspTruck => 'Truck';

  @override
  String get callDriver => 'Call driver';

  @override
  String get seeRouteMap => 'Route on map';

  @override
  String qcTitle(String name) {
    return 'Quality check · $name';
  }

  @override
  String partialTitle(String name) {
    return 'Partial load · $name';
  }

  @override
  String cancelLoadTitle(String name) {
    return 'Cancel load · $name';
  }

  @override
  String gradeChecklist(String grade) {
    return 'Grade $grade checklist';
  }

  @override
  String get chkSize => 'Minimum size is right';

  @override
  String get chkNoSprout => 'No green parts or sprouts';

  @override
  String get chkFirm => 'Firm, not soft or rotten';

  @override
  String chkDamage(String pct) {
    return 'At most $pct% damaged';
  }

  @override
  String get chkPacking => 'Packing is right';

  @override
  String get chkOk => 'OK';

  @override
  String get chkProblem => 'Problem';

  @override
  String get rowDigitalWeight => 'Digital weight';

  @override
  String goodsPhotos(String n, String max) {
    return 'Photos of the crop ($n/$max)';
  }

  @override
  String rejectPhotos(String n, String max) {
    return 'Photos of left-out crop ($n/$max)';
  }

  @override
  String get decApprove => 'Approve';

  @override
  String get decApproved => 'Approved';

  @override
  String get decPartial => 'Partial';

  @override
  String get decPartialTake => 'Partial (take less)';

  @override
  String get decCancel => 'Cancel';

  @override
  String get qcNote =>
      'After approval, money is released when the farmer gives the OTP. This report is final.';

  @override
  String get submitReport => 'Submit report';

  @override
  String get howMuchTake => 'How much will you take?';

  @override
  String get rowLeftOut => 'Left out';

  @override
  String get howMuchGood => 'How many kg of good crop?';

  @override
  String scaleWeight(String qty) {
    return '$qty (from scale)';
  }

  @override
  String get reasonSmall => 'Too small';

  @override
  String get reasonDamaged => 'Damaged';

  @override
  String get reasonLowGrade => 'Lower grade';

  @override
  String partialNote(String qty) {
    return 'Only $qty is loaded. The farmer is paid for it with the OTP. The buyer gets the rest of the crop price and fee back. The fare stays the same.';
  }

  @override
  String errAcceptKg(String qty) {
    return 'Enter more than 0 and less than $qty';
  }

  @override
  String get whyCancel => 'Why are you cancelling?';

  @override
  String get rowWillLoad => 'Will load';

  @override
  String get cancelLoadNote =>
      'Nothing is loaded and the farmer gets no money. The buyer gets the crop price and fee back. The buyer pays the truck fare.';

  @override
  String get cancelLoadBtn => 'Cancel load';

  @override
  String get cancelLoadQ => 'Cancel this load?';

  @override
  String get cancelLoadBody =>
      'The order will be cancelled. This report can\'t be changed.';

  @override
  String get reportSentTitle => 'Report sent';

  @override
  String get reportReachedBuyer => 'The report reached the buyer';

  @override
  String get rowStop => 'Stop';

  @override
  String stopLine(String i, String n, String name) {
    return '$i/$n · $name';
  }

  @override
  String get rowDecision => 'Decision';

  @override
  String decApproveLine(String ok, String n) {
    return 'Approved · $ok/$n OK';
  }

  @override
  String decPartialLine(String qty) {
    return 'Partial · $qty taken';
  }

  @override
  String decCancelLine(String reason) {
    return 'Cancelled · $reason';
  }

  @override
  String get rowWeight => 'Weight';

  @override
  String weightLeftOut(String w, String left) {
    return '$w ($left left out)';
  }

  @override
  String weightNoneTaken(String w) {
    return '$w (nothing taken)';
  }

  @override
  String get rowTime => 'Time';

  @override
  String get whatNext => 'What happens next';

  @override
  String get nextApprove =>
      'The crop is loaded once the driver gets the farmer\'s OTP. This report can\'t be changed.';

  @override
  String nextPartial(String qty) {
    return 'The driver loads only $qty. This report can\'t be changed.';
  }

  @override
  String get nextCancel =>
      'Nothing is loaded at this stop. This report can\'t be changed.';

  @override
  String get nextPickups => 'See next pickups';

  @override
  String get inspReportTitle => 'Inspection report';

  @override
  String get loadRecordTitle => 'Load record';

  @override
  String get loadDoneBadge => 'Loaded';

  @override
  String get rowInspector => 'Inspector';

  @override
  String inspYours(String name) {
    return '$name (yours)';
  }

  @override
  String get inspNotSent => 'Not sent';

  @override
  String get rowTimePlace => 'Time & place';

  @override
  String get rowWeighedBy => 'Weighed by';

  @override
  String weighedByDriver(String name) {
    return 'Driver $name';
  }

  @override
  String get weighedBySelf => 'You (own vehicle)';

  @override
  String get rowReceivedFarmer => 'Farmer received';

  @override
  String get rowChecklist => 'Checklist';

  @override
  String okOutOf(String ok, String n) {
    return '$ok/$n OK';
  }

  @override
  String get rowTaken => 'Taken';

  @override
  String leftOutWhy(String qty, String reason) {
    return '$qty ($reason)';
  }

  @override
  String get rowCropValueBack => 'Crop price back';

  @override
  String reasonNotMet(String reason) {
    return 'Quality not met ($reason)';
  }

  @override
  String get yourResponsibility => 'Quality and amount are your responsibility';

  @override
  String get yourResponsibilityBody =>
      'You sent no inspector. The driver only took the weight and photos. You can\'t complain about quality after loading.';

  @override
  String get yourResponsibilitySelf =>
      'You weighed and confirmed the load yourself. You can\'t complain about quality or weight after loading.';

  @override
  String get reportIsProof => 'This report is the proof';

  @override
  String get reportIsProofBody =>
      'Your inspector approved the quality at loading. If there is a dispute later, this report is checked; the farmer\'s money can\'t be held.';

  @override
  String get fareSame => 'The truck fare stays the same';

  @override
  String fareSameBody(String fare) {
    return 'You booked the truck, so you pay the $fare fare. The refund comes back the same way within 3 working days.';
  }

  @override
  String get farePayYou => 'You pay the truck fare';

  @override
  String farePayYouBody(String fare) {
    return 'You booked the truck, so the $fare fare is not refunded.';
  }

  @override
  String get rowInspectorAssign => 'Inspector';

  @override
  String get inspSend => 'Send';

  @override
  String get rowInspReport => 'Inspection report';

  @override
  String get rowLoadRecord => 'Load record';

  @override
  String inspPresent(String name) {
    return '$name (buyer\'s)';
  }

  @override
  String get rowInspDecision => 'Inspector\'s decision';

  @override
  String get inspWaitNote =>
      'Waiting for the inspector\'s decision — load after the report';

  @override
  String inspPartialNote(String qty) {
    return 'The inspector approved only $qty';
  }

  @override
  String get rowInspectorWork => 'Inspector\'s work';

  @override
  String nInspectionDone(String no) {
    return 'Inspection report: $no';
  }

  @override
  String get rowInspReason => 'Reason';

  @override
  String get errInspPhoto => 'Take at least one photo';

  @override
  String get rowLeftOutPast => 'Left out';

  @override
  String get rowLeftKm => 'Distance left';

  @override
  String get rowTruckSeen => 'Truck location';

  @override
  String liveMinAgo(String n) {
    return '$n min ago';
  }

  @override
  String get liveJustNow => 'Just now';

  @override
  String get liveOff => 'Shows while the driver\'s app is open';

  @override
  String get voiceMessage => 'Voice message';

  @override
  String voiceMessageLen(String len) {
    return 'Voice message · $len';
  }

  @override
  String voiceRecording(String len) {
    return 'Recording voice... $len';
  }

  @override
  String get voiceSend => 'Send';

  @override
  String get voiceSendSub => 'Send the recorded message';

  @override
  String get voiceCancel => 'Cancel';

  @override
  String get voiceCancelSub => 'Delete the recording';

  @override
  String get micDenied => 'Allow the microphone (Settings → Apps → Golaghor)';

  @override
  String get voiceSearchListening => 'Listening... say a crop or area';

  @override
  String get voiceSearchStop => 'Stop';

  @override
  String get voiceSearchStopSub => 'Tap when you finish speaking';

  @override
  String get voiceSearchExample => 'Example';

  @override
  String get voiceSearchExampleSub => '“Tomato”, “Potato Netrokona”';

  @override
  String get voiceSearchUnavailable =>
      'Voice search is not available on this phone';

  @override
  String get voiceSearchNoWords =>
      'Didn\'t catch that. Tap the mic and try again';

  @override
  String get notifChannelName => 'Golaghor alerts';

  @override
  String unreadNotifications(int count) {
    return '$count unread notifications';
  }

  @override
  String callingToast(String name) {
    return 'Calling $name…';
  }

  @override
  String get callNotReady => 'Calling is not set up yet. Please try later.';

  @override
  String get callNeedMic => 'Allow the microphone to make calls';

  @override
  String get callRinging => 'Ringing…';

  @override
  String get callConnecting => 'Connecting…';

  @override
  String callVideoOn(String time) {
    return 'Video call · $time';
  }

  @override
  String callVoiceOn(String time) {
    return 'Call · $time';
  }

  @override
  String get callIncoming => 'Incoming call…';

  @override
  String get callIncomingVideo => 'Incoming video call…';

  @override
  String get callSpeaker => 'Speaker';

  @override
  String get callCamera => 'Camera';

  @override
  String get callMic => 'Mic';

  @override
  String get callEnd => 'End';

  @override
  String get callAnswer => 'Answer';

  @override
  String get callDecline => 'Decline';

  @override
  String get callDeclined => 'Call declined';

  @override
  String get callNoAnswer => 'No answer';

  @override
  String get callEnded => 'Call ended';

  @override
  String nCallMissed(String name) {
    return 'Missed call from $name';
  }

  @override
  String get photoAdded => '✓ Photo added · tap to take again';

  @override
  String get photoUpdated => 'Photo updated';

  @override
  String get changePhoto => 'Change photo';

  @override
  String photosAdded(String n) {
    return '✓ $n photos added · tap to take again';
  }

  @override
  String get pdfMaking => 'Making PDF...';

  @override
  String get locAskTitle => 'Allow location to share your truck\'s position';

  @override
  String get locAskBody =>
      'During a trip, the buyer and farmer see your truck on the map. In the next box, tap “While using the app”.';

  @override
  String get locAskLater => 'Later';

  @override
  String get locAskAllow => 'Allow';

  @override
  String get stdTitle => 'Quality standard';

  @override
  String stdHeading(String crop, String grade) {
    return '$crop · grade $grade';
  }

  @override
  String get stdRowSize => 'Minimum size';

  @override
  String get stdRowColor => 'Colour';

  @override
  String get stdRowRipe => 'Ripeness';

  @override
  String get stdRowDamage => 'Max damaged';

  @override
  String get stdRowPack => 'Packaging';

  @override
  String get stdWhenTitle => 'When it is checked';

  @override
  String get stdWhenBody =>
      'Only at loading (your inspector\'s checklist). After delivery, no refund can be claimed with this standard.';

  @override
  String get stdUse => 'Use this standard';

  @override
  String stdCheckLine(String label, String value) {
    return '$label: $value';
  }

  @override
  String stdSizeAcross(String n) {
    return '$n cm across';
  }

  @override
  String stdSizeLength(String n) {
    return '$n cm long';
  }

  @override
  String stdSizeGrams(String n) {
    return '$n g each';
  }

  @override
  String stdSizeGrain(String n) {
    return 'Full grains, empty ≤$n%';
  }

  @override
  String get stdSizeEven => 'Even size';

  @override
  String stdDamagePct(String n) {
    return '$n%';
  }

  @override
  String stdColorRed(String n) {
    return '$n% red';
  }

  @override
  String get stdColorPotato => 'Light brown, no green patches';

  @override
  String get stdColorPaddy => 'Golden';

  @override
  String get stdColorEggplant => 'Bright purple, glossy';

  @override
  String get stdColorOnion => 'Reddish, dry skin';

  @override
  String get stdColorChili => 'Bright green';

  @override
  String get stdColorMango => 'Mature green to yellow';

  @override
  String get stdColorNatural => 'Natural colour';

  @override
  String get stdRipeTomato => 'Half-ripe to ripe';

  @override
  String get stdRipePotato => 'Mature, firm skin';

  @override
  String stdRipePaddy(String n) {
    return 'Fully ripe, moisture ≤$n%';
  }

  @override
  String get stdRipeEggplant => 'Young, soft seeds';

  @override
  String get stdRipeOnion => 'Fully cured, no sprouts';

  @override
  String get stdRipeChili => 'Fresh and firm';

  @override
  String get stdRipeMango => 'Mature, firm';

  @override
  String get stdRipeMarket => 'Ready for market';

  @override
  String stdPackCrate(String n) {
    return '$n kg crate';
  }

  @override
  String stdPackSack(String n) {
    return '$n kg sack';
  }

  @override
  String stdPackNet(String n) {
    return '$n kg net bag';
  }

  @override
  String stdPackBag(String n) {
    return '$n kg bag';
  }

  @override
  String get stdPackClean => 'Clean sack or crate';

  @override
  String get tpProfileTitle => 'Transporter profile';

  @override
  String get tpVerifiedDriver => 'Verified driver';

  @override
  String get tpDriver => 'Driver';

  @override
  String tpSince(String date) {
    return 'On Golaghor since $date';
  }

  @override
  String get tpTrips => 'Completed trips';

  @override
  String get tpOnTime => 'On time';

  @override
  String get tpCancelRate => 'Cancel rate';

  @override
  String get tpDamage => 'Damage complaints';

  @override
  String tpTruckLine(String type, String cap, String status) {
    return '$type · $cap · $status';
  }

  @override
  String get tpFitness => 'Fitness & licence';

  @override
  String get tpValid => 'Valid';

  @override
  String get tpMainRoute => 'Main route';

  @override
  String tpRoute(String from, String to) {
    return '$from – $to';
  }

  @override
  String get tpChoose => 'Choose this transporter';

  @override
  String pctText(String n) {
    return '$n%';
  }

  @override
  String get supTitle => 'Suppliers';

  @override
  String get supSearchHint => 'Search farmer or area';

  @override
  String get supAll => 'All';

  @override
  String get supFav => 'Favourites';

  @override
  String get supNew => 'New';

  @override
  String get supFavTag => 'Favourite';

  @override
  String supLine(String district, String rating, String n) {
    return '$district · $rating · $n deals';
  }

  @override
  String get supEmpty => 'No suppliers yet — order from the market';

  @override
  String get supProfileTitle => 'Supplier profile';

  @override
  String supStatusLine(String status, String district) {
    return '$status · $district';
  }

  @override
  String get supQuality => 'Quality score';

  @override
  String get supTotal => 'Total supplied';

  @override
  String supPerf(String n) {
    return 'Performance ($n months)';
  }

  @override
  String get supCommitted => 'Promised vs delivered';

  @override
  String get supAcceptance => 'Quality acceptance';

  @override
  String get supAddFav => 'Add to favourites';

  @override
  String get supRemoveFav => 'Remove favourite';

  @override
  String get toastFavAdded => 'Added to favourites';

  @override
  String get toastFavRemoved => 'Removed from favourites';

  @override
  String get toastUndo => 'Undo';

  @override
  String get procTitle => 'Procurement dashboard';

  @override
  String get procOpenDemands => 'Open demands';

  @override
  String get procCommitted => 'Total committed';

  @override
  String get procFarmers => 'Farmers joined';

  @override
  String get procSafePay => 'Safe payment';

  @override
  String procPeople(String n) {
    return '$n';
  }

  @override
  String get procOngoing => 'Ongoing procurement';

  @override
  String procLine(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String get procNone => 'No open demands';

  @override
  String get procAnalytics => 'Purchase analytics';

  @override
  String get procAnalyticsSub => 'Spend, price trend and supplier performance';

  @override
  String get anMonth => 'This month';

  @override
  String get an3Months => '3 months';

  @override
  String get anYear => 'This year';

  @override
  String get anSpend => 'Total spend';

  @override
  String anAvgPrice(String crop) {
    return 'Avg price ($crop)';
  }

  @override
  String get anSuppliers => 'Supplier performance';

  @override
  String get anDeliveredLeft => 'Delivered / left';

  @override
  String get anWithInspector => 'Orders with inspector';

  @override
  String anSlash(String a, String b) {
    return '$a / $b';
  }

  @override
  String get anNoData => 'No orders in this period';

  @override
  String takaLakh(String n) {
    return '৳ $n lakh';
  }

  @override
  String get retTitle => 'Return loads';

  @override
  String get retMyRoute => 'My return route';

  @override
  String retRouteSub(String from, String to, String date, String space) {
    return '$from → $to · $date · $space free';
  }

  @override
  String get retChange => 'Change';

  @override
  String get retSetRoute => 'Set return route';

  @override
  String get retNoRouteSub =>
      'Tell us where you\'re heading back, we\'ll show loads on the way';

  @override
  String retForYou(String from, String to) {
    return 'Loads for you on $from → $to';
  }

  @override
  String retLoadTitle(String from, String to) {
    return '$from → $to';
  }

  @override
  String retLoadSub(String crop, String qty, String when) {
    return '$crop · $qty · $when';
  }

  @override
  String get retAccept => 'Take this return load';

  @override
  String get retFrom => 'From';

  @override
  String retFromHere(String place) {
    return '$place (current location)';
  }

  @override
  String get retTo => 'Going back to';

  @override
  String get retWhen => 'When';

  @override
  String get retToday => 'Today';

  @override
  String get retTomorrow => 'Tomorrow';

  @override
  String get retSpace => 'Free space in truck';

  @override
  String get retSave => 'Save and find loads';

  @override
  String get retNoneTitle => 'No matching load yet';

  @override
  String retNoneSub(String from, String to) {
    return 'No suitable load on $from → $to right now.';
  }

  @override
  String get retPaidTitle => 'You got your last fare';

  @override
  String retPaidBody(String no, String fare) {
    return '$no · $fare sent.';
  }

  @override
  String get retOtherDest => 'Pick another destination';

  @override
  String get retOther => 'Other';

  @override
  String get retAlertOn => 'We\'ll tell you as soon as a load comes (alert on)';

  @override
  String get retSearchAgain => 'Search again';

  @override
  String get retGoHome => 'Go home';

  @override
  String get retDoneBar => 'Load confirmed';

  @override
  String get retDoneTitle => 'Return load confirmed';

  @override
  String retPickupLine(String date, String km) {
    return '$date · $km km away';
  }

  @override
  String get retPaySafeTitle => 'Payment safe';

  @override
  String get retPaySafeBody =>
      'The fare is held in safe payment. You get it when you reach the buyer.';

  @override
  String get retNavigate => 'Start navigation';

  @override
  String get retCallBuyer => 'Call buyer';

  @override
  String get retBidSent =>
      'Fare offer sent — we\'ll tell you when the buyer books';

  @override
  String nReturnLoad(String from, String to) {
    return 'Return load found: $from → $to';
  }

  @override
  String get matchTitle => 'Farmer matching';

  @override
  String matchHeader(String crop, String qty, String place) {
    return '$crop – $qty · $place';
  }

  @override
  String get matchOk => 'Matched';

  @override
  String get matchWait => 'Waiting';

  @override
  String matchSub(String district, String qty) {
    return '$district · $qty';
  }

  @override
  String get matchNone => 'No farmer has offered supply yet';

  @override
  String get addToPool => 'Add to pool';

  @override
  String get poolTitle => 'Digital pooling';

  @override
  String poolTarget(String crop) {
    return '$crop – total target';
  }

  @override
  String poolFarmers(String n) {
    return 'Farmers in pool ($n)';
  }

  @override
  String poolFarmerSub(String qty, String date) {
    return '$qty · pickup $date';
  }

  @override
  String get rowLeft => 'Left';

  @override
  String get rowAvgPrice => 'Average price';

  @override
  String get poCreate => 'Create purchase order';

  @override
  String get poTitle => 'Purchase order (PO)';

  @override
  String get rowPoNo => 'PO no.';

  @override
  String get rowTotalQty => 'Total quantity';

  @override
  String rowFarmersN(String n) {
    return '$n farmer(s)';
  }

  @override
  String get rowTotalValue => 'Total value';

  @override
  String get poSplit => 'Split by farmer';

  @override
  String get poConfirm => 'Confirm PO';

  @override
  String poDone(String no, String n) {
    return '$no confirmed — $n order(s) created';
  }

  @override
  String get attachTitle => 'Send a file';

  @override
  String get attachPhoto => 'Photo';

  @override
  String get attachPhotoSub => 'From gallery or camera';

  @override
  String get attachVideo => 'Video';

  @override
  String get attachVideoSub => 'Video of the crop or goods';

  @override
  String get attachDoc => 'Document';

  @override
  String get attachDocSub => 'Receipt, contract or PDF';

  @override
  String get fileSending => 'Sending…';

  @override
  String fileTooLarge(String mb) {
    return 'The file is too large (max $mb MB)';
  }

  @override
  String get videoTapToWatch => 'Tap to watch';

  @override
  String get fileOpenFailed => 'Could not open the file';

  @override
  String get rowUploaded => 'Uploaded';

  @override
  String get rowExpiry => 'Expires';

  @override
  String get docVerified => '✓ Verified';

  @override
  String get docPending => 'Being checked';

  @override
  String get docRejected => 'Rejected — please upload again';

  @override
  String get docExpired => 'Expired';

  @override
  String get docPdf => 'Download PDF';

  @override
  String get docReupload => 'Upload again';

  @override
  String get docUpload => 'Upload';

  @override
  String get docNoneTitle => 'Not uploaded yet';

  @override
  String get docNoneBody =>
      'Take a clear photo of the paper and upload it. A moderator will check it.';

  @override
  String get docExpiryPick => 'Pick the paper\'s expiry date';

  @override
  String get docSent => 'Uploaded — a moderator will check it';

  @override
  String nDocOk(String doc) {
    return '$doc verified';
  }

  @override
  String get nDocOkBody => 'Your paper is now ready for export';

  @override
  String nDocRejected(String doc) {
    return '$doc rejected';
  }

  @override
  String get nDocRejectedBody => 'Please upload a clear photo again';

  @override
  String get sharedTitle => 'Loads for free space';

  @override
  String get sharedNoTripTitle => 'No running trip now';

  @override
  String get sharedNoTripBody =>
      'When you have a job, loads along its route that fit your free space show here.';

  @override
  String sharedTruckSub(String cap, String now, String no) {
    return '$cap truck · now $now ($no)';
  }

  @override
  String get truckFull => 'Truck load';

  @override
  String ofTons(String a, String b) {
    return '$a / $b';
  }

  @override
  String loadsOnRoute(String route) {
    return 'Loads on your route ($route)';
  }

  @override
  String get sharedNone =>
      'No load on your route fits the free space right now.';

  @override
  String cropDashQty(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String get sharedRuleTitle => 'Separate job, separate fare';

  @override
  String get sharedRuleBody =>
      'This load has its own safe payment. You get its fare when you reach its buyer.';

  @override
  String get addLoad => 'Add load';

  @override
  String get addThisLoad => 'Add this load';

  @override
  String sharedFits(String t) {
    return 'Your truck has $t free; this load fits.';
  }

  @override
  String get onRoute => 'On the route';

  @override
  String detourKm(String km) {
    return '$km km detour';
  }

  @override
  String loadSubStops(String crop, String qty, String n) {
    return '$crop · $qty · $n pickups';
  }

  @override
  String pickupsLine(String n, String places) {
    return '$n pickups · $places';
  }

  @override
  String pickupsN(String n) {
    return '$n pickups';
  }

  @override
  String stopsMany(String n) {
    return '$n pickups + 1 delivery';
  }

  @override
  String stepLoadedAt(String time) {
    return 'Loaded · $time';
  }

  @override
  String startWeighingStop(String n) {
    return 'Pickup $n: start loading and weighing';
  }

  @override
  String get farmerDeliveredTitle => 'Delivery confirmation';

  @override
  String get rowSentQty => 'Quantity sent';

  @override
  String get rowReceivedQty => 'Quantity received';

  @override
  String get rowDeliveredAt => 'Delivered at';

  @override
  String get farmerDeliveredNote =>
      'The crop reached the buyer. Your money was sent at loading (final).';

  @override
  String get rateBuyerBtn => 'Rate the buyer';

  @override
  String get seePayStatus => 'See payment status';

  @override
  String get seeDeliveryBtn => 'Delivery and rating';

  @override
  String get howWasDeal => 'How was the deal?';

  @override
  String get tagOnTimePay => 'On-time payment';

  @override
  String get tagGoodBehaviour => 'Good behaviour';

  @override
  String get tagFairWeight => 'Fair weight';

  @override
  String nFarmerDelivered(String no) {
    return 'Reached the buyer: $no';
  }

  @override
  String get permTitle => 'A few permissions needed';

  @override
  String get permSub =>
      'Why each is needed is written below. You can change them later in Settings.';

  @override
  String get permLocation => 'Location';

  @override
  String get permLocationWhy => 'To find nearby buyers, pickups and trucks';

  @override
  String get permCamera => 'Camera';

  @override
  String get permCameraWhy => 'To take crop photos and delivery proof';

  @override
  String get permNotif => 'Notifications';

  @override
  String get permNotifWhy => 'To hear about new offers and payments';

  @override
  String get permAllow => 'Allow';

  @override
  String get permGiven => '✓ Given';

  @override
  String get permAllowAll => 'Allow all';

  @override
  String get permLater => 'Later';

  @override
  String get payStatusTitle => 'Payment status';

  @override
  String get payHeldLine => 'Held in safe payment · released at the buyer';

  @override
  String get paySentLine => 'The fare was sent to your account';

  @override
  String get payStepCustomer => 'Customer paid in';

  @override
  String get payStepDelivered => 'Delivery confirmed';

  @override
  String get payStepSent => 'Sent to your account';

  @override
  String get routeMapTitle => 'Route map';

  @override
  String get routeOptimized => 'Optimized route';

  @override
  String get routeYours => 'Your order';

  @override
  String get routeOptimizedShort => 'Optimized';

  @override
  String get rowTotalDistance => 'Total distance';

  @override
  String get rowEstTime => 'Estimated time';

  @override
  String get rowSaving => 'Saving';

  @override
  String savingKm(String km) {
    return '$km km less';
  }

  @override
  String get savingNone => 'This order is already the shortest';

  @override
  String get startNav => 'Start navigation';

  @override
  String get navTitle => 'Navigation';

  @override
  String get rowNextStop => 'Next stop';

  @override
  String get rowDistTime => 'Distance / time';

  @override
  String get arrivedBtn => 'Arrived';

  @override
  String minutesShort(String m) {
    return '$m min';
  }

  @override
  String hoursOnly(String h) {
    return '$h h';
  }

  @override
  String hoursMinutes(String h, String m) {
    return '$h h $m min';
  }

  @override
  String get suspendedTitle => 'Your account is suspended';

  @override
  String get suspendedBody =>
      'An admin has paused your account. You can\'t use the app until it is turned back on. Call the helpline to find out why or to get it reactivated.';

  @override
  String get adminOrdersTitle => 'All orders';

  @override
  String get adminOrdersEmpty => 'No orders yet';

  @override
  String get adminOrdersEmptyBody =>
      'Orders will show here once buyers place them.';

  @override
  String adminOrderLine(String no, String farmer, String buyer, String total) {
    return '$no · $farmer → $buyer · $total';
  }

  @override
  String get nDocOkDriverBody => 'A moderator has checked your paper';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get addMorePhotos => 'Add more photos';

  @override
  String get statusWithdrawn => 'Withdrawn';

  @override
  String get editListingTitle => 'Edit listing';

  @override
  String get editListing => 'Edit';

  @override
  String get withdrawListing => 'Withdraw';

  @override
  String get withdrawListingTitle => 'Withdraw this listing?';

  @override
  String get withdrawListingBody =>
      'Buyers will no longer see this crop. You can edit it and send it again later.';

  @override
  String get listingWithdrawnToast => 'Listing withdrawn';

  @override
  String get listingHasOrder =>
      'An order is running on this crop. You can edit or withdraw it after the order ends.';

  @override
  String get listingUpdated => 'Listing updated';

  @override
  String get commonNo => 'No';

  @override
  String get withdrawOffer => 'Withdraw offer';

  @override
  String get withdrawOfferTitle => 'Withdraw this offer?';

  @override
  String get withdrawOfferBody =>
      'The farmer will be told that you withdrew the offer.';

  @override
  String get offerWithdrawnToast => 'Offer withdrawn';

  @override
  String nOfferWithdrawn(String crop) {
    return 'Offer withdrawn: $crop';
  }

  @override
  String nOfferWithdrawnBody(String buyer) {
    return '$buyer withdrew the offer';
  }

  @override
  String get pmRemove => 'Remove';

  @override
  String get pmRemoveTitle => 'Remove payment method?';

  @override
  String pmRemoveBody(String method) {
    return '$method will be removed from your list.';
  }

  @override
  String get pmRemoved => 'Payment method removed';

  @override
  String get pmChooseDefault => 'Choose a new default method';

  @override
  String get helplineNumber => '+8801700000005';
}
