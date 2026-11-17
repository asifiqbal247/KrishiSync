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
      'পণ্য গাড়িতে উঠলেই কৃষকের টাকা, ক্রেতার কাছে পৌঁছালেই ট্রান্সপোর্টারের টাকা।';

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
      'টাকা নিরাপদ লেনদেনে জমা আছে। পণ্য গাড়িতে উঠলেই কৃষক টাকা পাবেন।';

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
  String get rowGoods => 'পণ্য';

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
  String get loadConfirmTitle => 'পণ্য গাড়িতে উঠেছে?';

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
  String get goodsWeight => 'পণ্য ও ওজন';

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
  String get handedOverBody => 'ক্রেতার গাড়িতে পণ্য তোলা হলে নিশ্চিত করুন।';

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
    return 'পণ্য গাড়িতে উঠেছে: $no';
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
      'পণ্য গাড়িতে উঠলে কৃষক, আর আপনার কাছে পৌঁছালে ট্রান্সপোর্টার নিরাপদ লেনদেন থেকে টাকা পাবেন। ১% ফি শুধু ক্রেতা দেবেন, লোড হলে কাটা হবে। ট্রাক রওনার আগে অর্ডার বাতিল করলে ভাড়ার ১০% কাটা যাবে, বাকি সব গোলাঘর থেকে ফেরত পাবেন। এরপর লোড বাতিল হলে ফসলের দাম ও ফি ফেরত পাবেন, ভাড়া নয়।';

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
      'ক্রেতার টাকা নিরাপদ লেনদেনে জমা থাকে। পণ্য গাড়িতে উঠলে কৃষক এবং ডেলিভারি OTP দিলে পরিবহনকারী টাকা পান। ১% প্ল্যাটফর্ম ফি শুধু ক্রেতা দেন। মান ও পরিমাণ লোডের সময়ই চূড়ান্ত হয়।';

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
      'ট্রাকে পণ্য লোড শেষ হলেই আপনার টাকা নিরাপদ লেনদেন থেকে ছাড় হয়। এই পেমেন্ট চূড়ান্ত — পরে আটকানো বা ফেরত নেওয়া যাবে না।';

  @override
  String get q2Transporter =>
      'ক্রেতার কাছে পণ্য পৌঁছে ক্রেতার OTP দিলে ভাড়া পাবেন। রওনার আগে অর্ডার বাতিল হলে ভাড়ার ১০% পাবেন।';

  @override
  String get q2Buyer =>
      'অর্ডারের টাকা নিরাপদ লেনদেনে জমা থাকে। মান ও পরিমাণ লোডের সময়ই চূড়ান্ত হয়, তাই লোডের আগে দেখে নিন।';

  @override
  String get q3 => 'ট্রাক কে বুক করেন?';

  @override
  String get q3Buyer =>
      'অর্ডারে \"প্ল্যাটফর্মের ট্রাক\" বাছলে ট্রাকচালকরা ভাড়ার প্রস্তাব দেন, আপনি একটি বেছে বুক করেন। \"নিজে পরিবহন করব\" বাছলে আপনি নিজে পণ্য নিয়ে যাবেন।';

  @override
  String get q4 => 'নিরাপদ লেনদেন কী?';

  @override
  String get q4Body =>
      'ক্রেতার টাকা গোলাঘরে জমা থাকে। পণ্য লোড হলে কৃষক এবং ডেলিভারি হলে পরিবহনকারী টাকা পান। এতে কেউ ঠকেন না।';

  @override
  String get q5 => 'অফার বাতিল করলে কী হবে?';

  @override
  String get q5Body =>
      'প্রত্যাখ্যাত অফার আর গ্রহণ করা যায় না, তবে ক্রেতা নতুন অফার দিতে পারেন। অর্ডার হওয়ার আগে কোনো টাকা কাটা হয় না।';

  @override
  String get voiceGuideTitle => 'ভয়েস গাইড';

  @override
  String get pmTitle => 'পেমেন্ট মাধ্যম';

  @override
  String get pmIntro =>
      'কৃষক ও ট্রান্সপোর্টার: টাকা কোথায় পাবেন · ক্রেতা: কোথা থেকে টাকা দেবেন';

  @override
  String get pmDefault => 'ডিফল্ট';

  @override
  String get pmMakeDefault => 'বদলান';

  @override
  String pmNameMatched(String name) {
    return 'নাম মিলেছে: $name';
  }

  @override
  String pmWalletLine(String type, String number) {
    return '$type · $number';
  }

  @override
  String pmBankSub(String name, String branch) {
    return '$name · $branch শাখা';
  }

  @override
  String get pmAdd => '+ নতুন মাধ্যম যোগ করুন';

  @override
  String get pmSafetyTitle => 'নিরাপত্তা';

  @override
  String get pmSafetyBody =>
      'নাম মেলানো ছাড়া নতুন মাধ্যমে টাকা যাবে না। মাধ্যম বদলালে ২৪ ঘণ্টা আগের মাধ্যমেই টাকা যাবে, যাতে কেউ প্রতারণা করতে না পারে।';

  @override
  String get pmNone => 'এখনো কোনো মাধ্যম যোগ করা হয়নি';

  @override
  String get pmAddTitle => 'মাধ্যম যোগ করুন';

  @override
  String get pmWhich => 'কোন মাধ্যম যোগ করবেন?';

  @override
  String get pmBkash => 'বিকাশ';

  @override
  String get pmNagad => 'নগদ';

  @override
  String get pmRocket => 'রকেট';

  @override
  String get pmBank => 'ব্যাংক অ্যাকাউন্ট';

  @override
  String get pmWalletInstant => 'মোবাইল ওয়ালেট · সাথে সাথে টাকা';

  @override
  String get pmWallet => 'মোবাইল ওয়ালেট';

  @override
  String get pmBankSlow => 'বড় অঙ্কের জন্য · ১ কার্যদিবস';

  @override
  String pmNumberTitle(String type) {
    return '$type নম্বর';
  }

  @override
  String get pmOwnNumber =>
      'নম্বরটি আপনার নিজের নামে হতে হবে। অন্যের নম্বরে টাকা পাঠানো যাবে না।';

  @override
  String get pmWhyTitle => 'কেন';

  @override
  String get pmWhyBody => 'ভুল নম্বরে টাকা চলে যাওয়া ও প্রতারণা ঠেকাতে।';

  @override
  String get pmVerifyTitle => 'নম্বর যাচাই';

  @override
  String pmVerifySub(String type) {
    return '$type অ্যাকাউন্টের নাম ও প্রোফাইলের নাম এক';
  }

  @override
  String pmVerifyIntro(String number) {
    return '$number নম্বরটি আপনার প্রোফাইলের নামে যোগ হবে।';
  }

  @override
  String get pmSetDefault => 'এটিকে ডিফল্ট মাধ্যম হিসেবে রাখুন';

  @override
  String get pmSaved => 'পেমেন্ট মাধ্যম সংরক্ষণ হয়েছে';

  @override
  String get pmBankTitle => 'ব্যাংক অ্যাকাউন্ট';

  @override
  String get pmBankName => 'ব্যাংক';

  @override
  String get pmBranch => 'শাখা';

  @override
  String get pmAccName => 'অ্যাকাউন্টের নাম';

  @override
  String get pmAccNameHint => 'প্রোফাইলের নামের সাথে মিলতে হবে';

  @override
  String get pmAccNo => 'অ্যাকাউন্ট নম্বর';

  @override
  String get pmAccNoHint => '১৩–১৭ সংখ্যা';

  @override
  String get pmBankNote =>
      'রাউটিং নম্বর শাখা থেকে স্বয়ংক্রিয়ভাবে বসবে। যাচাইয়ের জন্য ১ টাকা পাঠানো হবে (১ কার্যদিবস)।';

  @override
  String get pmStartVerify => 'যাচাই শুরু করুন';

  @override
  String get pmErrAccNo => '১৩–১৭ সংখ্যার অ্যাকাউন্ট নম্বর দিন';

  @override
  String get pmErrName => 'নাম প্রোফাইলের সাথে মিলছে না';

  @override
  String get pmSendCode => 'যাচাই কোড পাঠান';

  @override
  String get pmSave => 'সেভ করুন';

  @override
  String get pmVerifying => 'যাচাই হচ্ছে';

  @override
  String get pmVerifiedShort => 'যাচাইকৃত';

  @override
  String get tipTitle => 'কৃষি টিপস';

  @override
  String get tipPriceBody1 =>
      'বিক্রির আগে \"বাজার দর\" দেখুন। দাম বাজারের সীমার মধ্যে রাখলে ক্রেতা দ্রুত অফার দেন।';

  @override
  String get tipPriceBody2 =>
      'ফসলের পরিষ্কার ছবি দিন — দিনের আলোয়, কাছ থেকে। ভালো ছবিতে বেশি দাম পাওয়া যায়।';

  @override
  String get tipPriceBody3 =>
      'ক্রেতার চাহিদা দেখে একসাথে বড় চালান দিন; পুলিং করলে পরিবহন খরচ কমে।';

  @override
  String get tipPackBody1 =>
      'টমেটো ও নরম সবজি ২০ কেজির ক্রেটে রাখুন, বস্তায় নয় — এতে কম নষ্ট হয়।';

  @override
  String get tipPackBody2 =>
      'আলু ও পেঁয়াজ শুকনো, বাতাস চলাচল করে এমন বস্তায় রাখুন।';

  @override
  String get tipPackBody3 =>
      'লোডের আগে ভেজা বা পচা ফসল আলাদা করুন — মান লোডের সময়ই চূড়ান্ত হয়।';

  @override
  String get tipGradeBody1 =>
      'গ্রেড A: সমান আকার, দাগহীন, পুরো পাকা বা নির্দিষ্ট পাকা।';

  @override
  String get tipGradeBody2 =>
      'গ্রেড B: সামান্য দাগ বা আকারে কিছুটা ভিন্ন, তবে খাওয়ার উপযোগী।';

  @override
  String get tipGradeBody3 =>
      'গ্রেড C: বেশি দাগ বা ছোট আকার — প্রক্রিয়াজাতকরণের জন্য।';

  @override
  String get globalBuyersTitle => 'বিদেশি ক্রেতা';

  @override
  String get globalBuyersIntro =>
      'বিদেশি ক্রেতা ও আমদানিকারকদের কাছে ফসল বিক্রি করুন।';

  @override
  String get noExportDemand =>
      'এখনো বিদেশি ক্রেতার চাহিদা নেই। রপ্তানির প্রস্তুতি নিতে গাইড দেখুন।';

  @override
  String get seeExportGuide => 'রপ্তানি গাইড দেখুন';

  @override
  String get exportGuideTitle => 'রপ্তানি গাইড';

  @override
  String get exportSteps => 'ধাপসমূহ';

  @override
  String get exStep1 => 'প্রোফাইল যাচাই';

  @override
  String get exStep1Sub => 'NID ও জমির তথ্য';

  @override
  String get exStep2 => 'মান সনদ';

  @override
  String get exStep2Sub => 'ফাইটোস্যানিটারি সার্টিফিকেট';

  @override
  String get exStep3 => 'প্যাকেজিং';

  @override
  String get exStep3Sub => 'রপ্তানি মান অনুযায়ী';

  @override
  String get exStep4 => 'চুক্তি ও পেমেন্ট';

  @override
  String get exStep4Sub => 'নিরাপদ লেনদেন বা LC';

  @override
  String get exDocs => 'প্রয়োজনীয় কাগজপত্র';

  @override
  String get exDoc1 => 'ফাইটোস্যানিটারি সার্টিফিকেট';

  @override
  String get exDoc1Sub => 'কৃষি সম্প্রসারণ অধিদপ্তর';

  @override
  String get exDoc2 => 'ট্রেড লাইসেন্স';

  @override
  String get exDoc2Sub => 'অথবা কৃষক সমবায় সনদ';

  @override
  String get shareTitle => 'ট্র্যাক রেকর্ড শেয়ার';

  @override
  String statRatingReviews(String n) {
    return 'রেটিং ($n রিভিউ)';
  }

  @override
  String memberSince(String year) {
    return '$year থেকে';
  }

  @override
  String get memberLabel => 'সদস্য';

  @override
  String shareCode(String code) {
    return 'গোলাঘর আইডি: $code';
  }

  @override
  String get shareVerifiedToday => 'গোলাঘর যাচাইকৃত · আপডেট: আজ';

  @override
  String get shareQrNote => 'QR স্ক্যান করলে এই তথ্য দেখা যাবে';

  @override
  String get whatToShow => 'কী দেখাবেন';

  @override
  String get showDeals => 'লেনদেন সংখ্যা ও সময়মতো %';

  @override
  String get showRatings => 'রেটিং ও রিভিউ';

  @override
  String get showMoney => 'টাকার পরিমাণ';

  @override
  String get visibleAll => 'সবাই দেখতে পাবে';

  @override
  String get hiddenPrivacy => 'গোপনীয়তার জন্য বন্ধ';

  @override
  String get onLabel => 'চালু';

  @override
  String get offLabel => 'বন্ধ';

  @override
  String get loanNote =>
      'ব্যাংক বা এনজিওতে দেখিয়ে নিজে লোন নিতে পারবেন (অ্যাপে কোনো লোন নেই)।';

  @override
  String get copyLink => 'লিংক কপি';

  @override
  String get shareNow => 'শেয়ার করুন';

  @override
  String get copied => 'কপি হয়েছে';

  @override
  String get shareHeader => 'গোলাঘর ট্র্যাক রেকর্ড';

  @override
  String shareMoneyLine(String amount) {
    return 'মোট লেনদেন: $amount';
  }

  @override
  String get historyTitle => 'লেনদেনের ইতিহাস';

  @override
  String get histIncomeMonth => 'এ মাসে আয়';

  @override
  String get histBuyMonth => 'এ মাসে কেনা';

  @override
  String get histSearchHint => 'অর্ডার নং, ফসল বা নাম খুঁজুন';

  @override
  String get histReceived => 'পেয়েছেন';

  @override
  String get histPaid => 'পরিশোধিত';

  @override
  String get histHeld => 'নিরাপদ লেনদেনে';

  @override
  String get histCancelled => 'বাতিল';

  @override
  String monthTotal(String amount) {
    return 'মোট $amount';
  }

  @override
  String histRowSub(String party, String date, String status) {
    return '$party · $date · $status';
  }

  @override
  String get histEmpty => 'এই সময়ে কোনো লেনদেন নেই';

  @override
  String get statementBtn => 'স্টেটমেন্ট ডাউনলোড / শেয়ার';

  @override
  String get statementTitle => 'স্টেটমেন্ট তৈরি';

  @override
  String get periodLabel => 'সময়কাল';

  @override
  String get periodThisMonth => 'এ মাস';

  @override
  String get periodLast3 => 'গত ৩ মাস';

  @override
  String get period12 => '১২ মাস · ব্যাংকের জন্য';

  @override
  String get periodCustom => 'নিজে বাছুন';

  @override
  String get rowPeriod => 'সময়কাল';

  @override
  String get rowTotalDeals => 'মোট লেনদেন';

  @override
  String get rowTotalIncome => 'মোট আয়';

  @override
  String get rowTotalSpent => 'মোট খরচ';

  @override
  String dateRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get statementPrivacy =>
      'আপনার ফোন নম্বর ও NID স্টেটমেন্টে লুকানো থাকবে।';

  @override
  String get shareLabel => 'শেয়ার করুন';

  @override
  String get shareWhatsapp => 'হোয়াটসঅ্যাপ';

  @override
  String get shareEmail => 'ইমেইল';

  @override
  String get shareMessenger => 'মেসেঞ্জার';

  @override
  String get shareOther => 'অন্যান্য';

  @override
  String get pdfDownloadFull => 'PDF ডাউনলোড করুন';

  @override
  String get statementHeader => 'গোলাঘর স্টেটমেন্ট';

  @override
  String get statementVerified => 'গোলাঘর যাচাইকৃত';

  @override
  String priceAlertOn(String price) {
    return 'দাম সতর্কতা চালু · $price · বন্ধ করুন';
  }

  @override
  String get priceAlertTitle => 'দাম সতর্কতা';

  @override
  String get priceAlertHintUp =>
      'দাম এই টার্গেটে বা তার বেশি হলে অ্যাপে নোটিফিকেশন পাবেন।';

  @override
  String get priceAlertHintDown =>
      'দাম এই টার্গেটে বা তার কম হলে অ্যাপে নোটিফিকেশন পাবেন।';

  @override
  String get priceAlertSet => 'দাম সতর্কতা চালু হয়েছে';

  @override
  String get priceAlertRemoveQ => 'দাম সতর্কতা বন্ধ করবেন?';

  @override
  String get priceAlertRemoveBody =>
      'এই ফসলের দাম নিয়ে আর নোটিফিকেশন পাবেন না।';

  @override
  String get priceAlertRemove => 'বন্ধ করুন';

  @override
  String nPriceAlert(String crop) {
    return '$crop-এর দাম টার্গেটে পৌঁছেছে';
  }

  @override
  String nPriceAlertBody(String price) {
    return 'আজকের দাম $price/কেজি';
  }

  @override
  String get contractsTitle => 'চুক্তি';

  @override
  String get contractNew => 'নতুন';

  @override
  String get contractActive => 'চলমান';

  @override
  String get contractPending => 'অপেক্ষমাণ';

  @override
  String get contractDone => 'সম্পন্ন';

  @override
  String get contractRejected => 'প্রত্যাখ্যাত';

  @override
  String get contractCancelled => 'বাতিল';

  @override
  String get contractsEmpty => 'এখানে কোনো চুক্তি নেই';

  @override
  String get freqMonthly => 'মাসিক';

  @override
  String get freqWeekly => 'সাপ্তাহিক';

  @override
  String contractFarmerSub(String freq, String crop, String months) {
    return '$freq $crop সরবরাহ · $months মাস';
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
  String get newContractBtn => '+ নতুন চুক্তি';

  @override
  String get contractDetailsTitle => 'চুক্তির বিবরণ';

  @override
  String buyerVerifiedLine(String name) {
    return '$name (যাচাইকৃত)';
  }

  @override
  String contractPriceFixed(String price) {
    return '$price / কেজি (নির্ধারিত)';
  }

  @override
  String get contractTerms => 'চুক্তির শর্ত';

  @override
  String get rowTerm => 'মেয়াদ';

  @override
  String perMonthQty(String qty) {
    return 'প্রতি মাসে $qty';
  }

  @override
  String perWeekQty(String qty) {
    return 'প্রতি সপ্তাহে $qty';
  }

  @override
  String get contractPayValue => 'প্রতি লোডের সময় (নিরাপদ লেনদেন থেকে)';

  @override
  String get acceptContract => 'চুক্তি গ্রহণ';

  @override
  String get rejectContractQ => 'চুক্তি প্রত্যাখ্যান করবেন?';

  @override
  String get rejectContractBody =>
      'অপর পক্ষকে জানানো হবে। এটি আর গ্রহণ করা যাবে না, তবে তারা নতুন প্রস্তাব দিতে পারবেন।';

  @override
  String get cancelContractQ => 'চুক্তি বাতিল করবেন?';

  @override
  String get cancelContractBody =>
      'বাকি সরবরাহ বন্ধ হবে। আগে লোড হওয়া পণ্যের পেমেন্ট ফেরত হবে না — যা হয়েছে তা চূড়ান্ত।';

  @override
  String get yesCancelIt => 'হ্যাঁ, বাতিল করুন';

  @override
  String get contractAccepted => 'চুক্তি গ্রহণ করা হয়েছে';

  @override
  String get newContractTitle => 'নতুন চুক্তি';

  @override
  String get fieldSupplier => 'সরবরাহকারী';

  @override
  String get fieldCropGrade => 'ফসল ও মান';

  @override
  String cropGradeValue(String crop, String grade) {
    return '$crop, গ্রেড $grade';
  }

  @override
  String get fieldQtyPerDelivery => 'পরিমাণ (প্রতি ডেলিভারি)';

  @override
  String get fieldFixedPrice => 'নির্ধারিত দাম';

  @override
  String get sendContract => 'চুক্তি পাঠান';

  @override
  String get contractSent => 'চুক্তি পাঠানো হয়েছে';

  @override
  String get errSelectSupplier => 'সরবরাহকারী বাছুন';

  @override
  String get errSelectCrop => 'ফসল বাছুন';

  @override
  String get searchFarmerHint => 'কৃষকের নাম খুঁজুন';

  @override
  String get contractStatusTitle => 'চুক্তির অবস্থা';

  @override
  String get rowContract => 'চুক্তি';

  @override
  String get rowSupplier => 'সরবরাহকারী';

  @override
  String get rowBuyerLabel => 'ক্রেতা';

  @override
  String get deliverySchedule => 'ডেলিভারি সূচি';

  @override
  String monthDelivery(String month) {
    return '$month ডেলিভারি';
  }

  @override
  String weekDelivery(String n) {
    return 'সপ্তাহ $n ডেলিভারি';
  }

  @override
  String deliveryOrdered(String qty) {
    return '$qty · অর্ডার হয়েছে';
  }

  @override
  String deliveryDue(String date) {
    return 'নির্ধারিত: $date';
  }

  @override
  String get cancelContract => 'চুক্তি বাতিল';

  @override
  String get renewContract => 'নবায়ন করুন';

  @override
  String get orderDeliveryQ => 'এই ডেলিভারির অর্ডার দেবেন?';

  @override
  String orderDeliveryBody(String qty, String amount) {
    return '$qty · $amount নিরাপদ লেনদেনে জমা থাকবে, পণ্য পৌঁছালে কৃষক পাবেন।';
  }

  @override
  String get orderNow => 'অর্ডার দিন';

  @override
  String get contractRenewed => 'নবায়নের প্রস্তাব পাঠানো হয়েছে';

  @override
  String nContractNew(String crop) {
    return 'নতুন চুক্তির প্রস্তাব: $crop';
  }

  @override
  String nContractActive(String crop) {
    return 'চুক্তি গ্রহণ করেছেন: $crop';
  }

  @override
  String nContractRejected(String crop) {
    return 'চুক্তি প্রত্যাখ্যাত: $crop';
  }

  @override
  String nContractCancelled(String crop) {
    return 'চুক্তি বাতিল: $crop';
  }

  @override
  String nContractOrder(String no) {
    return 'চুক্তির ডেলিভারি অর্ডার: $no';
  }

  @override
  String get truckComingTitle => 'আপনার পণ্য নিতে ট্রাক';

  @override
  String get truckBookedByBuyer => 'ক্রেতা ট্রাক বুক করেছেন';

  @override
  String truckBookedBody(String name) {
    return '$name এই ট্রাক পাঠাচ্ছেন। ভাড়া ক্রেতা দেবেন, আপনাকে কিছু বুক করতে বা দিতে হবে না।';
  }

  @override
  String get truckNotBooked => 'এখনো ট্রাক বুক হয়নি';

  @override
  String get truckNotBookedBody =>
      'ক্রেতা ট্রাক বুক করলে এখানে ড্রাইভার ও আপনার OTP দেখাবে।';

  @override
  String get rowWhenComes => 'কখন আসবে';

  @override
  String get rowWhereComes => 'কোথায় আসবে';

  @override
  String cropQtyComma(String a, String b) {
    return '$a, $b';
  }

  @override
  String nameDistrict(String name, String district) {
    return '$name, $district';
  }

  @override
  String get truckComingSection => 'যে ট্রাক আসছে';

  @override
  String yourLoadOtp(String code) {
    return 'আপনার OTP: $code';
  }

  @override
  String get yourLoadOtpBody =>
      'পণ্য প্রস্তুত রাখুন। ওজন দেখে তবেই ড্রাইভারকে এই OTP দিন, সাথে সাথে টাকা পাবেন।';

  @override
  String get weightMoreTitle => 'বেশি ওজন';

  @override
  String get waitingBuyer => 'ক্রেতার উত্তরের অপেক্ষা';

  @override
  String waitingBuyerBody(String qty) {
    return 'স্কেলে $qty বেশি এসেছে। ক্রেতা অনুমোদন দিলে বাড়তি পণ্যের টাকাও পাবেন।';
  }

  @override
  String get rowWeighed => 'মাপা হয়েছে';

  @override
  String get rowExtraPrice => 'বাড়তি দাম';

  @override
  String get rowReplyTime => 'উত্তরের সময়';

  @override
  String minutes(String n) {
    return '$n মিনিট';
  }

  @override
  String get ifNoReply => 'উত্তর না এলে';

  @override
  String ifNoReplyBody(String n, String qty) {
    return 'ক্রেতা $n মিনিটে উত্তর না দিলে শুধু $qty লোড হবে।';
  }

  @override
  String get trackChalan => 'চালান ট্র্যাক করুন';

  @override
  String get goHome => 'হোমে যান';

  @override
  String get weightLessTitle => 'ওজন কম';

  @override
  String get loadedTitle => 'পণ্য লোড হয়েছে';

  @override
  String get weightLessHeading => 'ওজন কম ধরা পড়েছে';

  @override
  String get weightLessBody =>
      'ডিজিটাল স্কেলে যত কেজি মাপা হয়েছে, আপনি ততটুকুর টাকা পেয়েছেন।';

  @override
  String get moneySent => 'টাকা পাঠানো হয়েছে!';

  @override
  String get moneySentBody =>
      'পণ্য গাড়িতে ওঠার সাথে সাথে আপনার টাকা ছাড় হয়েছে।';

  @override
  String get rowWeightDigital => 'ওজন (ডিজিটাল)';

  @override
  String get rowReceivedTotal => 'মোট পেয়েছেন';

  @override
  String get rowMethod => 'মাধ্যম';

  @override
  String get moneyFinal => 'এই টাকা চূড়ান্ত';

  @override
  String get moneyFinalBody =>
      'পরে কোনো সমস্যা হলেও এই টাকা আটকানো বা ফেরত নেওয়া যাবে না।';

  @override
  String get moneyFinalLessBody =>
      'ওজন ও ছবি সংরক্ষিত আছে। বাকি টাকা ক্রেতা ফেরত পাবেন।';

  @override
  String get seePayments => 'পেমেন্ট দেখুন';

  @override
  String get weighTitle => 'পিকআপ: লোড ও ওজন';

  @override
  String nameDot(String a, String b) {
    return '$a · $b';
  }

  @override
  String gradeStop(String grade, String i, String n) {
    return 'গ্রেড $grade · স্টপ $i/$n';
  }

  @override
  String get oneMon => '১ মন';

  @override
  String monFixed(String kg) {
    return '$kg কেজি (নির্ধারিত)';
  }

  @override
  String get scaleNote => 'ডিজিটাল স্কেল · সময় ও লোকেশনসহ সংরক্ষিত';

  @override
  String scalePhotos(String n, String max) {
    return 'স্কেল ও পণ্যের ছবি তুলুন ($n/$max)';
  }

  @override
  String get farmerOtp => 'কৃষকের OTP';

  @override
  String get weighNote =>
      'কৃষক OTP দিলে লোড নিশ্চিত ও টাকা ছাড় হবে। কম হলে বাকি টাকা ক্রেতা পাবেন, বেশি হলে আগে অনুমোদন লাগবে।';

  @override
  String get notLoadedReport => 'লোড হয়নি? বাতিল জানান';

  @override
  String get otpAndLoad => 'OTP দিন ও লোড নিশ্চিত করুন';

  @override
  String extraWaitNote(String extra, String qty) {
    return '$extra বেশি — ক্রেতার উত্তরের অপেক্ষা। উত্তর না এলে শুধু $qty লোড হবে।';
  }

  @override
  String extraLoadOrdered(String qty) {
    return 'শুধু অর্ডারের $qty লোড করুন';
  }

  @override
  String extraApprovedNote(String qty) {
    return 'ক্রেতা অনুমোদন দিয়েছেন — $qty লোড করুন';
  }

  @override
  String loadDone(String qty) {
    return '$qty লোড নিশ্চিত হয়েছে';
  }

  @override
  String get weightDiffTitle => 'ওজনের পার্থক্য';

  @override
  String weightLessRefund(String amount) {
    return 'ওজন কম হয়েছে: $amount ফেরত পাবেন';
  }

  @override
  String weightLessRefundBody(String no, String crop) {
    return '$no · $crop। ডিজিটাল স্কেলে যত কেজি মাপা হয়েছে, আপনি শুধু ততটুকুর দাম দেবেন।';
  }

  @override
  String get rowOrderedKg => 'অর্ডার করেছিলেন';

  @override
  String get rowLoadWeighed => 'লোডে মাপা হয়েছে';

  @override
  String get rowLess => 'কম';

  @override
  String rowCropRefund(String price) {
    return 'ফসলের দাম ফেরত (৳ $price/কেজি)';
  }

  @override
  String rowFeeRefund(String pct) {
    return 'ফি ফেরত ($pct%)';
  }

  @override
  String get rowTotalRefund => 'মোট ফেরত';

  @override
  String weightLessNote(String qty) {
    return 'কৃষক $qty-এর দাম পেয়েছেন। পরিবহন ভাড়া একই থাকবে। টাকা ৩ কর্মদিবসের মধ্যে একই মাধ্যমে ফেরত যাবে।';
  }

  @override
  String get seeWeighReport => 'ওজন ও ছবির রিপোর্ট দেখুন';

  @override
  String get seeRefundStatus => 'রিফান্ডের অবস্থা দেখুন';

  @override
  String get noLoadPhotos => 'লোডের সময় কোনো ছবি তোলা হয়নি';

  @override
  String weighReportTitle(String qty) {
    return 'ওজন রিপোর্ট · $qty';
  }

  @override
  String extraNeedApproval(String qty) {
    return 'অনুমোদন দরকার: $qty বেশি';
  }

  @override
  String extraNeedApprovalBody(String farmer, String crop) {
    return '$farmer · $crop। বাড়তি পণ্য নিতে চাইলে বাড়তি টাকা দিন, তারপর লোড নিশ্চিত হবে।';
  }

  @override
  String get rowScaleWeighed => 'স্কেলে মাপা হয়েছে';

  @override
  String get rowMore => 'বেশি';

  @override
  String rowExtraPriceAt(String price) {
    return 'বাড়তি দাম (৳ $price/কেজি)';
  }

  @override
  String rowFeePct(String pct) {
    return 'ফি ($pct%)';
  }

  @override
  String get rowTotalToPay => 'মোট দিতে হবে';

  @override
  String extraNote(String n) {
    return '$n মিনিটের মধ্যে উত্তর না দিলে শুধু অর্ডারের পরিমাণ লোড হবে। অনুমোদনের পর লোড হলে এই টাকা কৃষক পেয়ে যাবেন, তখন আর ফেরত হবে না।';
  }

  @override
  String approveAndPay(String amount) {
    return 'অনুমোদন ও $amount দিন';
  }

  @override
  String keepOrdered(String qty) {
    return 'না, $qty-ই থাক';
  }

  @override
  String get extraApproved => 'বাড়তি ওজন অনুমোদন করা হয়েছে';

  @override
  String get extraDeclined => 'শুধু অর্ডারের পরিমাণ লোড হবে';

  @override
  String extraExpiredNote(String qty) {
    return 'সময় পেরিয়ে গেছে — শুধু $qty লোড হবে';
  }

  @override
  String get refundTitle => 'রিফান্ড';

  @override
  String refundSubCancel(String crop, String qty) {
    return '$crop – $qty · অর্ডার বাতিল হয়েছে (ট্রাক রওনার আগে)';
  }

  @override
  String refundSubWeight(String crop, String qty) {
    return '$crop · ওজনে $qty কম ধরা পড়েছে';
  }

  @override
  String get rowCropValue => 'ফসলের মূল্য';

  @override
  String get rowTransportCut => 'পরিবহন (১০% কেটে)';

  @override
  String rowPlatformFeePct(String pct) {
    return 'প্ল্যাটফর্ম ফি ($pct%)';
  }

  @override
  String get refundStepCancelled => 'অর্ডার বাতিল হয়েছে';

  @override
  String get refundStepWeighed => 'ওজন কম ধরা পড়েছে';

  @override
  String get refundStepProcessing => 'টাকা ফেরতের প্রক্রিয়া চলছে';

  @override
  String get refundWithin3Days => '৩ কর্মদিবসের মধ্যে';

  @override
  String get refundStepArrived => 'টাকা ফেরত এসেছে';

  @override
  String get rowRefundTo => 'কোথায় ফেরত যাবে';

  @override
  String get refundSameMethod => 'যে মাধ্যমে দিয়েছিলেন';

  @override
  String get refundNote =>
      'গোলাঘর থেকে, যে মাধ্যমে টাকা দিয়েছিলেন সেই মাধ্যমেই ফেরত যাবে।';

  @override
  String get getHelp => 'সাহায্য নিন';

  @override
  String get rowWeightDiff => 'ওজনের পার্থক্য';

  @override
  String get rowRefundLink => 'রিফান্ড';

  @override
  String get answerExtraBtn => 'বাড়তি ওজন: উত্তর দিন';

  @override
  String get startWeighing => 'লোড ও ওজন শুরু করুন';

  @override
  String nTruckBooked(String no) {
    return 'ট্রাক বুক হয়েছে: $no';
  }

  @override
  String nTruckBookedBody(String name) {
    return '$name আসছেন — আপনার OTP দেখুন';
  }

  @override
  String nExtraRequest(String no) {
    return 'বাড়তি ওজন: $no';
  }

  @override
  String nExtraRequestBody(String qty) {
    return 'স্কেলে $qty বেশি — অনুমোদন দেবেন?';
  }

  @override
  String nExtraApproved(String no) {
    return 'বাড়তি ওজন অনুমোদিত: $no';
  }

  @override
  String nExtraDeclined(String no) {
    return 'শুধু অর্ডারের পরিমাণ লোড করুন: $no';
  }

  @override
  String nWeightLess(String no) {
    return 'ওজন কম, টাকা ফেরত পাবেন: $no';
  }

  @override
  String nLoadedPaid(String no) {
    return 'পণ্য লোড হয়েছে, টাকা পাঠানো হয়েছে: $no';
  }

  @override
  String get traceTitle => 'উৎস রেকর্ড';

  @override
  String traceOrderTitle(String no, String crop, String qty) {
    return '$no · $crop $qty';
  }

  @override
  String traceFarmers(String n) {
    return '$n জন কৃষক';
  }

  @override
  String traceDelivered(String date) {
    return 'ডেলিভারি $date';
  }

  @override
  String get qrLabel => 'QR';

  @override
  String traceFarmer(String name, String district) {
    return 'কৃষক: $name · $district';
  }

  @override
  String traceReady(String date, String grade) {
    return 'ফসল প্রস্তুত $date · গ্রেড $grade';
  }

  @override
  String get traceLoadWeigh => 'লোড ও ডিজিটাল ওজন';

  @override
  String traceTransport(String name) {
    return 'পরিবহন: $name';
  }

  @override
  String get traceSelfTransport => 'পরিবহন: ক্রেতার নিজের গাড়ি';

  @override
  String traceDelivery(String place) {
    return 'ডেলিভারি: $place';
  }

  @override
  String traceOtpVerified(String time) {
    return '$time · OTP যাচাই';
  }

  @override
  String traceReceived(String time) {
    return '$time · ক্রেতা গ্রহণ করেছেন';
  }

  @override
  String get traceHeader => 'গোলাঘর উৎস রেকর্ড';

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
    return 'কৃষক: $name, $district · $qty · $grade';
  }

  @override
  String get pdfShort => 'PDF';

  @override
  String get qrShare => 'QR শেয়ার';

  @override
  String get oppTitle => 'বাজারের সুযোগ';

  @override
  String get oppFilterDemand => 'বেশি চাহিদা';

  @override
  String get oppFilterPrice => 'দাম বাড়ছে';

  @override
  String get oppFilterBuyer => 'ক্রেতা খুঁজছে';

  @override
  String oppHighDemand(String crop) {
    return 'বেশি চাহিদা · $crop';
  }

  @override
  String oppHighDemandSub(String district, String n) {
    return '$district · $n জন ক্রেতা খুঁজছেন';
  }

  @override
  String oppPriceUp(String crop) {
    return 'দাম বাড়ছে · $crop';
  }

  @override
  String oppPriceUpSub(String pct, String price) {
    return 'আগের দামের চেয়ে $pct · $price/কেজি';
  }

  @override
  String get oppSell => 'বিক্রি';

  @override
  String oppBuyerSeeking(String crop, String qty) {
    return 'ক্রেতা খুঁজছেন · $crop $qty';
  }

  @override
  String get oppSupply => 'সরবরাহ';

  @override
  String oppUpcoming(String crop, String qty) {
    return 'আগামী চাহিদা · $crop $qty';
  }

  @override
  String oppUpcomingSub(String buyer, String month) {
    return '$buyer · $month-এ দরকার';
  }

  @override
  String get oppPlan => 'পরিকল্পনা';

  @override
  String get oppEmpty => 'এখন কোনো সুযোগ নেই — পরে আবার দেখুন';

  @override
  String get planTitle => 'চাষের পরিকল্পনা';

  @override
  String get planIntro => 'বীজ বোনার আগে দেখুন কোন ফসলের নিশ্চিত চাহিদা আছে';

  @override
  String get seasonRabi => 'রবি (নভে–ফেব্রু)';

  @override
  String get seasonKharif1 => 'খরিফ-১';

  @override
  String get seasonKharif2 => 'খরিফ-২';

  @override
  String planCropLine(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String planBuyersMore(String name, String n) {
    return '$name +$n';
  }

  @override
  String get planHighDemand => 'চাহিদা বেশি';

  @override
  String priceRangeTk(String min, String max) {
    return '৳ $min–$max';
  }

  @override
  String get planEmpty => 'এই মৌসুমে এখনো কোনো চাহিদা নেই';

  @override
  String get planWhenPaid => 'টাকা কখন পাবেন';

  @override
  String get planWhenPaidBody =>
      'হারভেস্টের পর পণ্য গাড়িতে উঠলেই। কোনো অগ্রিম টাকা নেই।';

  @override
  String get planCta => 'চুক্তি দেখুন ও অংশ নিন';

  @override
  String get rescueTitle => 'বিকল্প ক্রেতা';

  @override
  String get rescueCancelled => 'অর্ডার বাতিল (লোডের আগে)';

  @override
  String rescueCancelledBody(String buyer, String qty, String crop, String no) {
    return '$buyer $qty $crop-এর অর্ডার ($no) বাতিল করেছে। আপনার কোনো টাকা কাটা হবে না।';
  }

  @override
  String rescueFinding(String crop) {
    return '$crop-এর জন্য কাছের ক্রেতা খুঁজে দিচ্ছি';
  }

  @override
  String get rescueNone => 'এখন এই ফসলের কোনো খোলা চাহিদা নেই';

  @override
  String kmShort(String n) {
    return '$n কিমি';
  }

  @override
  String rescueOldPrice(String price) {
    return 'আগের দাম ৳$price/কেজি';
  }

  @override
  String rescueOldAndMarket(String price, String min, String max) {
    return 'আগের দাম ৳$price/কেজি · বাজার দর ৳$min–$max';
  }

  @override
  String get rescueTakeBest => 'সেরা অফার গ্রহণ করুন';

  @override
  String get rescueRelist => 'নিজের দামে আবার প্রকাশ করুন';

  @override
  String get rowTrace => 'উৎস রেকর্ড';

  @override
  String get rowRescue => 'বিকল্প ক্রেতা';

  @override
  String get seeLinkShort => 'দেখুন';

  @override
  String get bannerOppTitle => 'বাজারের সুযোগ';

  @override
  String get bannerOppSub => 'বেশি চাহিদা ও দাম বাড়ছে এমন ফসল';

  @override
  String get bannerPlanTitle => 'চাষের পরিকল্পনা';

  @override
  String get bannerPlanSub => 'বোনার আগে নিশ্চিত চাহিদা দেখুন';

  @override
  String get assignInspTitle => 'পরিদর্শক পাঠান';

  @override
  String get assignInspBody =>
      'আপনার লোক লোডের সময় মান ও ওজন যাচাই করবেন। তিনি এই নম্বর দিয়ে গোলাঘর অ্যাপে লগইন করবেন।';

  @override
  String get fieldInspName => 'পরিদর্শকের নাম';

  @override
  String get fieldInspPhone => 'পরিদর্শকের মোবাইল নম্বর';

  @override
  String get sendInvite => 'আমন্ত্রণ পাঠান';

  @override
  String get errNameRequired => 'নাম লিখুন';

  @override
  String get errInspNotSelf => 'নিজের নম্বর দেওয়া যাবে না';

  @override
  String inspInviteText(String name, String no, String crop, String phone) {
    return '$name, গোলাঘর অ্যাপে আপনাকে পরিদর্শক করা হয়েছে ($no · $crop)। অ্যাপ খুলে এই নম্বর দিয়ে লগইন করুন: $phone';
  }

  @override
  String get inspHomeTitle => 'পরিদর্শকের কাজ';

  @override
  String inspInvitedBy(String buyer) {
    return '$buyer আপনাকে পরিদর্শক করেছেন';
  }

  @override
  String inspOrderLine(String no, String crop, String qty, String date) {
    return '$no · $crop $qty · $date';
  }

  @override
  String inspTruckBooked(String name) {
    return 'ট্রাক বুক হয়েছে · $name';
  }

  @override
  String inspTruckBookedBody(String place) {
    return '$place · ট্রাক পৌঁছালে মান যাচাই শুরু করুন';
  }

  @override
  String inspPickups(String n) {
    return 'পিকআপ ($n)';
  }

  @override
  String get inspNone => 'এখনো কোনো পরিদর্শনের কাজ নেই';

  @override
  String numberedName(String n, String name) {
    return '$n. $name';
  }

  @override
  String get inspStart => 'শুরু';

  @override
  String get inspClosed => 'শেষ';

  @override
  String get inspChalan => 'চালানের তথ্য';

  @override
  String get inspGrade => 'মান';

  @override
  String inspGradeValue(String grade) {
    return 'গ্রেড $grade (চুক্তি অনুযায়ী)';
  }

  @override
  String get inspTruck => 'ট্রাক';

  @override
  String get callDriver => 'ড্রাইভারকে কল';

  @override
  String get seeRouteMap => 'ম্যাপে পথ দেখুন';

  @override
  String qcTitle(String name) {
    return 'মান যাচাই · $name';
  }

  @override
  String partialTitle(String name) {
    return 'আংশিক লোড · $name';
  }

  @override
  String cancelLoadTitle(String name) {
    return 'লোড বাতিল · $name';
  }

  @override
  String gradeChecklist(String grade) {
    return 'গ্রেড $grade চেকলিস্ট';
  }

  @override
  String get chkSize => 'ন্যূনতম আকার ঠিক আছে';

  @override
  String get chkNoSprout => 'সবুজ বা অঙ্কুর নেই';

  @override
  String get chkFirm => 'শক্ত, নরম বা পচা নয়';

  @override
  String chkDamage(String pct) {
    return 'সর্বোচ্চ $pct% ক্ষতিগ্রস্ত';
  }

  @override
  String get chkPacking => 'প্যাকেজিং ঠিক আছে';

  @override
  String get chkOk => 'ঠিক';

  @override
  String get chkProblem => 'সমস্যা';

  @override
  String get rowDigitalWeight => 'ডিজিটাল ওজন';

  @override
  String goodsPhotos(String n, String max) {
    return 'পণ্যের ছবি তুলুন ($n/$max)';
  }

  @override
  String rejectPhotos(String n, String max) {
    return 'বাদ দেওয়া পণ্যের ছবি তুলুন ($n/$max)';
  }

  @override
  String get decApprove => 'অনুমোদন';

  @override
  String get decApproved => 'অনুমোদিত';

  @override
  String get decPartial => 'আংশিক';

  @override
  String get decPartialTake => 'আংশিক (কম নিন)';

  @override
  String get decCancel => 'বাতিল';

  @override
  String get qcNote =>
      'অনুমোদনের পর কৃষক OTP দিলে টাকা ছাড় হবে। এই রিপোর্ট চূড়ান্ত।';

  @override
  String get submitReport => 'রিপোর্ট জমা দিন';

  @override
  String get howMuchTake => 'কতটুকু পণ্য নেবেন?';

  @override
  String get rowLeftOut => 'বাদ যাবে';

  @override
  String get howMuchGood => 'ভালো পণ্য কত কেজি নেবেন?';

  @override
  String scaleWeight(String qty) {
    return '$qty (স্কেল থেকে)';
  }

  @override
  String get reasonSmall => 'আকার ছোট';

  @override
  String get reasonDamaged => 'নষ্ট পণ্য';

  @override
  String get reasonLowGrade => 'গ্রেড কম';

  @override
  String partialNote(String qty) {
    return 'শুধু $qty লোড হবে। কৃষক OTP দিলে এর টাকা ছাড় হবে। বাকি ফসলের দাম ও ফি ক্রেতা ফেরত পাবেন। ট্রাক ভাড়া একই থাকবে।';
  }

  @override
  String errAcceptKg(String qty) {
    return '০ থেকে $qty-এর কম লিখুন';
  }

  @override
  String get whyCancel => 'কেন বাতিল করছেন?';

  @override
  String get rowWillLoad => 'লোড হবে';

  @override
  String get cancelLoadNote =>
      'পণ্য লোড হবে না, কৃষক টাকা পাবেন না। ক্রেতা ফসলের দাম ও ফি ফেরত পাবেন। ট্রাক ভাড়া ক্রেতা দেবেন।';

  @override
  String get cancelLoadBtn => 'লোড বাতিল করুন';

  @override
  String get cancelLoadQ => 'লোড বাতিল করবেন?';

  @override
  String get cancelLoadBody =>
      'অর্ডারটি বাতিল হবে। এই রিপোর্ট আর বদলানো যাবে না।';

  @override
  String get reportSentTitle => 'রিপোর্ট জমা হয়েছে';

  @override
  String get reportReachedBuyer => 'রিপোর্ট ক্রেতার কাছে পৌঁছেছে';

  @override
  String get rowStop => 'স্টপ';

  @override
  String stopLine(String i, String n, String name) {
    return '$i/$n · $name';
  }

  @override
  String get rowDecision => 'সিদ্ধান্ত';

  @override
  String decApproveLine(String ok, String n) {
    return 'অনুমোদন · $ok/$n ঠিক';
  }

  @override
  String decPartialLine(String qty) {
    return 'আংশিক · $qty নেওয়া';
  }

  @override
  String decCancelLine(String reason) {
    return 'বাতিল · $reason';
  }

  @override
  String get rowWeight => 'ওজন';

  @override
  String weightLeftOut(String w, String left) {
    return '$w ($left বাদ)';
  }

  @override
  String weightNoneTaken(String w) {
    return '$w (কিছুই নেওয়া হয়নি)';
  }

  @override
  String get rowTime => 'সময়';

  @override
  String get whatNext => 'এরপর কী হবে';

  @override
  String get nextApprove =>
      'ড্রাইভার কৃষকের OTP নিলে পণ্য গাড়িতে উঠবে। এই রিপোর্ট আর বদলানো যাবে না।';

  @override
  String nextPartial(String qty) {
    return 'ড্রাইভার শুধু $qty তুলবেন। এই রিপোর্ট আর বদলানো যাবে না।';
  }

  @override
  String get nextCancel =>
      'এই স্টপে কোনো পণ্য উঠবে না। এই রিপোর্ট আর বদলানো যাবে না।';

  @override
  String get nextPickups => 'পরের পিকআপ দেখুন';

  @override
  String get inspReportTitle => 'পরিদর্শন রিপোর্ট';

  @override
  String get loadRecordTitle => 'লোডের রেকর্ড';

  @override
  String get loadDoneBadge => 'লোড হয়েছে';

  @override
  String get rowInspector => 'পরিদর্শক';

  @override
  String inspYours(String name) {
    return '$name (আপনার)';
  }

  @override
  String get inspNotSent => 'পাঠাননি';

  @override
  String get rowTimePlace => 'সময় ও স্থান';

  @override
  String get rowWeighedBy => 'ওজন নিয়েছেন';

  @override
  String weighedByDriver(String name) {
    return 'ড্রাইভার $name';
  }

  @override
  String get weighedBySelf => 'আপনি (নিজের গাড়ি)';

  @override
  String get rowReceivedFarmer => 'কৃষক পেয়েছেন';

  @override
  String get rowChecklist => 'চেকলিস্ট';

  @override
  String okOutOf(String ok, String n) {
    return '$ok/$n ঠিক';
  }

  @override
  String get rowTaken => 'নেওয়া হয়েছে';

  @override
  String leftOutWhy(String qty, String reason) {
    return '$qty ($reason)';
  }

  @override
  String get rowCropValueBack => 'ফসলের দাম ফেরত';

  @override
  String reasonNotMet(String reason) {
    return 'মান মেলেনি ($reason)';
  }

  @override
  String get yourResponsibility => 'মান ও পরিমাণের দায় আপনার';

  @override
  String get yourResponsibilityBody =>
      'আপনি পরিদর্শক পাঠাননি। ড্রাইভার শুধু ওজন ও ছবি নিয়েছেন। লোডের পর মান নিয়ে অভিযোগ করা যাবে না।';

  @override
  String get yourResponsibilitySelf =>
      'আপনি নিজে ওজন ও ছবি নিয়ে লোড নিশ্চিত করেছেন। লোডের পর মান বা ওজন নিয়ে অভিযোগ করা যাবে না।';

  @override
  String get reportIsProof => 'এই রিপোর্টই প্রমাণ';

  @override
  String get reportIsProofBody =>
      'লোডের সময় আপনার পরিদর্শক মান অনুমোদন করেছেন। পরে আপত্তি হলে এই রিপোর্ট দেখা হবে; কৃষকের টাকা আটকানো যাবে না।';

  @override
  String get fareSame => 'ট্রাক ভাড়া একই থাকবে';

  @override
  String fareSameBody(String fare) {
    return 'ট্রাক আপনি বুক করেছেন, তাই ভাড়া $fare আপনি দেবেন। ফেরতের টাকা ৩ কর্মদিবসের মধ্যে একই মাধ্যমে যাবে।';
  }

  @override
  String get farePayYou => 'ট্রাক ভাড়া আপনি দেবেন';

  @override
  String farePayYouBody(String fare) {
    return 'ট্রাক আপনি বুক করেছেন, তাই ভাড়া $fare ফেরত হবে না।';
  }

  @override
  String get rowInspectorAssign => 'পরিদর্শক';

  @override
  String get inspSend => 'পাঠান';

  @override
  String get rowInspReport => 'পরিদর্শন রিপোর্ট';

  @override
  String get rowLoadRecord => 'লোডের রেকর্ড';

  @override
  String inspPresent(String name) {
    return '$name (ক্রেতার)';
  }

  @override
  String get rowInspDecision => 'পরিদর্শকের সিদ্ধান্ত';

  @override
  String get inspWaitNote =>
      'পরিদর্শকের সিদ্ধান্তের অপেক্ষা — রিপোর্টের পর লোড করুন';

  @override
  String inspPartialNote(String qty) {
    return 'পরিদর্শক শুধু $qty নিতে বলেছেন';
  }

  @override
  String get rowInspectorWork => 'পরিদর্শকের কাজ';

  @override
  String nInspectionDone(String no) {
    return 'পরিদর্শন রিপোর্ট: $no';
  }

  @override
  String get rowInspReason => 'কারণ';

  @override
  String get errInspPhoto => 'অন্তত একটি ছবি তুলুন';

  @override
  String get rowLeftOutPast => 'বাদ গেছে';

  @override
  String get rowLeftKm => 'বাকি দূরত্ব';

  @override
  String get rowTruckSeen => 'ট্রাকের অবস্থান';

  @override
  String liveMinAgo(String n) {
    return '$n মিনিট আগে';
  }

  @override
  String get liveJustNow => 'এইমাত্র';

  @override
  String get liveOff => 'চালকের অ্যাপ খোলা থাকলে দেখাবে';

  @override
  String get voiceMessage => 'ভয়েস বার্তা';

  @override
  String voiceMessageLen(String len) {
    return 'ভয়েস বার্তা · $len';
  }

  @override
  String voiceRecording(String len) {
    return 'ভয়েস রেকর্ড হচ্ছে... $len';
  }

  @override
  String get voiceSend => 'পাঠান';

  @override
  String get voiceSendSub => 'রেকর্ড করা বার্তা পাঠান';

  @override
  String get voiceCancel => 'বাতিল';

  @override
  String get voiceCancelSub => 'রেকর্ড মুছে ফেলুন';

  @override
  String get micDenied => 'মাইক্রোফোনের অনুমতি দিন (সেটিংস → অ্যাপ → গোলাঘর)';

  @override
  String get voiceSearchListening => 'শুনছি... ফসল বা এলাকার নাম বলুন';

  @override
  String get voiceSearchStop => 'থামান';

  @override
  String get voiceSearchStopSub => 'বলা শেষ হলে চাপুন';

  @override
  String get voiceSearchExample => 'উদাহরণ';

  @override
  String get voiceSearchExampleSub => '“টমেটো”, “আলু নেত্রকোনা”';

  @override
  String get voiceSearchUnavailable => 'এই ফোনে ভয়েস সার্চ চালু নেই';

  @override
  String get pdfMaking => 'PDF তৈরি হচ্ছে...';

  @override
  String get locAskTitle => 'ট্রাকের অবস্থান জানাতে অনুমতি দিন';

  @override
  String get locAskBody =>
      'ট্রিপ চলার সময় ক্রেতা ও কৃষক ম্যাপে আপনার ট্রাক দেখতে পাবেন। পরের বক্সে “While using the app” চাপুন।';

  @override
  String get locAskLater => 'পরে';

  @override
  String get locAskAllow => 'অনুমতি দিন';

  @override
  String get stdTitle => 'মান নির্ধারণ';

  @override
  String stdHeading(String crop, String grade) {
    return '$crop · গ্রেড $grade';
  }

  @override
  String get stdRowSize => 'ন্যূনতম আকার';

  @override
  String get stdRowColor => 'রং';

  @override
  String get stdRowRipe => 'পাকা';

  @override
  String get stdRowDamage => 'সর্বোচ্চ ক্ষতিগ্রস্ত';

  @override
  String get stdRowPack => 'প্যাকেজিং';

  @override
  String get stdWhenTitle => 'কখন যাচাই হবে';

  @override
  String get stdWhenBody =>
      'শুধু লোডের সময় (আপনার পরিদর্শকের চেকলিস্ট)। ডেলিভারির পর এই মান দিয়ে টাকা ফেরত চাওয়া যাবে না।';

  @override
  String get stdUse => 'এই মান ব্যবহার করুন';

  @override
  String stdCheckLine(String label, String value) {
    return '$label: $value';
  }

  @override
  String stdSizeAcross(String n) {
    return '$n সেমি ব্যাস';
  }

  @override
  String stdSizeLength(String n) {
    return '$n সেমি লম্বা';
  }

  @override
  String stdSizeGrams(String n) {
    return 'প্রতিটি $n গ্রাম';
  }

  @override
  String stdSizeGrain(String n) {
    return 'পুষ্ট দানা, চিটা ≤$n%';
  }

  @override
  String get stdSizeEven => 'সমান আকার';

  @override
  String stdDamagePct(String n) {
    return '$n%';
  }

  @override
  String stdColorRed(String n) {
    return '$n% লাল';
  }

  @override
  String get stdColorPotato => 'হালকা বাদামি, সবুজ দাগ নেই';

  @override
  String get stdColorPaddy => 'সোনালি';

  @override
  String get stdColorEggplant => 'উজ্জ্বল বেগুনি, চকচকে';

  @override
  String get stdColorOnion => 'লালচে, শুকনো খোসা';

  @override
  String get stdColorChili => 'উজ্জ্বল সবুজ';

  @override
  String get stdColorMango => 'পরিপক্ব সবুজ থেকে হলুদ';

  @override
  String get stdColorNatural => 'স্বাভাবিক রং';

  @override
  String get stdRipeTomato => 'আধা-পাকা থেকে পাকা';

  @override
  String get stdRipePotato => 'পরিপক্ব, খোসা শক্ত';

  @override
  String stdRipePaddy(String n) {
    return 'পুরো পাকা, আর্দ্রতা ≤$n%';
  }

  @override
  String get stdRipeEggplant => 'কচি, বীজ নরম';

  @override
  String get stdRipeOnion => 'পুরো শুকানো, অঙ্কুর নেই';

  @override
  String get stdRipeChili => 'তাজা ও শক্ত';

  @override
  String get stdRipeMango => 'পরিপক্ব, শক্ত';

  @override
  String get stdRipeMarket => 'বাজারজাত উপযোগী';

  @override
  String stdPackCrate(String n) {
    return '$n কেজির ক্রেট';
  }

  @override
  String stdPackSack(String n) {
    return '$n কেজির বস্তা';
  }

  @override
  String stdPackNet(String n) {
    return '$n কেজির জালি বস্তা';
  }

  @override
  String stdPackBag(String n) {
    return '$n কেজির ব্যাগ';
  }

  @override
  String get stdPackClean => 'পরিষ্কার বস্তা বা ক্রেট';

  @override
  String get tpProfileTitle => 'ট্রান্সপোর্টারের প্রোফাইল';

  @override
  String get tpVerifiedDriver => 'যাচাইকৃত চালক';

  @override
  String get tpDriver => 'চালক';

  @override
  String tpSince(String date) {
    return '$date থেকে গোলাঘরে';
  }

  @override
  String get tpTrips => 'সম্পন্ন ট্রিপ';

  @override
  String get tpOnTime => 'সময়মতো';

  @override
  String get tpCancelRate => 'বাতিলের হার';

  @override
  String get tpDamage => 'ক্ষতির অভিযোগ';

  @override
  String tpTruckLine(String type, String cap, String status) {
    return '$type · $cap · $status';
  }

  @override
  String get tpFitness => 'ফিটনেস ও লাইসেন্স';

  @override
  String get tpValid => 'বৈধ';

  @override
  String get tpMainRoute => 'প্রধান রুট';

  @override
  String tpRoute(String from, String to) {
    return '$from – $to';
  }

  @override
  String get tpChoose => 'এই ট্রান্সপোর্টার বাছুন';

  @override
  String pctText(String n) {
    return '$n%';
  }

  @override
  String get supTitle => 'সরবরাহকারী';

  @override
  String get supSearchHint => 'কৃষক বা এলাকা খুঁজুন';

  @override
  String get supAll => 'সব';

  @override
  String get supFav => 'পছন্দের';

  @override
  String get supNew => 'নতুন';

  @override
  String get supFavTag => 'পছন্দের';

  @override
  String supLine(String district, String rating, String n) {
    return '$district · $rating · $n লেনদেন';
  }

  @override
  String get supEmpty => 'এখনো কোনো সরবরাহকারী নেই — বাজার থেকে অর্ডার করুন';

  @override
  String get supProfileTitle => 'সরবরাহকারীর প্রোফাইল';

  @override
  String supStatusLine(String status, String district) {
    return '$status · $district';
  }

  @override
  String get supQuality => 'মানের স্কোর';

  @override
  String get supTotal => 'মোট সরবরাহ';

  @override
  String supPerf(String n) {
    return 'পারফরম্যান্স ($n মাস)';
  }

  @override
  String get supCommitted => 'প্রতিশ্রুত বনাম সরবরাহকৃত';

  @override
  String get supAcceptance => 'মান গ্রহণযোগ্যতা';

  @override
  String get supAddFav => 'পছন্দের তালিকায়';

  @override
  String get supRemoveFav => 'পছন্দ থেকে সরান';

  @override
  String get toastFavAdded => 'পছন্দের তালিকায় যোগ হয়েছে';

  @override
  String get toastFavRemoved => 'পছন্দের তালিকা থেকে সরানো হয়েছে';

  @override
  String get toastUndo => 'বাতিল';

  @override
  String get procTitle => 'সংগ্রহ ড্যাশবোর্ড';

  @override
  String get procOpenDemands => 'চলমান চাহিদা';

  @override
  String get procCommitted => 'মোট প্রতিশ্রুত';

  @override
  String get procFarmers => 'কৃষক যুক্ত';

  @override
  String get procSafePay => 'নিরাপদ লেনদেন';

  @override
  String procPeople(String n) {
    return '$n জন';
  }

  @override
  String get procOngoing => 'চলমান সংগ্রহ';

  @override
  String procLine(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String get procNone => 'কোনো চলমান চাহিদা নেই';

  @override
  String get procAnalytics => 'ক্রয় বিশ্লেষণ';

  @override
  String get procAnalyticsSub =>
      'খরচ, দামের প্রবণতা ও সরবরাহকারীর পারফরম্যান্স';

  @override
  String get anMonth => 'এ মাস';

  @override
  String get an3Months => '৩ মাস';

  @override
  String get anYear => 'এ বছর';

  @override
  String get anSpend => 'মোট খরচ';

  @override
  String anAvgPrice(String crop) {
    return 'গড় দাম ($crop)';
  }

  @override
  String get anSuppliers => 'সরবরাহকারীর পারফরম্যান্স';

  @override
  String get anDeliveredLeft => 'ডেলিভারি / বাকি';

  @override
  String get anWithInspector => 'পরিদর্শকসহ অর্ডার';

  @override
  String anSlash(String a, String b) {
    return '$a / $b';
  }

  @override
  String get anNoData => 'এই সময়ে কোনো অর্ডার নেই';

  @override
  String takaLakh(String n) {
    return '৳ $n লাখ';
  }

  @override
  String get retTitle => 'ফিরতি লোড';

  @override
  String get retMyRoute => 'আমার ফিরতি রুট';

  @override
  String retRouteSub(String from, String to, String date, String space) {
    return '$from → $to · $date · $space খালি';
  }

  @override
  String get retChange => 'বদলান';

  @override
  String get retSetRoute => 'ফিরতি রুট সেট করুন';

  @override
  String get retNoRouteSub => 'কোথায় ফিরবেন বলুন, আপনার রুটের লোড দেখাব';

  @override
  String retForYou(String from, String to) {
    return '$from → $to রুটে আপনার জন্য লোড';
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
  String get retAccept => 'ফিরতি লোড গ্রহণ করুন';

  @override
  String get retFrom => 'কোথা থেকে';

  @override
  String retFromHere(String place) {
    return '$place (বর্তমান অবস্থান)';
  }

  @override
  String get retTo => 'কোথায় ফিরবেন';

  @override
  String get retWhen => 'কবে ফিরবেন';

  @override
  String get retToday => 'আজ';

  @override
  String get retTomorrow => 'কাল';

  @override
  String get retSpace => 'ট্রাকে খালি জায়গা';

  @override
  String get retSave => 'সংরক্ষণ করুন ও লোড খুঁজুন';

  @override
  String get retNoneTitle => 'এখনো মিলছে এমন লোড নেই';

  @override
  String retNoneSub(String from, String to) {
    return '$from → $to রুটে এই মুহূর্তে উপযুক্ত লোড নেই।';
  }

  @override
  String get retPaidTitle => 'আগের ভাড়া আপনি পেয়ে গেছেন';

  @override
  String retPaidBody(String no, String fare) {
    return '$no · $fare পাঠানো হয়েছে।';
  }

  @override
  String get retOtherDest => 'অন্য গন্তব্য বাছুন';

  @override
  String get retOther => 'অন্যান্য';

  @override
  String get retAlertOn => 'লোড পেলে সাথে সাথে জানাব (এলার্ট চালু)';

  @override
  String get retSearchAgain => 'আবার খুঁজুন';

  @override
  String get retGoHome => 'হোমে যান';

  @override
  String get retDoneBar => 'লোড নিশ্চিত';

  @override
  String get retDoneTitle => 'ফিরতি লোড নিশ্চিত হয়েছে';

  @override
  String retPickupLine(String date, String km) {
    return '$date · $km কিমি দূরে';
  }

  @override
  String get retPaySafeTitle => 'পেমেন্ট নিরাপদ';

  @override
  String get retPaySafeBody =>
      'ভাড়া নিরাপদ লেনদেনে জমা আছে। ক্রেতার কাছে পৌঁছালেই পাবেন।';

  @override
  String get retNavigate => 'নেভিগেশন শুরু করুন';

  @override
  String get retCallBuyer => 'ক্রেতাকে কল করুন';

  @override
  String get retBidSent =>
      'ভাড়ার প্রস্তাব পাঠানো হয়েছে — ক্রেতা বুক করলে জানাব';

  @override
  String nReturnLoad(String from, String to) {
    return 'ফিরতি লোড পাওয়া গেছে: $from → $to';
  }

  @override
  String get matchTitle => 'কৃষক মিলান';

  @override
  String matchHeader(String crop, String qty, String place) {
    return '$crop – $qty · $place';
  }

  @override
  String get matchOk => 'মিলেছে';

  @override
  String get matchWait => 'অপেক্ষা';

  @override
  String matchSub(String district, String qty) {
    return '$district · $qty';
  }

  @override
  String get matchNone => 'এখনো কোনো কৃষক সরবরাহের প্রস্তাব দেননি';

  @override
  String get addToPool => 'পুলে যোগ করুন';

  @override
  String get poolTitle => 'ডিজিটাল পুলিং';

  @override
  String poolTarget(String crop) {
    return '$crop – মোট লক্ষ্য';
  }

  @override
  String poolFarmers(String n) {
    return 'পুলে কৃষক ($n)';
  }

  @override
  String poolFarmerSub(String qty, String date) {
    return '$qty · পিকআপ $date';
  }

  @override
  String get rowLeft => 'বাকি';

  @override
  String get rowAvgPrice => 'গড় দাম';

  @override
  String get poCreate => 'ক্রয়াদেশ তৈরি করুন';

  @override
  String get poTitle => 'ক্রয়াদেশ (PO)';

  @override
  String get rowPoNo => 'PO নং';

  @override
  String get rowTotalQty => 'মোট পরিমাণ';

  @override
  String rowFarmersN(String n) {
    return '$n জন কৃষক';
  }

  @override
  String get rowTotalValue => 'মোট মূল্য';

  @override
  String get poSplit => 'কৃষক অনুযায়ী ভাগ';

  @override
  String get poConfirm => 'PO নিশ্চিত করুন';

  @override
  String poDone(String no, String n) {
    return '$no নিশ্চিত — $nটি অর্ডার তৈরি হয়েছে';
  }

  @override
  String get attachTitle => 'ফাইল পাঠান';

  @override
  String get attachPhoto => 'ছবি';

  @override
  String get attachPhotoSub => 'গ্যালারি বা ক্যামেরা থেকে';

  @override
  String get attachVideo => 'ভিডিও';

  @override
  String get attachVideoSub => 'ফসল বা পণ্যের ভিডিও';

  @override
  String get attachDoc => 'ডকুমেন্ট';

  @override
  String get attachDocSub => 'রসিদ, চুক্তি বা PDF';

  @override
  String get fileSending => 'পাঠানো হচ্ছে…';

  @override
  String fileTooLarge(String mb) {
    return 'ফাইলটি অনেক বড় (সর্বোচ্চ $mb MB)';
  }

  @override
  String get videoTapToWatch => 'চাপ দিয়ে ভিডিও দেখুন';

  @override
  String get fileOpenFailed => 'ফাইলটি খোলা যায়নি';

  @override
  String get rowUploaded => 'আপলোড';

  @override
  String get rowExpiry => 'মেয়াদ শেষ';

  @override
  String get docVerified => '✓ যাচাইকৃত';

  @override
  String get docPending => 'যাচাই চলছে';

  @override
  String get docRejected => 'বাতিল — নতুন করে আপলোড করুন';

  @override
  String get docExpired => 'মেয়াদ শেষ হয়ে গেছে';

  @override
  String get docPdf => 'PDF ডাউনলোড';

  @override
  String get docReupload => 'নতুন করে আপলোড';

  @override
  String get docUpload => 'আপলোড করুন';

  @override
  String get docNoneTitle => 'এখনো আপলোড করা হয়নি';

  @override
  String get docNoneBody =>
      'কাগজের পরিষ্কার ছবি তুলে আপলোড করুন। মডারেটর যাচাই করবেন।';

  @override
  String get docExpiryPick => 'কাগজের মেয়াদ শেষের তারিখ বাছুন';

  @override
  String get docSent => 'আপলোড হয়েছে — মডারেটর যাচাই করবেন';

  @override
  String nDocOk(String doc) {
    return '$doc যাচাই হয়েছে';
  }

  @override
  String get nDocOkBody => 'রপ্তানির জন্য আপনার কাগজ এখন প্রস্তুত';

  @override
  String nDocRejected(String doc) {
    return '$doc বাতিল হয়েছে';
  }

  @override
  String get nDocRejectedBody => 'পরিষ্কার ছবি দিয়ে নতুন করে আপলোড করুন';

  @override
  String get sharedTitle => 'খালি জায়গায় লোড';

  @override
  String get sharedNoTripTitle => 'এখন কোনো চলমান ট্রিপ নেই';

  @override
  String get sharedNoTripBody =>
      'কাজ নিলে ট্রাকের খালি জায়গায় রুটের লোড এখানে দেখাবে।';

  @override
  String sharedTruckSub(String cap, String now, String no) {
    return '$cap ট্রাক · বর্তমান $now ($no)';
  }

  @override
  String get truckFull => 'ট্রাক ভর্তি';

  @override
  String ofTons(String a, String b) {
    return '$a / $b';
  }

  @override
  String loadsOnRoute(String route) {
    return 'আপনার রুটে লোড ($route)';
  }

  @override
  String get sharedNone => 'এখন রুটে খালি জায়গায় মানানসই লোড নেই।';

  @override
  String cropDashQty(String crop, String qty) {
    return '$crop – $qty';
  }

  @override
  String get sharedRuleTitle => 'আলাদা কাজ, আলাদা ভাড়া';

  @override
  String get sharedRuleBody =>
      'এই লোড আলাদা নিরাপদ লেনদেনে। এর ক্রেতার কাছে পৌঁছালেই এর ভাড়া পাবেন।';

  @override
  String get addLoad => 'লোড যোগ করুন';

  @override
  String get addThisLoad => 'এই লোড যোগ করুন';

  @override
  String sharedFits(String t) {
    return 'আপনার ট্রাকে $t খালি আছে, এই লোড মানানসই।';
  }

  @override
  String get onRoute => 'রুটেই';

  @override
  String detourKm(String km) {
    return '$km কিমি ঘুরতে হবে';
  }

  @override
  String loadSubStops(String crop, String qty, String n) {
    return '$crop · $qty · $nটি পিকআপ';
  }

  @override
  String pickupsLine(String n, String places) {
    return '$nটি পিকআপ · $places';
  }

  @override
  String pickupsN(String n) {
    return '$nটি পিকআপ';
  }

  @override
  String stopsMany(String n) {
    return '$nটি পিকআপ + ১টি ডেলিভারি';
  }

  @override
  String stepLoadedAt(String time) {
    return 'লোড হয়েছে · $time';
  }

  @override
  String startWeighingStop(String n) {
    return 'পিকআপ $n: লোড ও ওজন শুরু করুন';
  }

  @override
  String get farmerDeliveredTitle => 'ডেলিভারি নিশ্চিতকরণ';

  @override
  String get rowSentQty => 'পাঠানো পরিমাণ';

  @override
  String get rowReceivedQty => 'গ্রহণ করা পরিমাণ';

  @override
  String get rowDeliveredAt => 'ডেলিভারি সময়';

  @override
  String get farmerDeliveredNote =>
      'পণ্য ক্রেতার কাছে পৌঁছেছে। আপনার টাকা লোডের সময়ই পাঠানো হয়েছে (চূড়ান্ত)।';

  @override
  String get rateBuyerBtn => 'ক্রেতাকে রেটিং দিন';

  @override
  String get seePayStatus => 'পেমেন্টের অবস্থা দেখুন';

  @override
  String get seeDeliveryBtn => 'ডেলিভারি ও রেটিং';

  @override
  String get howWasDeal => 'লেনদেন কেমন ছিল?';

  @override
  String get tagOnTimePay => 'সময়মতো পেমেন্ট';

  @override
  String get tagGoodBehaviour => 'ভালো ব্যবহার';

  @override
  String get tagFairWeight => 'সঠিক ওজন';

  @override
  String nFarmerDelivered(String no) {
    return 'ক্রেতার কাছে পৌঁছেছে: $no';
  }

  @override
  String get permTitle => 'কয়েকটি অনুমতি দরকার';

  @override
  String get permSub =>
      'কেন দরকার নিচে লেখা আছে। পরে সেটিংস থেকে বদলাতে পারবেন।';

  @override
  String get permLocation => 'লোকেশন';

  @override
  String get permLocationWhy => 'কাছাকাছি ক্রেতা, পিকআপ ও ট্রাক খুঁজতে';

  @override
  String get permCamera => 'ক্যামেরা';

  @override
  String get permCameraWhy => 'ফসলের ছবি ও ডেলিভারির প্রমাণ তুলতে';

  @override
  String get permNotif => 'নোটিফিকেশন';

  @override
  String get permNotifWhy => 'নতুন অফার ও পেমেন্টের খবর পেতে';

  @override
  String get permAllow => 'অনুমতি';

  @override
  String get permGiven => '✓ দেওয়া';

  @override
  String get permAllowAll => 'সব অনুমতি দিন';

  @override
  String get permLater => 'পরে করব';

  @override
  String get payStatusTitle => 'পেমেন্টের অবস্থা';

  @override
  String get payHeldLine => 'নিরাপদ লেনদেনে জমা · ক্রেতার কাছে পৌঁছালেই ছাড়';

  @override
  String get paySentLine => 'ভাড়া আপনার অ্যাকাউন্টে পাঠানো হয়েছে';

  @override
  String get payStepCustomer => 'গ্রাহক পেমেন্ট জমা দিয়েছেন';

  @override
  String get payStepDelivered => 'ডেলিভারি নিশ্চিত';

  @override
  String get payStepSent => 'আপনার অ্যাকাউন্টে পাঠানো';
}
