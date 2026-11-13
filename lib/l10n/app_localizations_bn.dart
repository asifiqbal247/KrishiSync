// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Golaghor';

  @override
  String get splashTagline => 'কৃষির সাথে, আপনার পাশে';

  @override
  String splashVersion(String version) {
    return 'সংস্করণ $version';
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
  String get langContinue => 'এগিয়ে যান';

  @override
  String get onb1Title => 'সরাসরি ক্রেতার কাছে বিক্রি করুন';

  @override
  String get onb1Body =>
      'মধ্যস্বত্বভোগী ছাড়াই ন্যায্য দাম পান। নিজের ফসলের দাম নিজেই ঠিক করুন।';

  @override
  String get onb2Title => 'নিরাপদ লেনদেনে নিশ্চিন্ত থাকুন';

  @override
  String get onb2Body =>
      'মাল গাড়িতে উঠলেই কৃষকের টাকা, ক্রেতার কাছে পৌঁছালেই ট্রান্সপোর্টারের টাকা।';

  @override
  String get onb3Title => 'সহজে ট্রাক, ঝামেলা ছাড়াই পরিবহন';

  @override
  String get onb3Body =>
      'ক্রেতা ট্রাক বুক করেন। কৃষক ও ক্রেতা দুজনেই ট্রাকের অবস্থান দেখতে পান।';

  @override
  String get onbNext => 'পরবর্তী';

  @override
  String get onbStart => 'শুরু করুন';

  @override
  String get onbSkip => 'এড়িয়ে যান';

  @override
  String get loginTitle => 'লগইন / নিবন্ধন';

  @override
  String get loginHeading => 'আপনার মোবাইল নম্বর দিন';

  @override
  String get loginSub => 'আমরা একটি ৬ সংখ্যার কোড পাঠাব';

  @override
  String get loginPhoneLabel => 'মোবাইল নম্বর';

  @override
  String get loginPhoneHint => '01X XXXX XXXX';

  @override
  String get loginCountryCode => '+880';

  @override
  String get loginTerms =>
      'চালিয়ে গেলে আপনি শর্তাবলী ও গোপনীয়তা নীতিতে সম্মত হচ্ছেন।';

  @override
  String get loginSendCode => 'কোড পাঠান';

  @override
  String get loginInvalidPhone => 'সঠিক ১১ সংখ্যার মোবাইল নম্বর দিন';

  @override
  String get otpTitle => 'কোড যাচাই';

  @override
  String get otpHeading => 'কোড লিখুন';

  @override
  String otpSub(String phone) {
    return '$phone নম্বরে পাঠানো ৬ সংখ্যার কোড লিখুন';
  }

  @override
  String get otpNoCode => 'কোড পাননি?';

  @override
  String otpResendIn(String time) {
    return 'আবার পাঠান ($time)';
  }

  @override
  String get otpResend => 'আবার পাঠান';

  @override
  String get otpVerify => 'যাচাই করুন';

  @override
  String get otpWrong => 'কোডটি সঠিক নয়। আবার চেষ্টা করুন।';

  @override
  String get roleTitle => 'আপনি কে?';

  @override
  String get roleSub => 'আপনার ভূমিকায় চাপ দিন';

  @override
  String get roleFarmer => 'কৃষক';

  @override
  String get roleFarmerSub => 'ফসল বিক্রি করুন, ক্রেতা খুঁজুন';

  @override
  String get roleBuyer => 'ক্রেতা (ব্যবসা)';

  @override
  String get roleBuyerSub => 'ফসল কিনুন, সরবরাহ সংগ্রহ করুন';

  @override
  String get roleTransporter => 'পরিবহনকারী';

  @override
  String get roleTransporterSub => 'লোড খুঁজুন, ট্রিপ সম্পন্ন করুন';

  @override
  String get roleModerator => 'মডারেটর';

  @override
  String get roleAdmin => 'অ্যাডমিন';

  @override
  String get profileSetupTitle => 'প্রোফাইল তৈরি';

  @override
  String get profileAddPhoto => 'প্রোফাইল ছবি যোগ করুন';

  @override
  String get profileFullName => 'পুরো নাম';

  @override
  String get profileFullNameHint => 'আপনার নাম লিখুন';

  @override
  String get profileDivision => 'বিভাগ';

  @override
  String get profileDistrictUpazilaUnion => 'জেলা › উপজেলা › ইউনিয়ন';

  @override
  String get profileVillage => 'গ্রাম / পাড়া';

  @override
  String get profileVillageHint => 'নাম লিখুন বা ম্যাপে পিন দিন';

  @override
  String get profileNid => 'NID নম্বর (ঐচ্ছিক)';

  @override
  String get profileNidHint => 'যাচাইয়ের জন্য';

  @override
  String get profileDone => 'সম্পন্ন করুন';

  @override
  String get selectHint => 'নির্বাচন করুন';

  @override
  String get commonBack => 'পেছনে';

  @override
  String get commonSeeAll => 'সব দেখুন';

  @override
  String get commonSearch => 'খুঁজুন';

  @override
  String get commonRetry => 'আবার চেষ্টা করুন';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get commonConfirm => 'নিশ্চিত করুন';

  @override
  String get commonSave => 'সংরক্ষণ করুন';

  @override
  String get commonLoading => 'লোড হচ্ছে…';

  @override
  String get commonRequired => 'এই ঘরটি পূরণ করুন';

  @override
  String get errorGeneric => 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get errorNetwork => 'ইন্টারনেট সংযোগ নেই';

  @override
  String get errorUpload => 'ছবি আপলোড হয়নি। আবার চেষ্টা করুন।';

  @override
  String get errorPermission => 'এই কাজের অনুমতি আপনার নেই';

  @override
  String get unitKg => 'কেজি';

  @override
  String get currencySymbol => '৳';

  @override
  String get errorTooManyRequests =>
      'অনেকবার চেষ্টা হয়েছে। কিছুক্ষণ পর আবার চেষ্টা করুন।';

  @override
  String get locTitleDivision => 'এলাকা বাছুন';

  @override
  String get locTitleDistrict => 'জেলা বাছুন';

  @override
  String get locTitleUpazila => 'উপজেলা বাছুন';

  @override
  String get locTitleVillage => 'গ্রাম ও ঠিকানা';

  @override
  String get locUseGps => 'আমার বর্তমান অবস্থান ব্যবহার করুন';

  @override
  String get locGps => 'GPS';

  @override
  String get locGpsLocating => 'অবস্থান খোঁজা হচ্ছে…';

  @override
  String get locGpsFailed =>
      'অবস্থান পাওয়া যায়নি। লোকেশন চালু করে আবার চেষ্টা করুন।';

  @override
  String get locRecent => 'সাম্প্রতিক ঠিকানা';

  @override
  String get locMapPinSaved => 'ম্যাপ পিন সেভ করা';

  @override
  String get locSearchAll => 'বিভাগ, জেলা, উপজেলা বা গ্রাম খুঁজুন';

  @override
  String get locSearchDistrict => 'জেলা খুঁজুন';

  @override
  String get locSearchUpazila => 'উপজেলা খুঁজুন';

  @override
  String locStep(String step, String total, String level) {
    return 'ধাপ $step/$total · $level';
  }

  @override
  String get locLevelDivision => 'বিভাগ';

  @override
  String get locLevelDistrict => 'জেলা';

  @override
  String get locLevelUpazila => 'উপজেলা';

  @override
  String get locLevelUnionVillage => 'ইউনিয়ন ও গ্রাম';

  @override
  String locDivisionPill(String name) {
    return '$name বিভাগ';
  }

  @override
  String locDistrictCount(String count) {
    return '$countটি জেলা';
  }

  @override
  String locUpazilaCount(String count) {
    return '$countটি উপজেলা';
  }

  @override
  String get locUnionLabel => 'ইউনিয়ন / পৌরসভা';

  @override
  String get locUnionHint => 'তালিকা থেকে বাছুন';

  @override
  String get locVillageLabel => 'গ্রাম / পাড়া / মহল্লা';

  @override
  String get locVillageHint => 'নাম লিখুন বা মাইকে বলুন';

  @override
  String get locLandmarkLabel => 'চেনার চিহ্ন (ঐচ্ছিক)';

  @override
  String get locLandmarkHint => 'যেমন: বাজারের পাশে, স্কুলের সামনে';

  @override
  String get locWhyTitle => 'কেন সঠিক ঠিকানা দরকার';

  @override
  String get locWhyBody =>
      'ট্রাক ঠিক জায়গায় পৌঁছাবে, কাছের ক্রেতা ও লোড মিলবে।';

  @override
  String get locSaveAs => 'এই ঠিকানা সেভ করুন (পরে এক ট্যাপে বাছতে)';

  @override
  String get locTagHome => 'বাড়ি';

  @override
  String get locTagFarm => 'খামার';

  @override
  String get locTagStore => 'গুদাম';

  @override
  String get locTagOther => 'অন্যান্য';

  @override
  String get locConfirm => 'এই ঠিকানা নিশ্চিত করুন';

  @override
  String get locNoResults => 'কিছু পাওয়া যায়নি';

  @override
  String get photoCamera => 'ক্যামেরা দিয়ে তুলুন';

  @override
  String get photoGallery => 'গ্যালারি থেকে নিন';

  @override
  String get homeComingSoon => 'এই অংশটি তৈরি হচ্ছে';

  @override
  String get logout => 'লগআউট';

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get greetingMorning => 'শুভ সকাল,';

  @override
  String get greetingAfternoon => 'শুভ দুপুর,';

  @override
  String get greetingEvening => 'শুভ সন্ধ্যা,';

  @override
  String get navHome => 'হোম';

  @override
  String get navMarket => 'বাজার';

  @override
  String get navSell => 'বিক্রি';

  @override
  String get navOrders => 'অর্ডার';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get navListings => 'তালিকা';

  @override
  String get navReports => 'রিপোর্ট';

  @override
  String get navVerify => 'যাচাই';

  @override
  String get farmerSearchHint => 'ফসল, ক্রেতা বা এলাকা খুঁজুন';

  @override
  String homeNewOffers(String count) {
    return '$countটি নতুন অফার এসেছে';
  }

  @override
  String get homeSee => 'দেখুন';

  @override
  String get homeTodayPrices => 'আজকের বাজার দর';

  @override
  String get homeWhatToDo => 'আপনি কী করতে চান?';

  @override
  String get homeSellCrop => 'ফসল বিক্রি করুন';

  @override
  String get homeSellCropSub => '২ মিনিটে তালিকা দিন';

  @override
  String get homeMyListings => 'আমার তালিকা';

  @override
  String homeMyListingsSub(String count) {
    return '$countটি চলমান তালিকা';
  }

  @override
  String get homeBuyerDemand => 'ক্রেতার চাহিদা';

  @override
  String get homeBuyerDemandSub => 'কাছাকাছি চাহিদা দেখুন';

  @override
  String get homePayments => 'পেমেন্ট';

  @override
  String homePaymentsSub(String amount) {
    return 'এ মাসে $amount';
  }

  @override
  String get homeOngoingOrders => 'চলমান অর্ডার';

  @override
  String get homeBannerExportTitle => 'বিদেশে ফসল বিক্রি করুন';

  @override
  String get homeBannerExportSub => 'রপ্তানি গাইড ও বিদেশি ক্রেতা';

  @override
  String get homeTips => 'কৃষি টিপস';

  @override
  String get tipBetterPrice => 'ভালো দাম পাওয়ার উপায়';

  @override
  String get tipPackaging => 'প্যাকেজিং টিপস';

  @override
  String get tipGrading => 'গ্রেড বোঝার নিয়ম';

  @override
  String tipListen(String time) {
    return 'শুনুন · $time';
  }

  @override
  String pricePerKg(String price) {
    return '$price/কেজি';
  }

  @override
  String get sellTitle => 'ফসল বিক্রি করুন';

  @override
  String get sellStep1 => 'ফসলের তথ্য';

  @override
  String get sellStep2 => 'দাম ও স্থান';

  @override
  String get sellStep3 => 'নিশ্চিত করুন';

  @override
  String get sellChooseCrop => 'ফসল বাছুন';

  @override
  String get sellOtherCropHint => 'ফসলের নাম লিখুন';

  @override
  String get sellGrade => 'মান (গ্রেড)';

  @override
  String gradeLabel(String grade) {
    return 'গ্রেড $grade';
  }

  @override
  String get sellQuantity => 'পরিমাণ';

  @override
  String get sellAddPhoto => 'ফসলের ছবি তুলুন';

  @override
  String get sellPrice => 'দাম (প্রতি কেজি)';

  @override
  String get sellPriceUnit => '৳/কেজি';

  @override
  String sellMarketRange(String min, String max) {
    return 'আজকের বাজার দর: ৳ $min–$max / কেজি';
  }

  @override
  String get sellAvailableFrom => 'কবে থেকে পাওয়া যাবে';

  @override
  String get sellToday => 'আজ';

  @override
  String get sellTomorrow => 'কাল';

  @override
  String get sellPickDate => 'তারিখ বাছুন';

  @override
  String get sellPickup => 'পিকআপ ঠিকানা';

  @override
  String get sellNext => 'পরবর্তী';

  @override
  String get sellEdit => 'সম্পাদনা';

  @override
  String get sellPublish => 'প্রকাশ করুন';

  @override
  String get fieldCrop => 'ফসল';

  @override
  String get fieldQuantity => 'পরিমাণ';

  @override
  String get fieldPrice => 'দাম';

  @override
  String get fieldAvailability => 'প্রাপ্যতা';

  @override
  String get fieldPickup => 'পিকআপ';

  @override
  String get fieldMyPrice => 'আমার দাম';

  @override
  String get fieldMarketPrice => 'বাজার দর';

  @override
  String qtyKg(String qty) {
    return '$qty কেজি';
  }

  @override
  String priceLine(String price) {
    return '৳ $price / কেজি';
  }

  @override
  String rangeLine(String min, String max) {
    return '৳ $min–$max / কেজি';
  }

  @override
  String availableFromDate(String date) {
    return '$date থেকে';
  }

  @override
  String cropWithGrade(String crop, String grade) {
    return '$crop (গ্রেড $grade)';
  }

  @override
  String get errPhotoRequired => 'ফসলের একটি ছবি দিন';

  @override
  String get errQtyInvalid => 'সঠিক পরিমাণ দিন';

  @override
  String get errPriceInvalid => 'সঠিক দাম দিন';

  @override
  String get listingSuccessTitle => 'ফসল তালিকায় যোগ হয়েছে!';

  @override
  String get listingSuccessBody =>
      'মডারেটর অনুমোদনের পর ক্রেতারা আপনার ফসল দেখতে ও অফার দিতে পারবেন।';

  @override
  String get listingSuccessCta => 'আমার তালিকা দেখুন';

  @override
  String get myListingsTitle => 'আমার তালিকা';

  @override
  String get tabOngoing => 'চলমান';

  @override
  String get tabSold => 'বিক্রিত';

  @override
  String get tabDraft => 'খসড়া';

  @override
  String get emptyFilter => 'এই ফিল্টারে এখন কিছু নেই';

  @override
  String get addNewCrop => '+ নতুন ফসল যোগ করুন';

  @override
  String get statusPending => 'অনুমোদনের অপেক্ষায়';

  @override
  String get statusActive => 'চলমান';

  @override
  String get statusSold => 'বিক্রিত';

  @override
  String get statusHidden => 'বাতিল';

  @override
  String listingSubtitle(String qty, String price) {
    return '$qty কেজি · ৳ $price/কেজি';
  }

  @override
  String get cropDetailsTitle => 'ফসলের বিবরণ';

  @override
  String seeBuyerOffers(String count) {
    return 'ক্রেতার অফার দেখুন ($count)';
  }

  @override
  String moderationNote(String note) {
    return 'মডারেটরের মন্তব্য: $note';
  }

  @override
  String get markSold => 'বিক্রি হয়েছে চিহ্নিত করুন';

  @override
  String get modHomeQueue => 'অনুমোদনের অপেক্ষায় থাকা তালিকা';

  @override
  String get modStatPending => 'অপেক্ষমাণ তালিকা';

  @override
  String get modStatActive => 'চলমান তালিকা';

  @override
  String get modStatHidden => 'বাতিল তালিকা';

  @override
  String get modListingsTitle => 'তালিকা যাচাই';

  @override
  String get modReviewTitle => 'তালিকা পর্যালোচনা';

  @override
  String get modFarmer => 'কৃষক';

  @override
  String get modApprove => 'অনুমোদন দিন';

  @override
  String get modReject => 'বাতিল করুন';

  @override
  String get modRejectReasonTitle => 'বাতিলের কারণ';

  @override
  String get modRejectReasonHint => 'যেমন: ছবি অস্পষ্ট, দাম অস্বাভাবিক';

  @override
  String get modApproved => 'তালিকা অনুমোদিত হয়েছে';

  @override
  String get modRejected => 'তালিকা বাতিল হয়েছে';

  @override
  String get modQueueEmpty => 'অপেক্ষমাণ কোনো তালিকা নেই';

  @override
  String submittedOn(String date) {
    return 'জমা: $date';
  }

  @override
  String get cropOther => 'অন্যান্য';

  @override
  String get profileLanguage => 'ভাষা';

  @override
  String get profileRole => 'ভূমিকা';

  @override
  String get profilePhone => 'মোবাইল নম্বর';

  @override
  String get tabComingTitle => 'এই অংশটি পরের ধাপে আসছে';

  @override
  String get navCollect => 'সংগ্রহ';

  @override
  String get navDemand => 'চাহিদা';

  @override
  String get buyerSearchHint => 'ফসল, কৃষক বা এলাকা খুঁজুন';

  @override
  String get statOngoingOrders => 'চলমান অর্ডার';

  @override
  String get statInTransit => 'পথে আছে';

  @override
  String get statSafePay => 'নিরাপদ লেনদেনে';

  @override
  String get statNewOffers => 'নতুন অফার';

  @override
  String countTi(String count) {
    return '$countটি';
  }

  @override
  String get catAll => 'সব';

  @override
  String get catVegetable => 'সবজি';

  @override
  String get catFruit => 'ফল';

  @override
  String get catGrain => 'শস্য';

  @override
  String get catFish => 'মাছ';

  @override
  String get catSpice => 'মসলা';

  @override
  String get catPulse => 'ডাল';

  @override
  String get quickActions => 'দ্রুত কাজ';

  @override
  String get actPostDemand => 'চাহিদা পোস্ট করুন';

  @override
  String get actPostDemandSub => 'কৃষকরা অফার দেবেন';

  @override
  String get actMarket => 'বাজার';

  @override
  String actMarketSub(String count) {
    return '$countটি ফসল';
  }

  @override
  String get actProcurement => 'সংগ্রহ ড্যাশবোর্ড';

  @override
  String get actProcurementSub => 'চাহিদা ও সংগ্রহ';

  @override
  String get actBookTruck => 'ট্রাক বুক করুন';

  @override
  String get actBookTruckSub => 'ভাড়া তুলনা করে বুক';

  @override
  String get bannerPoolTitle => 'নতুন: ডিজিটাল পুলিং';

  @override
  String get bannerPoolSub => 'একাধিক কৃষক থেকে বড় অর্ডার';

  @override
  String get bannerTry => 'চেষ্টা করুন';

  @override
  String get topSuppliers => 'শীর্ষ সরবরাহকারী';

  @override
  String get recommendedCrops => 'আপনার জন্য সুপারিশকৃত ফসল';

  @override
  String onTimePct(String pct) {
    return '$pct% সময়মতো';
  }

  @override
  String get marketTitle => 'বাজার';

  @override
  String get marketSearchHint => 'ফসল, এলাকা বা কৃষক খুঁজুন';

  @override
  String resultsCount(String count) {
    return 'ফলাফল: $countটি';
  }

  @override
  String get filterLabel => 'ফিল্টার: এলাকা, পরিমাণ, দাম';

  @override
  String listingLine(String qty, String place) {
    return '$qty কেজি · $place';
  }

  @override
  String listingLineRated(String qty, String place, String rating) {
    return '$qty কেজি · $place · $rating';
  }

  @override
  String get filterTitle => 'ফিল্টার';

  @override
  String get filterDistrict => 'এলাকা (জেলা)';

  @override
  String get filterAnyDistrict => 'সব জেলা';

  @override
  String get filterMinQty => 'ন্যূনতম পরিমাণ';

  @override
  String get filterMaxPrice => 'সর্বোচ্চ দাম (প্রতি কেজি)';

  @override
  String get filterApply => 'ফিল্টার করুন';

  @override
  String get filterClear => 'মুছুন';

  @override
  String get searchTitle => 'খুঁজুন';

  @override
  String get searchHint => 'আলু, টমেটো, এলাকা…';

  @override
  String get recentSearches => 'সাম্প্রতিক খোঁজ';

  @override
  String get clearRecent => 'মুছুন';

  @override
  String get popularNow => 'জনপ্রিয় এখন';

  @override
  String get suggestions => 'পরামর্শ';

  @override
  String get voiceGuide => 'মাইক চেপে ফসলের নাম বলুন';

  @override
  String suggestListings(String count) {
    return '$countটি তালিকা';
  }

  @override
  String suggestListingsRange(String count, String min, String max) {
    return '$countটি তালিকা · ৳ $min–$max';
  }

  @override
  String get noResults => 'কোনো ফসল পাওয়া যায়নি';

  @override
  String marketRangeFair(String min, String max) {
    return 'বাজার দর ৳ $min–$max / কেজি · ন্যায্য দামের মধ্যে';
  }

  @override
  String marketRangeOnly(String min, String max) {
    return 'বাজার দর ৳ $min–$max / কেজি';
  }

  @override
  String qtyAvailable(String qty) {
    return '$qty কেজি উপলব্ধ';
  }

  @override
  String get fieldAvailable => 'উপলব্ধ';

  @override
  String get fieldLocation => 'অবস্থান';

  @override
  String placeWithKm(String place, String km) {
    return '$place ($km কিমি)';
  }

  @override
  String get sectionFarmer => 'কৃষক';

  @override
  String get sectionDelivery => 'ডেলিভারি ও পরিবহন';

  @override
  String get fieldPayment => 'পেমেন্ট';

  @override
  String get safePayment => 'নিরাপদ লেনদেন';

  @override
  String reviewsCount(String count) {
    return 'রিভিউ ($count)';
  }

  @override
  String get similarCrops => 'একই ধরনের ফসল';

  @override
  String get makeOffer => 'অফার দিন';

  @override
  String get placeOrder => 'অর্ডার করুন';

  @override
  String farmerCardSub(String verified, String rating, String count) {
    return '$verifiedরেটিং $rating · $count লেনদেন';
  }

  @override
  String get verifiedDot => 'যাচাইকৃত · ';

  @override
  String get profileLink => 'প্রোফাইল';

  @override
  String get farmerProfileTitle => 'কৃষকের প্রোফাইল';

  @override
  String get verifiedNid => 'যাচাইকৃত (NID)';

  @override
  String get notVerified => 'যাচাই বাকি';

  @override
  String get statRating => 'রেটিং';

  @override
  String get statOnTime => 'সময়মতো সরবরাহ';

  @override
  String get statCompleted => 'সম্পন্ন লেনদেন';

  @override
  String get statComplaints => 'মান অভিযোগ';

  @override
  String ratingWithCount(String rating, String count) {
    return '$rating ($count)';
  }

  @override
  String get availableCrops => 'উপলব্ধ ফসল';

  @override
  String get sendMessage => 'বার্তা পাঠান';

  @override
  String get notAvailable => '—';

  @override
  String qtyTon(String t) {
    return '$t টন';
  }

  @override
  String get backToHome => 'হোম';
}
