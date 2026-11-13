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
}
