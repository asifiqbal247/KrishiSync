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

  @override
  String get offerTitle => 'অফার দিন';

  @override
  String get offerYourPrice => 'আপনার দাম';

  @override
  String get offerDeliveryDate => 'ডেলিভারি তারিখ';

  @override
  String get offerTotal => 'মোট মূল্য';

  @override
  String get offerSend => 'অফার পাঠান';

  @override
  String get offerSent => 'অফার পাঠানো হয়েছে';

  @override
  String farmerQty(String farmer, String qty) {
    return '$farmer · $qty';
  }

  @override
  String get offersTitle => 'ক্রেতার অফার';

  @override
  String get offerTabAll => 'সব';

  @override
  String get offerTabNew => 'নতুন';

  @override
  String get offerTabTalking => 'আলোচনায়';

  @override
  String marketRangeShort(String min, String max) {
    return 'বাজার দর: ৳ $min–$max / কেজি';
  }

  @override
  String buyerVerifiedRating(String rating) {
    return 'যাচাইকৃত · রেটিং $rating';
  }

  @override
  String buyerRating(String rating) {
    return 'রেটিং $rating';
  }

  @override
  String newBuyerQty(String qty) {
    return 'নতুন ক্রেতা · $qty';
  }

  @override
  String pricePerKgShort(String price) {
    return '৳ $price/কেজি';
  }

  @override
  String get negotiateTitle => 'দর কষাকষি';

  @override
  String get rowBuyer => 'ক্রেতা';

  @override
  String get rowFarmer => 'কৃষক';

  @override
  String verifiedSuffix(String name) {
    return '$name (যাচাইকৃত)';
  }

  @override
  String get rowBuyerOffer => 'ক্রেতার অফার';

  @override
  String get rowFarmerCounter => 'কৃষকের পাল্টা অফার';

  @override
  String get rowMyOffer => 'আমার অফার';

  @override
  String get rowOfferValidity => 'অফারের মেয়াদ';

  @override
  String hoursLeft(String h) {
    return '$h ঘণ্টা বাকি';
  }

  @override
  String get offerExpired => 'মেয়াদ শেষ';

  @override
  String get paymentSafeLoad => 'নিরাপদ লেনদেন · লোড হলেই পাবেন';

  @override
  String get counterLabel => 'পাল্টা অফার দিন';

  @override
  String get reject => 'প্রত্যাখ্যান';

  @override
  String get counter => 'পাল্টা অফার';

  @override
  String get acceptOffer => 'অফার গ্রহণ করুন';

  @override
  String get rejectConfirmTitle => 'প্রত্যাখ্যান করবেন?';

  @override
  String get rejectConfirmBody =>
      'অপর পক্ষকে জানানো হবে। এটি আর গ্রহণ করা যাবে না, তবে তারা নতুন প্রস্তাব দিতে পারবেন।';

  @override
  String get noGoBack => 'না, ফিরে যান';

  @override
  String get yesReject => 'হ্যাঁ, প্রত্যাখ্যান';

  @override
  String get offerAcceptedTitle => 'অফার গ্রহণ হয়েছে!';

  @override
  String get offerAcceptedBody =>
      'ক্রেতা টাকা জমা দিলে অর্ডার নিশ্চিত হবে। তখন আপনি জানতে পারবেন।';

  @override
  String get seeOrder => 'অর্ডার দেখুন';

  @override
  String get counterSent => 'পাল্টা অফার পাঠানো হয়েছে';

  @override
  String get offerRejected => 'অফার প্রত্যাখ্যান করা হয়েছে';

  @override
  String get offerStatusPending => 'নতুন';

  @override
  String get offerStatusCountered => 'আলোচনায়';

  @override
  String get offerStatusAccepted => 'গৃহীত';

  @override
  String get offerStatusRejected => 'প্রত্যাখ্যাত';

  @override
  String get offerStatusWithdrawn => 'প্রত্যাহার';

  @override
  String get orderNowFromOffer => 'এই দামে অর্ডার করুন';

  @override
  String get placeOrderTitle => 'অর্ডার নিশ্চিত করুন';

  @override
  String get deliveryAddress => 'ডেলিভারি ঠিকানা';

  @override
  String cropQtyTitle(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String farmerPrice(String farmer, String price) {
    return '$farmer · ৳ $price/কেজি';
  }

  @override
  String get platformTruck => 'প্ল্যাটফর্মের ট্রাক';

  @override
  String get platformTruckSub => 'স্বয়ংক্রিয় পরিবহন বুকিং';

  @override
  String get selfTransport => 'নিজে পরিবহন করব';

  @override
  String get rowCropPrice => 'ফসলের মূল্য';

  @override
  String get rowTransport => 'পরিবহন';

  @override
  String rowPlatformFee(String pct) {
    return 'প্ল্যাটফর্ম ফি ($pct%)';
  }

  @override
  String get rowTotal => 'মোট';

  @override
  String get payWithSafe => 'নিরাপদ লেনদেনে পেমেন্ট করুন';

  @override
  String get orderPlacedTitle => 'অর্ডার নিশ্চিত হয়েছে!';

  @override
  String get orderPlacedBody =>
      'টাকা নিরাপদ লেনদেনে জমা আছে। মাল গাড়িতে উঠলেই কৃষক টাকা পাবেন।';

  @override
  String get errQtyTooMuch => 'উপলব্ধ পরিমাণের চেয়ে বেশি';

  @override
  String get errAddressRequired => 'ডেলিভারি ঠিকানা দিন';

  @override
  String get ordersTitle => 'আমার অর্ডার';

  @override
  String get ordersTabAll => 'সব';

  @override
  String get ordersTabOngoing => 'চলমান';

  @override
  String get ordersTabDone => 'সম্পন্ন';

  @override
  String get ordersTabCancelled => 'বাতিল';

  @override
  String qtyPrice(String qty, String price) {
    return '$qty · ৳ $price/কেজি';
  }

  @override
  String get orderStatusConfirmed => 'নিশ্চিত';

  @override
  String get orderStatusTransportBooked => 'ট্রাক বুক';

  @override
  String get orderStatusPickedUp => 'লোড হয়েছে';

  @override
  String get orderStatusInTransit => 'পথে আছে';

  @override
  String get orderStatusDelivered => 'পৌঁছেছে';

  @override
  String get orderStatusCompleted => 'সম্পন্ন';

  @override
  String get orderStatusCancelled => 'বাতিল';

  @override
  String get orderDetailsTitle => 'অর্ডারের বিবরণ';

  @override
  String orderNoLine(String no) {
    return 'অর্ডার #$no';
  }

  @override
  String get rowPayment => 'পেমেন্ট';

  @override
  String get paymentHeld => 'নিরাপদ লেনদেনে জমা';

  @override
  String get paymentPending => 'অপেক্ষমাণ';

  @override
  String get rowLoadAndMoney => 'গাড়িতে লোড + আপনার টাকা';

  @override
  String get rowPickupDate => 'পিকআপ';

  @override
  String get orderStatusSection => 'অর্ডারের অবস্থা';

  @override
  String get stepConfirmed => 'অর্ডার নিশ্চিত';

  @override
  String get stepTruckBooked => 'ক্রেতা ট্রাক বুক করেছেন';

  @override
  String get stepTruckBookedSelf => 'ক্রেতা নিজে পরিবহন করবেন';

  @override
  String get stepLoaded => 'গাড়িতে লোড + আপনার টাকা';

  @override
  String get stepLoadedBuyer => 'গাড়িতে লোড + কৃষকের টাকা';

  @override
  String get stepDelivered => 'ডেলিভারি';

  @override
  String get stepWaiting => 'অপেক্ষমাণ';

  @override
  String get orderProblem => 'অর্ডারে সমস্যা?';

  @override
  String get orderProblemSub => 'সমস্যা জানান বা সাহায্য নিন';

  @override
  String get trackShipment => 'চালান ট্র্যাক করুন';

  @override
  String dateTime(String date, String time) {
    return '$date, $time';
  }

  @override
  String get notifTitle => 'নোটিফিকেশন';

  @override
  String get notifEmpty => 'কোনো নোটিফিকেশন নেই';

  @override
  String nOfferNew(String crop) {
    return 'নতুন অফার: $crop';
  }

  @override
  String nOfferNewBody(String buyer, String price, String qty) {
    return '$buyer · ৳ $price/কেজি · $qty';
  }

  @override
  String nOfferCounter(String crop) {
    return 'পাল্টা অফার: $crop';
  }

  @override
  String nOfferCounterBody(String farmer, String price) {
    return '$farmer · ৳ $price/কেজি';
  }

  @override
  String nOfferAccepted(String crop) {
    return 'অফার গৃহীত: $crop';
  }

  @override
  String nOfferAcceptedBody(String price) {
    return '৳ $price/কেজি দামে অর্ডার করুন';
  }

  @override
  String nOfferRejected(String crop) {
    return 'অফার প্রত্যাখ্যাত: $crop';
  }

  @override
  String nOrderNew(String no) {
    return 'নতুন অর্ডার #$no';
  }

  @override
  String nOrderNewBody(String buyer, String crop, String qty) {
    return '$buyer · $crop $qty';
  }

  @override
  String nListingApproved(String crop) {
    return 'তালিকা অনুমোদিত: $crop';
  }

  @override
  String nListingRejected(String crop) {
    return 'তালিকা বাতিল: $crop';
  }

  @override
  String get nListingApprovedBody => 'ক্রেতারা এখন আপনার ফসল দেখতে পারবেন';

  @override
  String homeOffersSub(String crop, String price) {
    return '$crop · সর্বোচ্চ ৳ $price/কেজি';
  }

  @override
  String get stateErrorTitle => 'কিছু সমস্যা হয়েছে';

  @override
  String get stateErrorBody =>
      'আপনার দেওয়া তথ্য সঠিক নয়। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get stateGetHelp => 'সাহায্য নিন';

  @override
  String get stateOfflineBody =>
      'আপনার তথ্য সংরক্ষিত আছে। সংযোগ ফিরলে স্বয়ংক্রিয়ভাবে পাঠানো হবে।';

  @override
  String get emptyOrdersTitle => 'এখনো কোনো অর্ডার নেই';

  @override
  String get emptyOrdersFarmerBody =>
      'ফসল তালিকাভুক্ত করুন, ক্রেতারা অফার পাঠাবে।';

  @override
  String get emptyOrdersBuyerBody => 'বাজার থেকে পছন্দের ফসল অর্ডার করুন।';

  @override
  String get emptyOrdersBuyerCta => 'বাজার দেখুন';

  @override
  String get rowMyCounter => 'আমার পাল্টা অফার';

  @override
  String get rowOfferStatus => 'অবস্থা';

  @override
  String get navTrip => 'ট্রিপ';

  @override
  String get navLoad => 'লোড';

  @override
  String get navEarnings => 'আয়';

  @override
  String get trStatToday => 'আজকের আয়';

  @override
  String get trStatOngoing => 'চলমান ট্রিপ';

  @override
  String trOngoingTitle(String no) {
    return 'চলমান: $no';
  }

  @override
  String trOngoingSub(String n, String status) {
    return '$nটি পিকআপ · $status';
  }

  @override
  String get trContinue => 'চালিয়ে যান';

  @override
  String get trWhatToDo => 'কী করতে চান?';

  @override
  String get trFindLoads => 'লোড খুঁজুন';

  @override
  String trFindLoadsSub(String n) {
    return 'কাছাকাছি $nটি লোড';
  }

  @override
  String get trMyJobs => 'আমার কাজ';

  @override
  String trMyJobsSub(String n) {
    return '$nটি কাজ';
  }

  @override
  String get trReturnLoads => 'ফিরতি লোড';

  @override
  String get trReturnLoadsSub => 'খালি ফিরবেন না';

  @override
  String get trEarnings => 'আয়';

  @override
  String trEarningsSub(String amount) {
    return 'এ সপ্তাহে $amount';
  }

  @override
  String get trNearbyLoads => 'আপনার কাছাকাছি লোড';

  @override
  String get seeAllLink => 'সব দেখুন';

  @override
  String get trReturnChances => 'ফিরতি লোডের সুযোগ';

  @override
  String get trWeekEarnings => 'এ সপ্তাহের আয়';

  @override
  String get trThisWeek => 'এ সপ্তাহে';

  @override
  String get trPendingPay => 'অপেক্ষমাণ';

  @override
  String get wdSat => 'শনি';

  @override
  String get wdSun => 'রবি';

  @override
  String get wdMon => 'সোম';

  @override
  String get wdTue => 'মঙ্গল';

  @override
  String get wdWed => 'বুধ';

  @override
  String get wdThu => 'বৃহঃ';

  @override
  String get wdFri => 'শুক্র';

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
  String get noLoads => 'এখন কোনো লোড নেই';

  @override
  String takaAmount(String amount) {
    return '৳ $amount';
  }

  @override
  String get vehicleNeeded => 'লোড নিতে আগে গাড়ির তথ্য দিন';

  @override
  String get loadsTitle => 'উপলব্ধ লোড';

  @override
  String get filterAll => 'সব';

  @override
  String get filterNearby => 'কাছাকাছি';

  @override
  String get filterFullLoad => 'ফুল লোড';

  @override
  String get filterMultiPickup => 'একাধিক পিকআপ';

  @override
  String get loadDetailsTitle => 'লোডের বিবরণ';

  @override
  String get rowGoods => 'মালামাল';

  @override
  String get rowDestination => 'গন্তব্য';

  @override
  String get rowDistance => 'দূরত্ব';

  @override
  String distanceLine(String km, String h) {
    return '$km কিমি · ~$h ঘণ্টা';
  }

  @override
  String get rowFare => 'ভাড়া';

  @override
  String fareSafeLine(String amount) {
    return '$amount (নিরাপদ লেনদেন)';
  }

  @override
  String get rowCustomer => 'গ্রাহক';

  @override
  String nameVerified(String name) {
    return '$name · যাচাইকৃত';
  }

  @override
  String placeDate(String place, String date) {
    return '$place · $date';
  }

  @override
  String fitsTruck(String cap) {
    return 'আপনার ট্রাকে মানানসই: $cap ধারণক্ষমতা';
  }

  @override
  String tooBigTruck(String cap) {
    return 'আপনার ট্রাকের ধারণক্ষমতা $cap — এই লোড বেশি';
  }

  @override
  String tonQty(String t) {
    return '$t টন';
  }

  @override
  String get sendFareOffer => 'ভাড়ার প্রস্তাব দিন';

  @override
  String get acceptJob => 'কাজটি গ্রহণ করুন';

  @override
  String myBidLine(String amount) {
    return 'আপনার প্রস্তাব: $amount · ক্রেতার উত্তরের অপেক্ষায়';
  }

  @override
  String get bidSent => 'প্রস্তাব পাঠানো হয়েছে';

  @override
  String get loadTaken => 'এই লোড অন্য চালক পেয়েছেন';

  @override
  String get fareOfferTitle => 'ভাড়ার প্রস্তাব দিন';

  @override
  String get suggestedFareRow => 'প্রস্তাবিত ভাড়া (প্ল্যাটফর্ম)';

  @override
  String takaRange(String min, String max) {
    return '৳ $min–$max';
  }

  @override
  String get otherBidsRow => 'অন্য প্রস্তাব';

  @override
  String otherBidsLine(String n, String amount) {
    return '$nটি · সর্বনিম্ন $amount';
  }

  @override
  String get noneYet => 'এখনো নেই';

  @override
  String get yourFare => 'আপনার ভাড়া';

  @override
  String get fareNote =>
      'ক্রেতা প্রস্তাব বেছে নিরাপদ লেনদেনে টাকা জমা দিলে কাজ নিশ্চিত হবে। এরপর ভাড়া বদলানো যাবে না।';

  @override
  String get sendProposal => 'প্রস্তাব পাঠান';

  @override
  String get errFareInvalid => 'সঠিক ভাড়া লিখুন';

  @override
  String get myJobsTitle => 'আমার কাজ';

  @override
  String get jobsToday => 'আজ';

  @override
  String get jobsUpcoming => 'আসন্ন';

  @override
  String get jobsDone => 'সম্পন্ন';

  @override
  String jobTitle(String no, String crop, String qty) {
    return '$no · $crop $qty';
  }

  @override
  String get badgeRunning => 'চলছে';

  @override
  String get badgeScheduled => 'নির্ধারিত';

  @override
  String get badgeDone => 'সম্পন্ন';

  @override
  String get noJobs => 'কোনো কাজ নেই';

  @override
  String get scheduleTitle => 'পিকআপ সূচি';

  @override
  String get rowJob => 'কাজ';

  @override
  String get rowTotalStops => 'মোট স্টপ';

  @override
  String get stopsOne => '১টি পিকআপ + ১টি ডেলিভারি';

  @override
  String get pickupOrder => 'পিকআপের ক্রম';

  @override
  String stopN(String n, String name) {
    return '$n. $name';
  }

  @override
  String stopSub(String place, String qty, String date) {
    return '$place · $qty · $date';
  }

  @override
  String get stopDelivery => 'ডেলিভারি';

  @override
  String get seeRoute => 'রুট দেখুন';

  @override
  String get tripStatusTitle => 'ট্রিপের অবস্থা';

  @override
  String freeSpaceTitle(String t) {
    return 'আপনার ট্রাকে $t টন খালি';
  }

  @override
  String get freeSpaceSub => 'রুটে লোড আছে · আলাদা ভাড়া';

  @override
  String get seeLink => 'দেখুন';

  @override
  String stepPickupN(String n, String name) {
    return 'পিকআপ $n – $name';
  }

  @override
  String get stepLoadedDone => 'লোড হয়েছে';

  @override
  String stepDeliveryTo(String name) {
    return 'ডেলিভারি – $name';
  }

  @override
  String get offlineSafeNote => 'দুর্বল নেটওয়ার্কেও আপডেট সংরক্ষিত থাকে।';

  @override
  String get tripProblem => 'ট্রিপে সমস্যা?';

  @override
  String get startLoading => 'পিকআপে লোড শুরু করুন';

  @override
  String get loadConfirmTitle => 'মাল গাড়িতে উঠেছে?';

  @override
  String get loadConfirmBody =>
      'নিশ্চিত করলে কৃষক টাকা পাবেন এবং ক্রেতাকে জানানো হবে।';

  @override
  String get yesLoaded => 'লোড হয়েছে';

  @override
  String get deliverNow => 'ডেলিভারি দিন';

  @override
  String get tripDoneBtn => 'ট্রিপ সম্পন্ন';

  @override
  String get podTitle => 'ডেলিভারির প্রমাণ';

  @override
  String get podPhoto => 'ডেলিভারির ছবি তুলুন';

  @override
  String get deliveredQty => 'ডেলিভারি করা পরিমাণ';

  @override
  String get buyerOtp => 'গ্রাহকের OTP';

  @override
  String get otpHint4 => '৪ সংখ্যার কোড';

  @override
  String get podNote =>
      'ক্রেতা OTP দিলে বা GPS ও ছবিতে ডেলিভারি প্রমাণ হলে সাথে সাথে ভাড়া ছাড়। পরে আটকানো যাবে না।';

  @override
  String get podSubmit => 'ডেলিভারি সম্পন্ন';

  @override
  String get errOtpWrong => 'OTP সঠিক নয়';

  @override
  String get errOtp4 => '৪ সংখ্যার কোড দিন';

  @override
  String get tripDoneTitle => 'ট্রিপ সম্পন্ন';

  @override
  String get tripDoneHeading => 'ডেলিভারি সম্পন্ন!';

  @override
  String tripDoneBody(String amount) {
    return '$amount আপনার বিকাশে পাঠানো হয়েছে। এই ভাড়া চূড়ান্ত।';
  }

  @override
  String get seeReceipt => 'রসিদ দেখুন';

  @override
  String receiptSub(String amount) {
    return '$amount · বিকাশে পাঠানো';
  }

  @override
  String get rateCustomer => 'গ্রাহককে রেটিং দিন';

  @override
  String nameOrderNo(String name, String no) {
    return '$name · $no';
  }

  @override
  String get dontGoEmpty => 'খালি ফিরবেন না';

  @override
  String get acceptReturnLoad => 'ফিরতি লোড গ্রহণ করুন';

  @override
  String get seeEarnings => 'আয় দেখুন';

  @override
  String get alreadyRated => 'রেটিং দেওয়া হয়েছে';

  @override
  String get rateTitle => 'রেটিং দিন';

  @override
  String roleCustomer(String name) {
    return '$name (গ্রাহক)';
  }

  @override
  String get justFinishedTrip => 'সদ্য শেষ হওয়া ট্রিপ';

  @override
  String get howWasCustomer => 'গ্রাহক কেমন ছিলেন?';

  @override
  String get tagOnTimeLoad => 'সময়মতো লোড';

  @override
  String get tagCorrectInfo => 'সঠিক তথ্য';

  @override
  String get tagFastPay => 'দ্রুত পেমেন্ট';

  @override
  String roleFarmerName(String name) {
    return '$name (কৃষক)';
  }

  @override
  String get howWasSupplier => 'সরবরাহকারী কেমন ছিল?';

  @override
  String get tagGoodQuality => 'ভালো মান';

  @override
  String get tagRightWeight => 'সঠিক ওজন';

  @override
  String get tagOnTime => 'সময়মতো';

  @override
  String roleDriver(String name) {
    return '$name (চালক)';
  }

  @override
  String get rateTransport => 'পরিবহন রেটিং দিন';

  @override
  String get commentOptional => 'মন্তব্য (ঐচ্ছিক)';

  @override
  String get commentHint => 'অভিজ্ঞতা লিখুন';

  @override
  String get submit => 'জমা দিন';

  @override
  String get errPickStars => 'স্টার দিয়ে রেটিং দিন';

  @override
  String get ratingThanks => 'রেটিং দেওয়ার জন্য ধন্যবাদ';

  @override
  String get vehicleTitle => 'গাড়ি ও ধারণক্ষমতা';

  @override
  String get truckPhoto => 'ট্রাকের ছবি';

  @override
  String get vehicleType => 'গাড়ির ধরন';

  @override
  String get regNo => 'রেজিস্ট্রেশন নম্বর';

  @override
  String get regHint => 'ঢাকা মেট্রো-ট ১২-৩৪৫৬';

  @override
  String get baseLocation => 'বেস লোকেশন (ট্রাক কোথায় থাকে)';

  @override
  String get maxCapacity => 'সর্বোচ্চ ধারণক্ষমতা';

  @override
  String get tonUnit => 'টন';

  @override
  String get preferredRoute => 'পছন্দের রুট';

  @override
  String get vt_pickup => 'পিকআপ ভ্যান';

  @override
  String get vt_small_open => 'ছোট ট্রাক (খোলা)';

  @override
  String get vt_medium_open => 'মাঝারি ট্রাক (খোলা)';

  @override
  String get vt_medium_covered => 'মাঝারি ট্রাক (ঢাকা)';

  @override
  String get vt_large_open => 'বড় ট্রাক (খোলা)';

  @override
  String get vt_covered_van => 'কাভার্ড ভ্যান';

  @override
  String get vt_refrigerated => 'রেফ্রিজারেটেড ভ্যান';

  @override
  String get successTitle => 'সফল হয়েছে!';

  @override
  String get successBody => 'আপনার কাজটি সফলভাবে সম্পন্ন হয়েছে।';

  @override
  String get okBtn => 'ঠিক আছে';

  @override
  String get transportTitle => 'পরিবহন';

  @override
  String get tabBooked => 'বুক করা';

  @override
  String get tabDone => 'সম্পন্ন';

  @override
  String noOrderCrop(String no, String crop) {
    return '$no · $crop';
  }

  @override
  String get dsOpen => 'ট্রাক খোঁজা হচ্ছে';

  @override
  String get dsAssigned => 'নির্ধারিত';

  @override
  String get dsPickedUp => 'পথে';

  @override
  String get dsDelivered => 'পৌঁছেছে';

  @override
  String nameStatus(String name, String status) {
    return '$name · $status';
  }

  @override
  String bidsCountLine(String n) {
    return '$nটি প্রস্তাব';
  }

  @override
  String get bookTruckBtn => '+ ট্রাক বুক করুন';

  @override
  String get noTruckNeeded => 'সব অর্ডারে ট্রাক বুক করা আছে';

  @override
  String get noTransport => 'কোনো পরিবহন নেই';

  @override
  String get bookTruckTitle => 'ট্রাক বুক করুন';

  @override
  String get pickupLocation => 'পিকআপ লোকেশন';

  @override
  String get goodsWeight => 'মালামাল ও ওজন';

  @override
  String get dateLabel => 'তারিখ';

  @override
  String get suggestedTrucks => 'প্রস্তাবিত ট্রাক';

  @override
  String truckSub(String type, String cap, String rating) {
    return '$type · $cap · $rating';
  }

  @override
  String get waitingBids => 'ট্রাকচালকদের প্রস্তাবের অপেক্ষায়…';

  @override
  String get bookBtn => 'বুক করুন';

  @override
  String bookConfirmTitle(String name) {
    return '$name-কে বুক করবেন?';
  }

  @override
  String bookConfirmBody(String amount) {
    return 'ভাড়া $amount নিরাপদ লেনদেনে জমা থাকবে।';
  }

  @override
  String get truckBooked => 'ট্রাক বুক হয়েছে';

  @override
  String get assignedTitle => 'নির্ধারিত পরিবহন';

  @override
  String verifiedDriverRating(String r) {
    return 'যাচাইকৃত চালক · রেটিং $r';
  }

  @override
  String driverRating(String r) {
    return 'চালক · রেটিং $r';
  }

  @override
  String get rowTruck => 'ট্রাক';

  @override
  String get rowCapacity => 'ধারণক্ষমতা';

  @override
  String get callBtn => 'কল করুন';

  @override
  String get trackBtn => 'ট্র্যাক করুন';

  @override
  String get receiveTitle => 'ডেলিভারি গ্রহণ';

  @override
  String get rowOrder => 'অর্ডার';

  @override
  String get rowOrdered => 'অর্ডারকৃত';

  @override
  String get rowLoaded => 'লোডে মাপা';

  @override
  String yourOtp(String code) {
    return 'আপনার OTP: $code';
  }

  @override
  String get otpNote =>
      'ট্রাক পৌঁছালে ড্রাইভারকে এই OTP দিন। দিলেই ভাড়া ছাড় হবে।';

  @override
  String get qualityFinalTitle => 'মান ও পরিমাণ লোডের সময়ই চূড়ান্ত';

  @override
  String get qualityFinalBody =>
      'লোডের পর মান বা পরিমাণ নিয়ে টাকা ফেরত চাওয়া যাবে না। ডেলিভারি নিশ্চিত করলে ভাড়া ছাড় হবে।';

  @override
  String get deliveryPhotoOpt => 'ডেলিভারির ছবি (ঐচ্ছিক)';

  @override
  String get otherProblem => 'অন্য সমস্যা জানান';

  @override
  String get otpGiven => 'OTP দিয়েছি';

  @override
  String get otpWaitDriver => 'ড্রাইভার OTP দিলে এগোতে পারবেন';

  @override
  String get orderBookTruck => 'ট্রাক বুক করুন';

  @override
  String get orderReceive => 'ডেলিভারি গ্রহণ';

  @override
  String get orderRate => 'রেটিং দিন';

  @override
  String get handedOver => 'পণ্য হস্তান্তর করেছি';

  @override
  String get handedOverTitle => 'পণ্য হস্তান্তর করেছেন?';

  @override
  String get handedOverBody => 'ক্রেতার গাড়িতে মাল তোলা হলে নিশ্চিত করুন।';

  @override
  String get receivedSelf => 'পণ্য পেয়েছি';

  @override
  String get receivedTitle => 'পণ্য পেয়েছেন?';

  @override
  String get receivedBody => 'নিশ্চিত করলে কৃষককে জানানো হবে।';

  @override
  String get yesConfirm => 'হ্যাঁ, নিশ্চিত';

  @override
  String nBidNew(String no) {
    return 'নতুন ভাড়ার প্রস্তাব: $no';
  }

  @override
  String nBidNewBody(String name, String amount) {
    return '$name · $amount';
  }

  @override
  String nJobAssigned(String no) {
    return 'আপনি কাজ পেয়েছেন: $no';
  }

  @override
  String nTripPicked(String no) {
    return 'মাল গাড়িতে উঠেছে: $no';
  }

  @override
  String nTripDelivered(String no) {
    return 'ডেলিভারি সম্পন্ন: $no';
  }

  @override
  String get reportTitle => 'সমস্যা জানান';

  @override
  String get reportGeneralTitle => 'অর্ডার বা ট্রিপ';

  @override
  String get reportGeneralSub => 'যে কাজ নিয়ে সমস্যা হয়েছে';

  @override
  String get reportWhat => 'কী সমস্যা হয়েছে?';

  @override
  String get reason_driver_behavior => 'চালকের আচরণ';

  @override
  String get reason_late_delivery => 'দেরিতে ডেলিভারি';

  @override
  String get reason_app_problem => 'অ্যাপে সমস্যা';

  @override
  String get reason_other => 'অন্যান্য';

  @override
  String get reportPhoto => 'ছবি দিন (ঐচ্ছিক)';

  @override
  String get reportDetails => 'বিস্তারিত (ঐচ্ছিক)';

  @override
  String get reportDetailsHint => 'লিখুন বা ভয়েস রেকর্ড করুন';

  @override
  String get reportNote =>
      'কী হয়েছে লিখুন বা ভয়েসে বলুন। আমরা ২৪ ঘণ্টার মধ্যে উত্তর দেব। অভিযোগ করলে পেমেন্টের নিয়ম বদলায় না।';

  @override
  String get reportSubmit => 'অভিযোগ জমা দিন';

  @override
  String get reportSent => 'অভিযোগ জমা হয়েছে';

  @override
  String get errPickReason => 'সমস্যার ধরন বেছে নিন';

  @override
  String get safePayTitle => 'নিরাপদ লেনদেন';

  @override
  String get safePayExplain =>
      'মাল গাড়িতে উঠলে কৃষক, আর আপনার কাছে পৌঁছালে ট্রান্সপোর্টার নিরাপদ লেনদেন থেকে টাকা পাবেন। ১% ফি শুধু ক্রেতা দেবেন, লোড হলে কাটা হবে। ট্রাক রওনার আগে অর্ডার বাতিল করলে ভাড়ার ১০% কাটা যাবে, বাকি সব গোলাঘর থেকে ফেরত পাবেন। এরপর লোড বাতিল হলে ফসলের দাম ও ফি ফেরত পাবেন, ভাড়া নয়।';

  @override
  String get payBank => 'ব্যাংক ট্রান্সফার';

  @override
  String get payBkash => 'বিকাশ / নগদ';

  @override
  String get payDemoSub => 'ডেমো — আসল টাকা কাটা হবে না';

  @override
  String get payAddMethod => 'অন্য মাধ্যম যোগ করুন';

  @override
  String get payAddMethodSub => 'বিকাশ, নগদ, রকেট বা ব্যাংক';

  @override
  String payNow(String amount) {
    return '$amount পরিশোধ করুন';
  }

  @override
  String orderLine(String no, String crop) {
    return '$no · $crop';
  }

  @override
  String get newOrderLabel => 'নতুন অর্ডার';

  @override
  String get modStatReports => 'খোলা অভিযোগ';

  @override
  String get modStatVerify => 'যাচাই বাকি';

  @override
  String get modReportsTitle => 'অভিযোগ';

  @override
  String get rs_open => 'নতুন';

  @override
  String get rs_inReview => 'পর্যালোচনায়';

  @override
  String get rs_resolved => 'সমাধান';

  @override
  String get rs_dismissed => 'খারিজ';

  @override
  String get noReports => 'কোনো অভিযোগ নেই';

  @override
  String get reportDetailTitle => 'অভিযোগের বিবরণ';

  @override
  String get rowReason => 'সমস্যা';

  @override
  String get rowReporter => 'অভিযোগকারী';

  @override
  String get rowDate => 'তারিখ';

  @override
  String get rowDetails => 'বিস্তারিত';

  @override
  String get rowModNote => 'মডারেটরের বার্তা';

  @override
  String nameRole(String name, String role) {
    return '$name ($role)';
  }

  @override
  String get startReview => 'পর্যালোচনা শুরু করুন';

  @override
  String get resolveReport => 'সমাধান হয়েছে';

  @override
  String get dismissReport => 'খারিজ করুন';

  @override
  String get escalateReport => 'অ্যাডমিনকে জানান';

  @override
  String get escalatedBadge => 'অ্যাডমিনকে জানানো হয়েছে';

  @override
  String get noteSheetTitle => 'অভিযোগকারীকে বার্তা (ঐচ্ছিক)';

  @override
  String get noteHint => 'কী ব্যবস্থা নেওয়া হলো লিখুন';

  @override
  String get sendBtn => 'পাঠান';

  @override
  String get doneToast => 'সম্পন্ন হয়েছে';

  @override
  String get verifyTitle => 'পরিচয় যাচাই';

  @override
  String get verifyEmpty => 'যাচাইয়ের অপেক্ষায় কেউ নেই';

  @override
  String get rowNid => 'NID নম্বর';

  @override
  String get rowJoined => 'যোগদান';

  @override
  String get verifyApprove => 'যাচাই করুন';

  @override
  String get verifyRejectBtn => 'প্রত্যাখ্যান';

  @override
  String get verifyRejectTitle => 'যাচাই প্রত্যাখ্যান করবেন?';

  @override
  String get verifyRejectBody => 'ব্যবহারকারীকে আবার সঠিক NID দিতে বলা হবে।';

  @override
  String nameRolePhone(String role, String phone) {
    return '$role · $phone';
  }

  @override
  String get nVerifyOk => 'আপনার পরিচয় যাচাই হয়েছে';

  @override
  String get nVerifyOkBody => 'এখন আপনার প্রোফাইলে যাচাইকৃত চিহ্ন দেখাবে।';

  @override
  String get nVerifyRejected => 'পরিচয় যাচাই হয়নি';

  @override
  String get nVerifyRejectedBody => 'সঠিক NID নম্বর দিয়ে আবার চেষ্টা করুন।';

  @override
  String get nReportResolved => 'আপনার অভিযোগের সমাধান হয়েছে';

  @override
  String get nReportDismissed => 'আপনার অভিযোগ খারিজ হয়েছে';

  @override
  String get navUsers => 'ব্যবহারকারী';

  @override
  String get navModeration => 'মডারেশন';

  @override
  String get navPrices => 'দাম';

  @override
  String get adminUsersSection => 'ব্যবহারকারী';

  @override
  String get statTotalUsers => 'মোট ব্যবহারকারী';

  @override
  String get adminListingsSection => 'তালিকা';

  @override
  String get adminOrdersSection => 'অর্ডার ও অভিযোগ';

  @override
  String get statCompletedOrders => 'সম্পন্ন অর্ডার';

  @override
  String get usersTitle => 'ব্যবহারকারী';

  @override
  String get userSearchHint => 'নাম বা মোবাইল নম্বর খুঁজুন';

  @override
  String get noUsers => 'কেউ পাওয়া যায়নি';

  @override
  String get noRoleYet => 'ভূমিকা নেই';

  @override
  String get suspendedBadge => 'স্থগিত';

  @override
  String get userDetailTitle => 'ব্যবহারকারীর বিবরণ';

  @override
  String get statusActiveUser => 'সক্রিয়';

  @override
  String get rowVerification => 'যাচাই';

  @override
  String get vNone => 'করা হয়নি';

  @override
  String get vPending => 'অপেক্ষায়';

  @override
  String get vVerified => 'যাচাইকৃত';

  @override
  String get vRejected => 'প্রত্যাখ্যাত';

  @override
  String get rowRating => 'রেটিং';

  @override
  String ratingLine(String avg, String n) {
    return '$avg ($nটি রেটিং)';
  }

  @override
  String get suspendUser => 'স্থগিত করুন';

  @override
  String get activateUser => 'সক্রিয় করুন';

  @override
  String get suspendTitle => 'ব্যবহারকারী স্থগিত করবেন?';

  @override
  String get suspendBody =>
      'স্থগিত থাকলে তিনি নতুন তালিকা, অফার বা অর্ডার করতে পারবেন না।';

  @override
  String get changeRole => 'ভূমিকা পরিবর্তন';

  @override
  String get roleChanged => 'ভূমিকা পরিবর্তন হয়েছে';

  @override
  String get cantEditSelf => 'নিজের অ্যাকাউন্ট এখানে বদলানো যাবে না';

  @override
  String get moderationTitle => 'মডারেশন';

  @override
  String get pricesTitle => 'বাজার দর';

  @override
  String priceSub(String price, String min, String max) {
    return 'আজ ৳ $price/কেজি · ৳ $min–$max';
  }

  @override
  String get noPrice => 'দাম দেওয়া হয়নি';

  @override
  String get fieldTodayPrice => 'আজকের দাম';

  @override
  String get fieldMinPrice => 'সর্বনিম্ন দাম';

  @override
  String get fieldMaxPrice => 'সর্বোচ্চ দাম';

  @override
  String get priceSaved => 'দাম সংরক্ষণ হয়েছে';

  @override
  String get errPriceRange => 'সর্বনিম্ন ≤ আজকের দাম ≤ সর্বোচ্চ হতে হবে';

  @override
  String get cropsTitle => 'ফসলের তালিকা';

  @override
  String get addCrop => '+ নতুন ফসল';

  @override
  String get cropNameBn => 'নাম (বাংলা)';

  @override
  String get cropNameEn => 'নাম (English)';

  @override
  String get cropCategory => 'ধরন';

  @override
  String get catOther => 'অন্যান্য';

  @override
  String get cropOn => 'চালু';

  @override
  String get cropOff => 'বন্ধ';

  @override
  String get customCrop => 'নতুন যোগ করা';

  @override
  String get cropSaved => 'সংরক্ষণ হয়েছে';

  @override
  String get cropsSub => 'বিক্রির তালিকায় কোন ফসল দেখাবে';

  @override
  String get pricesSub => 'প্রতিদিনের বাজার দর দিন';

  @override
  String get verifiedBadge => 'যাচাইকৃত';

  @override
  String roleDistrict(String role, String district) {
    return '$role · $district';
  }

  @override
  String ratingShort(String avg, String n) {
    return '$avg ($n)';
  }

  @override
  String get statDoneDeals => 'সম্পন্ন লেনদেন';

  @override
  String get statTotalOrders => 'মোট অর্ডার';

  @override
  String get statDoneTrips => 'সম্পন্ন ট্রিপ';

  @override
  String get shareTrack => 'আমার ট্র্যাক রেকর্ড শেয়ার করুন';

  @override
  String get shareTrackSub => 'যাচাইকৃত সারাংশ · QR ও লিংক';

  @override
  String get shareLink => 'শেয়ার';

  @override
  String get rowNidVerify => 'যাচাইকরণ (NID)';

  @override
  String get rowBizVerify => 'ব্যবসা যাচাইকরণ';

  @override
  String get rowVerifyRating => 'যাচাইকরণ ও রেটিং';

  @override
  String get verifyDone => 'যাচাই সম্পন্ন';

  @override
  String get verifyPendingSub => 'যাচাইয়ের অপেক্ষায়';

  @override
  String get verifyNoneSub => 'যাচাই করা হয়নি';

  @override
  String get verifyRejectedSub => 'যাচাই হয়নি — আবার চেষ্টা করুন';

  @override
  String get rowMyRatings => 'আমার রেটিং ও রিভিউ';

  @override
  String get rowRatings => 'রেটিং ও রিভিউ';

  @override
  String profileReviews(String n) {
    return '$nটি রিভিউ';
  }

  @override
  String get rowMyContracts => 'আমার চুক্তি';

  @override
  String get rowContracts => 'চুক্তি';

  @override
  String get rowPayMethod => 'পেমেন্ট মাধ্যম';

  @override
  String get rowPayAccount => 'পেমেন্ট অ্যাকাউন্ট';

  @override
  String get rowLanguage => 'ভাষা / Language';

  @override
  String languageSub(String lang) {
    return '$lang · চাপলে ভাষা পরিবর্তনের অপশন খুলবে';
  }

  @override
  String get rowHelp => 'সাহায্য';

  @override
  String get helpSub => 'ভয়েস গাইড, হেল্পলাইন';

  @override
  String get logoutTitle => 'লগআউট করবেন?';

  @override
  String get logoutBody =>
      'আবার ঢুকতে মোবাইল নম্বর ও OTP লাগবে। আপনার লেনদেনের ইতিহাস সংরক্ষিত থাকবে।';

  @override
  String get langSheetTitle => 'ভাষা পরিবর্তন / Change language';

  @override
  String get langBnSub => 'Bangla';

  @override
  String get langEnSub => 'ইংরেজি';

  @override
  String get langSheetNote => 'পরে প্রোফাইল থেকে আবার ভাষা বদলাতে পারবেন।';

  @override
  String get loginTermsPre => 'চালিয়ে গেলে আপনি ';

  @override
  String get loginTermsLink => 'শর্তাবলী ও গোপনীয়তা নীতিতে';

  @override
  String get loginTermsPost => ' সম্মত হচ্ছেন।';

  @override
  String get termsTitle => 'শর্তাবলী ও গোপনীয়তা নীতি';

  @override
  String get termsUpdated => 'সর্বশেষ হালনাগাদ: নভেম্বর ২০২৬';

  @override
  String get termsS1Title => '১. গোলাঘর কী';

  @override
  String get termsS1Body =>
      'গোলাঘর কৃষক, ক্রেতা ও পরিবহনকারীকে সরাসরি যুক্ত করে, যাতে মধ্যস্বত্বভোগী ছাড়াই ন্যায্য দামে ফসল কেনা-বেচা হয়। মোবাইল নম্বর ও OTP দিয়ে অ্যাকাউন্ট খুলতে হয়; একটি নম্বরে একটি অ্যাকাউন্ট।';

  @override
  String get termsS2Title => '২. তালিকা ও মডারেশন';

  @override
  String get termsS2Body =>
      'কৃষক সঠিক ফসল, মান, পরিমাণ, দাম ও ছবি দেবেন। মডারেটর অনুমোদনের পরই তালিকা ক্রেতারা দেখতে পান। ভুল বা প্রতারণামূলক তালিকা লুকানো হতে পারে এবং বারবার হলে অ্যাকাউন্ট স্থগিত হতে পারে।';

  @override
  String get termsS3Title => '৩. নিরাপদ লেনদেন ও ফি';

  @override
  String get termsS3Body =>
      'ক্রেতার টাকা নিরাপদ লেনদেনে জমা থাকে। মাল গাড়িতে উঠলে কৃষক এবং ডেলিভারি OTP দিলে পরিবহনকারী টাকা পান। ১% প্ল্যাটফর্ম ফি শুধু ক্রেতা দেন। মান ও পরিমাণ লোডের সময়ই চূড়ান্ত হয়।';

  @override
  String get termsS4Title => '৪. বাতিল ও ফেরত';

  @override
  String get termsS4Body =>
      'ট্রাক রওনার আগে অর্ডার বাতিল করলে ভাড়ার ১০% কাটা যাবে, বাকি টাকা ফেরত পাবেন। এরপর লোড বাতিল হলে ফসলের দাম ও ফি ফেরত পাবেন, ভাড়া নয়। সমস্যা হলে অ্যাপ থেকে অভিযোগ করুন; আমরা ২৪ ঘণ্টার মধ্যে উত্তর দিই।';

  @override
  String get termsS5Title => '৫. পরিবহন ও ডেলিভারি';

  @override
  String get termsS5Body =>
      'পরিবহনকারী সঠিক গাড়ির তথ্য দেবেন এবং ক্রেতার OTP ছাড়া ডেলিভারি সম্পন্ন দেখাবেন না। ক্রেতা ট্রাক পৌঁছালে তবেই OTP দেবেন।';

  @override
  String get termsS6Title => '৬. আপনার তথ্য';

  @override
  String get termsS6Body =>
      'আমরা নাম, মোবাইল নম্বর, ঠিকানা, ছবি, NID নম্বর (ঐচ্ছিক) ও লেনদেনের তথ্য রাখি শুধু অ্যাপ চালাতে, যাচাই করতে ও বিরোধ মেটাতে। ব্যবসার অংশীদার শুধু প্রয়োজনীয় তথ্য (নাম, এলাকা, রেটিং) দেখেন। আমরা আপনার তথ্য বিক্রি করি না।';

  @override
  String get termsS7Title => '৭. আচরণ ও রেটিং';

  @override
  String get termsS7Body =>
      'সব ব্যবহারকারী সৎ ও সম্মানজনক আচরণ করবেন। প্রতিটি লেনদেনের পর রেটিং দেওয়া যায়; ভুয়া রেটিং বা হয়রানি করলে অ্যাকাউন্ট স্থগিত হতে পারে।';

  @override
  String get mpTitle => 'বাজার দর';

  @override
  String get mpSearchHint => 'ফসল খুঁজুন';

  @override
  String get mpWholesale => 'পাইকারি বাজার দর';

  @override
  String mpUpdated(String when) {
    return 'আপডেট: $when';
  }

  @override
  String pctChange(String sign, String pct) {
    return '$sign$pct%';
  }

  @override
  String get mpEmpty => 'এখনো দাম দেওয়া হয়নি';

  @override
  String trendTitle(String crop) {
    return '$crop – দামের প্রবণতা';
  }

  @override
  String get period7 => '৭ দিন';

  @override
  String get period30 => '৩০ দিন';

  @override
  String get period90 => '৩ মাস';

  @override
  String sinceWeek(String pct) {
    return 'গত সপ্তাহ থেকে $pct';
  }

  @override
  String sinceMonth(String pct) {
    return 'গত মাস থেকে $pct';
  }

  @override
  String since3Months(String pct) {
    return '৩ মাস আগে থেকে $pct';
  }

  @override
  String get rowHighest => 'সর্বোচ্চ';

  @override
  String get rowLowest => 'সর্বনিম্ন';

  @override
  String get rowAverage => 'গড়';

  @override
  String priceAlert(String price) {
    return 'দাম এলার্ট সেট করুন ($price হলে জানাবে)';
  }

  @override
  String get sellAtPrice => 'এই দামে ফসল বিক্রি করুন';

  @override
  String get findInMarket => 'বাজারে খুঁজুন';

  @override
  String get trendNoData => 'এই সময়ের দামের তথ্য এখনো নেই';

  @override
  String get payTitle => 'পেমেন্ট';

  @override
  String get payHeldFarmer => 'নিরাপদ লেনদেনে জমা';

  @override
  String get payReceivedMonth => 'এ মাসে পেয়েছেন';

  @override
  String get payHeldBuyer => 'নিরাপদ লেনদেনে';

  @override
  String get payPaidMonth => 'এ মাসে পরিশোধ';

  @override
  String get payReceiveMethod => 'টাকা গ্রহণের মাধ্যম';

  @override
  String payMethodSub(String phone) {
    return 'বিকাশ · $phone';
  }

  @override
  String get changeLink => 'পরিবর্তন';

  @override
  String get payHistory => 'লেনদেন ইতিহাস';

  @override
  String payItemTitle(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String payHeldSub(String date) {
    return 'নিরাপদ লেনদেনে · $date';
  }

  @override
  String paySentSub(String date) {
    return 'বিকাশে পাঠানো · $date';
  }

  @override
  String payPaidSub(String date) {
    return 'পরিশোধিত · $date';
  }

  @override
  String payTransportTitle(String name) {
    return 'পরিবহন – $name';
  }

  @override
  String get payEmpty => 'এখনো কোনো লেনদেন নেই';

  @override
  String get receiptTitle => 'রসিদ';

  @override
  String receiptPaid(String method) {
    return 'পেমেন্ট সফল · $method';
  }

  @override
  String get receiptHeld => 'নিরাপদ লেনদেনে জমা আছে';

  @override
  String get methodBkash => 'বিকাশ';

  @override
  String get methodBank => 'ব্যাংক';

  @override
  String get rowReceiptNo => 'রসিদ নং';

  @override
  String get rowCrop => 'ফসল';

  @override
  String get rowPrice => 'দাম';

  @override
  String get rowFareLabel => 'পরিবহন ভাড়া';

  @override
  String get rowRoute => 'রুট';

  @override
  String get pdfDownload => 'PDF ডাউনলোড';

  @override
  String cropQty(String crop, String qty) {
    return '$crop, $qty';
  }

  @override
  String get earnTitle => 'আয়';

  @override
  String get earnHistory => 'আয়ের ইতিহাস';

  @override
  String get earnHeldSub => 'নিরাপদ লেনদেনে জমা';

  @override
  String get earnPaidSub => 'পরিশোধিত · বিকাশ';

  @override
  String get earnEmpty => 'এখনো কোনো আয় নেই';

  @override
  String get nidVerifyTitle => 'NID যাচাইকরণ';

  @override
  String get nidVerifyIntro => 'যাচাইকৃত প্রোফাইল ক্রেতার আস্থা বাড়ায়।';

  @override
  String get nidNumberLabel => 'NID নম্বর';

  @override
  String get nidNumberHint => '১০ বা ১৭ সংখ্যা';

  @override
  String get nidFront => 'NID কার্ডের সামনের ছবি';

  @override
  String get nidBack => 'NID কার্ডের পেছনের ছবি';

  @override
  String get selfie => 'আপনার সেলফি';

  @override
  String get submitVerify => 'যাচাইয়ের জন্য জমা দিন';

  @override
  String get errNid => 'সঠিক NID নম্বর দিন (১০ বা ১৭ সংখ্যা)';

  @override
  String get errPhotoNeeded => 'ছবি দিন';

  @override
  String get verifySent => 'যাচাইয়ের জন্য জমা হয়েছে';

  @override
  String get bizVerifyTitle => 'ব্যবসা যাচাইকরণ';

  @override
  String get bizVerifyIntro => 'যাচাইকৃত ব্যবসা কৃষকদের আস্থা বাড়ায়।';

  @override
  String get bizName => 'প্রতিষ্ঠানের নাম';

  @override
  String get bizAddress => 'ব্যবসার ঠিকানা';

  @override
  String get bizAddressHint => 'বিভাগ › জেলা › উপজেলা › এলাকা';

  @override
  String get tradeLicense => 'ট্রেড লাইসেন্স নম্বর';

  @override
  String get tinLabel => 'TIN / BIN নম্বর';

  @override
  String get tinHint => '১২ সংখ্যা';

  @override
  String get licensePhoto => 'ট্রেড লাইসেন্সের ছবি';

  @override
  String get verifyStatusTitle => 'যাচাইকরণ ও রেটিং';

  @override
  String get drivingLicense => 'ড্রাইভিং লাইসেন্স';

  @override
  String get vehiclePapers => 'গাড়ির কাগজপত্র (ফিটনেস)';

  @override
  String get inReview => 'পর্যালোচনায়';

  @override
  String get rowDocs => 'কাগজপত্র';

  @override
  String get rowBizName => 'প্রতিষ্ঠান';

  @override
  String get ratingsTitle => 'রেটিং ও রিভিউ';

  @override
  String outOf5(String avg) {
    return '$avg / ৫';
  }

  @override
  String outOf5Count(String avg, String n) {
    return '$avg / ৫ ($nটি রিভিউ)';
  }

  @override
  String reviewsOnlyDone(String n) {
    return '$nটি রিভিউ · শুধু সম্পন্ন লেনদেন থেকে';
  }

  @override
  String get noReviews => 'এখনো কোনো রিভিউ নেই';

  @override
  String get tag_good_quality => 'ভালো মান';

  @override
  String get tag_right_weight => 'সঠিক ওজন';

  @override
  String get tag_on_time => 'সময়মতো';

  @override
  String get tag_on_time_load => 'সময়মতো লোড';

  @override
  String get tag_correct_info => 'সঠিক তথ্য';

  @override
  String get tag_fast_pay => 'দ্রুত পেমেন্ট';

  @override
  String get trackTitle => 'চালান ট্র্যাকিং';

  @override
  String truckCapRating(String type, String cap, String rating) {
    return '$type · $cap · $rating';
  }

  @override
  String get rowEta => 'আপনার কাছে পৌঁছাবে';

  @override
  String get rowStatus => 'অবস্থা';

  @override
  String get rowRemaining => 'মোট দূরত্ব';

  @override
  String kmOnly(String km) {
    return '$km কিমি';
  }

  @override
  String get tsWaitingPickup => 'পিকআপের অপেক্ষায়';

  @override
  String get tsOnWay => 'আপনার দিকে আসছে';

  @override
  String get tsDelivered => 'পৌঁছেছে';

  @override
  String get messageBtn => 'বার্তা';

  @override
  String get buyerProfileTitle => 'ক্রেতার প্রোফাইল';

  @override
  String get verifiedBusiness => 'যাচাইকৃত ব্যবসা · ট্রেড লাইসেন্স';

  @override
  String get unverifiedBuyer => 'ক্রেতা (ব্যবসা)';

  @override
  String get statReviews => 'রিভিউ';

  @override
  String get statVerification => 'যাচাই';

  @override
  String get seeDemands => 'চাহিদা দেখুন';

  @override
  String get messageShort => 'বার্তা';

  @override
  String get cancelOrder => 'অর্ডার বাতিল করুন';

  @override
  String get cancelOrderTitle => 'অর্ডার বাতিল করবেন?';

  @override
  String cancelOrderBody(String fee, String refund) {
    return 'ট্রাক রওনার আগে বাতিল করলে ভাড়ার ১০% ($fee) ট্রান্সপোর্টার পাবেন, বাকি $refund গোলাঘর থেকে ফেরত পাবেন।';
  }

  @override
  String cancelOrderBodyNoFee(String refund) {
    return 'অর্ডার বাতিল করলে পুরো $refund গোলাঘর থেকে ফেরত পাবেন।';
  }

  @override
  String get yesCancel => 'হ্যাঁ, বাতিল করুন';

  @override
  String get orderCancelled => 'অর্ডার বাতিল হয়েছে';

  @override
  String nOrderCancelled(String no) {
    return 'অর্ডার বাতিল: $no';
  }

  @override
  String get editProfileTitle => 'প্রোফাইল সম্পাদনা';

  @override
  String get profileSaved => 'প্রোফাইল সংরক্ষণ হয়েছে';

  @override
  String get postDemandTitle => 'চাহিদা পোস্ট করুন';

  @override
  String get stepProductQty => 'পণ্য ও পরিমাণ';

  @override
  String get stepDelivery => 'ডেলিভারি';

  @override
  String get fieldCropName => 'ফসল';

  @override
  String get fieldGradeSize => 'গ্রেড / মান';

  @override
  String get fieldTargetPrice => 'লক্ষ্য দাম';

  @override
  String marketRateLine(String min, String max) {
    return 'বাজার দর: ৳ $min–$max / কেজি';
  }

  @override
  String get deliveryLocation => 'ডেলিভারি লোকেশন';

  @override
  String get deliveryDate => 'ডেলিভারি তারিখ';

  @override
  String get repeatOnce => 'একবার';

  @override
  String get repeatOnceSub => 'শুধু এই অর্ডার';

  @override
  String get repeatMonthly => 'নিয়মিত (রিপিট)';

  @override
  String get repeatMonthlySub => 'প্রতি মাসে';

  @override
  String get publishDemand => 'চাহিদা প্রকাশ করুন';

  @override
  String get demandPosted => 'চাহিদা প্রকাশ হয়েছে';

  @override
  String get myDemandsTitle => 'আমার চাহিদা';

  @override
  String get noDemands => 'কোনো চাহিদা নেই';

  @override
  String demandLine(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String demandSubTarget(String date, String price) {
    return '$date · লক্ষ্য ৳ $price';
  }

  @override
  String offersReceived(String n) {
    return 'প্রাপ্ত অফার ($n)';
  }

  @override
  String get sortPrice => 'দাম';

  @override
  String get sortQuality => 'মান';

  @override
  String get sortRating => 'রেটিং';

  @override
  String commitSub(String qty, String grade, String rating) {
    return '$qty · গ্রেড $grade · $rating';
  }

  @override
  String get selectedTotal => 'নির্বাচিত মোট';

  @override
  String ofKg(String a, String b) {
    return '$a / $b কেজি';
  }

  @override
  String get acceptSelected => 'নির্বাচিত অফার গ্রহণ';

  @override
  String get noCommits => 'এখনো কোনো কৃষক অফার দেননি';

  @override
  String get commitsAccepted => 'অফার গ্রহণ হয়েছে, অর্ডার তৈরি হয়েছে';

  @override
  String get selectCommit => 'অন্তত একটি অফার বেছে নিন';

  @override
  String get acceptedBadge => 'গৃহীত';

  @override
  String get closeDemand => 'চাহিদা বন্ধ করুন';

  @override
  String get demandClosed => 'বন্ধ';

  @override
  String get demandOpen => 'চলমান';

  @override
  String get demandFilled => 'পূর্ণ';

  @override
  String get buyerDemandsTitle => 'ক্রেতার চাহিদা';

  @override
  String get demandSearchHint => 'ফসল বা এলাকা খুঁজুন';

  @override
  String get filterBigOrder => 'বড় অর্ডার';

  @override
  String get filterExport => 'বিদেশি';

  @override
  String demandRowSub(String buyer, String date) {
    return '$buyer · $date';
  }

  @override
  String poolingSub(String pct) {
    return 'পুলিং চলছে · $pct% পূর্ণ';
  }

  @override
  String get demandDetailsTitle => 'চাহিদার বিবরণ';

  @override
  String get rowNeed => 'প্রয়োজন';

  @override
  String get rowDelivery => 'ডেলিভারি';

  @override
  String ratingTrades(String avg, String n) {
    return '$avg ($n লেনদেন)';
  }

  @override
  String get poolingProgress => 'পুলিং অগ্রগতি';

  @override
  String get poolingNote => 'একাধিক কৃষক মিলে এই অর্ডার পূরণ করা যাবে।';

  @override
  String get futureHarvest => 'ভবিষ্যৎ ফসল থেকে দেব (হারভেস্ট)';

  @override
  String get wantToSupply => 'সরবরাহ দিতে চাই';

  @override
  String get howMuchSupply => 'কত কেজি দিতে পারবেন?';

  @override
  String get readyFrom => 'প্রস্তুত থাকবে';

  @override
  String get estTotal => 'মোট পাবেন (আনুমানিক)';

  @override
  String get commitSent => 'সরবরাহের প্রস্তাব পাঠানো হয়েছে';

  @override
  String myCommitLine(String qty, String status) {
    return 'আপনার প্রস্তাব: $qty · $status';
  }

  @override
  String get commitPending => 'অপেক্ষমাণ';

  @override
  String errQtyLeft(String qty) {
    return 'বাকি আছে $qty';
  }

  @override
  String nCommitNew(String crop) {
    return 'নতুন সরবরাহ প্রস্তাব: $crop';
  }

  @override
  String nCommitNewBody(String farmer, String qty) {
    return '$farmer · $qty';
  }

  @override
  String nCommitAccepted(String no) {
    return 'আপনার সরবরাহ গৃহীত: $no';
  }

  @override
  String get closeDemandBody =>
      'চাহিদা বন্ধ করলে কৃষকরা আর সরবরাহ প্রস্তাব দিতে পারবেন না। গৃহীত অর্ডার চলবে।';

  @override
  String get messagesTitle => 'বার্তা';

  @override
  String get searchNameHint => 'নাম খুঁজুন';

  @override
  String get noChats => 'এখনো কোনো বার্তা নেই';

  @override
  String get typeMessage => 'বার্তা লিখুন…';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get chatStart => 'কথা শুরু করুন';

  @override
  String nameWithRole(String name, String role) {
    return '$name ($role)';
  }

  @override
  String get roleDriverShort => 'চালক';

  @override
  String get helpTitle => 'সাহায্য ও সহায়তা';

  @override
  String get callHelpline => 'হেল্পলাইনে কল করুন';

  @override
  String get commonQuestions => 'সাধারণ প্রশ্ন';

  @override
  String listenTime(String t) {
    return 'শুনুন · $t';
  }

  @override
  String get chatHelp => 'চ্যাটে সাহায্য নিন';

  @override
  String get faqTitle => 'প্রশ্ন ও উত্তর';

  @override
  String get faqUseful => 'এই উত্তর কি কাজে লেগেছে?';

  @override
  String get faqYes => 'হ্যাঁ 👍';

  @override
  String get faqNo => 'না 👎';

  @override
  String get faqThanks => 'মতামতের জন্য ধন্যবাদ';

  @override
  String get supportName => 'গোলাঘর সহায়তা';

  @override
  String get q1 => 'কীভাবে ফসল বিক্রি করবেন';

  @override
  String get q1Farmer =>
      'নিচের \"বিক্রি\" বোতাম চাপুন → ফসল, মান, পরিমাণ ও ছবি দিন → দাম, তারিখ ও পিকআপ ঠিকানা দিন → প্রকাশ করুন। মডারেটর অনুমোদনের পর ক্রেতারা দেখতে ও অফার দিতে পারবেন।';

  @override
  String get q2 => 'কীভাবে পেমেন্ট পাবেন';

  @override
  String get q2Farmer =>
      'ট্রাকে মাল লোড শেষ হলেই আপনার টাকা নিরাপদ লেনদেন থেকে ছাড় হয়। এই পেমেন্ট চূড়ান্ত — পরে আটকানো বা ফেরত নেওয়া যাবে না।';

  @override
  String get q2Transporter =>
      'ক্রেতার কাছে মাল পৌঁছে ক্রেতার OTP দিলে ভাড়া পাবেন। রওনার আগে অর্ডার বাতিল হলে ভাড়ার ১০% পাবেন।';

  @override
  String get q2Buyer =>
      'অর্ডারের টাকা নিরাপদ লেনদেনে জমা থাকে। মান ও পরিমাণ লোডের সময়ই চূড়ান্ত হয়, তাই লোডের আগে দেখে নিন।';

  @override
  String get q3 => 'ট্রাক কে বুক করেন?';

  @override
  String get q3Buyer =>
      'অর্ডারে \"প্ল্যাটফর্মের ট্রাক\" বাছলে ট্রাকচালকরা ভাড়ার প্রস্তাব দেন, আপনি একটি বেছে বুক করেন। \"নিজে পরিবহন করব\" বাছলে আপনি নিজে মাল নিয়ে যাবেন।';

  @override
  String get q4 => 'নিরাপদ লেনদেন কী?';

  @override
  String get q4Body =>
      'ক্রেতার টাকা গোলাঘরে জমা থাকে। মাল লোড হলে কৃষক এবং ডেলিভারি হলে পরিবহনকারী টাকা পান। এতে কেউ ঠকেন না।';

  @override
  String get q5 => 'অফার বাতিল করলে কী হবে?';

  @override
  String get q5Body =>
      'প্রত্যাখ্যাত অফার আর গ্রহণ করা যায় না, তবে ক্রেতা নতুন অফার দিতে পারেন। অর্ডার হওয়ার আগে কোনো টাকা কাটা হয় না।';

  @override
  String get voiceGuideTitle => 'ভয়েস গাইড';
}
