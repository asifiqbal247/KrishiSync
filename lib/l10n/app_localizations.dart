import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In bn, this message translates to:
  /// **'Golaghor'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In bn, this message translates to:
  /// **'কৃষির সাথে, আপনার পাশে'**
  String get splashTagline;

  /// No description provided for @splashVersion.
  ///
  /// In bn, this message translates to:
  /// **'সংস্করণ {version}'**
  String splashVersion(String version);

  /// No description provided for @langTitleBn.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা নির্বাচন করুন'**
  String get langTitleBn;

  /// No description provided for @langTitleEn.
  ///
  /// In bn, this message translates to:
  /// **'Choose your language'**
  String get langTitleEn;

  /// No description provided for @langBangla.
  ///
  /// In bn, this message translates to:
  /// **'বাংলা'**
  String get langBangla;

  /// No description provided for @langBanglaSub.
  ///
  /// In bn, this message translates to:
  /// **'Bangla'**
  String get langBanglaSub;

  /// No description provided for @langEnglish.
  ///
  /// In bn, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langEnglishSub.
  ///
  /// In bn, this message translates to:
  /// **'ইংরেজি'**
  String get langEnglishSub;

  /// No description provided for @langContinue.
  ///
  /// In bn, this message translates to:
  /// **'এগিয়ে যান'**
  String get langContinue;

  /// No description provided for @onb1Title.
  ///
  /// In bn, this message translates to:
  /// **'সরাসরি ক্রেতার কাছে বিক্রি করুন'**
  String get onb1Title;

  /// No description provided for @onb1Body.
  ///
  /// In bn, this message translates to:
  /// **'মধ্যস্বত্বভোগী ছাড়াই ন্যায্য দাম পান। নিজের ফসলের দাম নিজেই ঠিক করুন।'**
  String get onb1Body;

  /// No description provided for @onb2Title.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে নিশ্চিন্ত থাকুন'**
  String get onb2Title;

  /// No description provided for @onb2Body.
  ///
  /// In bn, this message translates to:
  /// **'মাল গাড়িতে উঠলেই কৃষকের টাকা, ক্রেতার কাছে পৌঁছালেই ট্রান্সপোর্টারের টাকা।'**
  String get onb2Body;

  /// No description provided for @onb3Title.
  ///
  /// In bn, this message translates to:
  /// **'সহজে ট্রাক, ঝামেলা ছাড়াই পরিবহন'**
  String get onb3Title;

  /// No description provided for @onb3Body.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা ট্রাক বুক করেন। কৃষক ও ক্রেতা দুজনেই ট্রাকের অবস্থান দেখতে পান।'**
  String get onb3Body;

  /// No description provided for @onbNext.
  ///
  /// In bn, this message translates to:
  /// **'পরবর্তী'**
  String get onbNext;

  /// No description provided for @onbStart.
  ///
  /// In bn, this message translates to:
  /// **'শুরু করুন'**
  String get onbStart;

  /// No description provided for @onbSkip.
  ///
  /// In bn, this message translates to:
  /// **'এড়িয়ে যান'**
  String get onbSkip;

  /// No description provided for @loginTitle.
  ///
  /// In bn, this message translates to:
  /// **'লগইন / নিবন্ধন'**
  String get loginTitle;

  /// No description provided for @loginHeading.
  ///
  /// In bn, this message translates to:
  /// **'আপনার মোবাইল নম্বর দিন'**
  String get loginHeading;

  /// No description provided for @loginSub.
  ///
  /// In bn, this message translates to:
  /// **'আমরা একটি ৬ সংখ্যার কোড পাঠাব'**
  String get loginSub;

  /// No description provided for @loginPhoneLabel.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর'**
  String get loginPhoneLabel;

  /// No description provided for @loginPhoneHint.
  ///
  /// In bn, this message translates to:
  /// **'01X XXXX XXXX'**
  String get loginPhoneHint;

  /// No description provided for @loginCountryCode.
  ///
  /// In bn, this message translates to:
  /// **'+880'**
  String get loginCountryCode;

  /// No description provided for @loginTerms.
  ///
  /// In bn, this message translates to:
  /// **'চালিয়ে গেলে আপনি শর্তাবলী ও গোপনীয়তা নীতিতে সম্মত হচ্ছেন।'**
  String get loginTerms;

  /// No description provided for @loginSendCode.
  ///
  /// In bn, this message translates to:
  /// **'কোড পাঠান'**
  String get loginSendCode;

  /// No description provided for @loginInvalidPhone.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক ১১ সংখ্যার মোবাইল নম্বর দিন'**
  String get loginInvalidPhone;

  /// No description provided for @otpTitle.
  ///
  /// In bn, this message translates to:
  /// **'কোড যাচাই'**
  String get otpTitle;

  /// No description provided for @otpHeading.
  ///
  /// In bn, this message translates to:
  /// **'কোড লিখুন'**
  String get otpHeading;

  /// No description provided for @otpSub.
  ///
  /// In bn, this message translates to:
  /// **'{phone} নম্বরে পাঠানো ৬ সংখ্যার কোড লিখুন'**
  String otpSub(String phone);

  /// No description provided for @otpNoCode.
  ///
  /// In bn, this message translates to:
  /// **'কোড পাননি?'**
  String get otpNoCode;

  /// No description provided for @otpResendIn.
  ///
  /// In bn, this message translates to:
  /// **'আবার পাঠান ({time})'**
  String otpResendIn(String time);

  /// No description provided for @otpResend.
  ///
  /// In bn, this message translates to:
  /// **'আবার পাঠান'**
  String get otpResend;

  /// No description provided for @otpVerify.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই করুন'**
  String get otpVerify;

  /// No description provided for @otpWrong.
  ///
  /// In bn, this message translates to:
  /// **'কোডটি সঠিক নয়। আবার চেষ্টা করুন।'**
  String get otpWrong;

  /// No description provided for @roleTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনি কে?'**
  String get roleTitle;

  /// No description provided for @roleSub.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ভূমিকায় চাপ দিন'**
  String get roleSub;

  /// No description provided for @roleFarmer.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক'**
  String get roleFarmer;

  /// No description provided for @roleFarmerSub.
  ///
  /// In bn, this message translates to:
  /// **'ফসল বিক্রি করুন, ক্রেতা খুঁজুন'**
  String get roleFarmerSub;

  /// No description provided for @roleBuyer.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা (ব্যবসা)'**
  String get roleBuyer;

  /// No description provided for @roleBuyerSub.
  ///
  /// In bn, this message translates to:
  /// **'ফসল কিনুন, সরবরাহ সংগ্রহ করুন'**
  String get roleBuyerSub;

  /// No description provided for @roleTransporter.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহনকারী'**
  String get roleTransporter;

  /// No description provided for @roleTransporterSub.
  ///
  /// In bn, this message translates to:
  /// **'লোড খুঁজুন, ট্রিপ সম্পন্ন করুন'**
  String get roleTransporterSub;

  /// No description provided for @roleModerator.
  ///
  /// In bn, this message translates to:
  /// **'মডারেটর'**
  String get roleModerator;

  /// No description provided for @roleAdmin.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাডমিন'**
  String get roleAdmin;

  /// No description provided for @profileSetupTitle.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল তৈরি'**
  String get profileSetupTitle;

  /// No description provided for @profileAddPhoto.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল ছবি যোগ করুন'**
  String get profileAddPhoto;

  /// No description provided for @profileFullName.
  ///
  /// In bn, this message translates to:
  /// **'পুরো নাম'**
  String get profileFullName;

  /// No description provided for @profileFullNameHint.
  ///
  /// In bn, this message translates to:
  /// **'আপনার নাম লিখুন'**
  String get profileFullNameHint;

  /// No description provided for @profileDivision.
  ///
  /// In bn, this message translates to:
  /// **'বিভাগ'**
  String get profileDivision;

  /// No description provided for @profileDistrictUpazilaUnion.
  ///
  /// In bn, this message translates to:
  /// **'জেলা › উপজেলা › ইউনিয়ন'**
  String get profileDistrictUpazilaUnion;

  /// No description provided for @profileVillage.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাম / পাড়া'**
  String get profileVillage;

  /// No description provided for @profileVillageHint.
  ///
  /// In bn, this message translates to:
  /// **'নাম লিখুন বা ম্যাপে পিন দিন'**
  String get profileVillageHint;

  /// No description provided for @profileNid.
  ///
  /// In bn, this message translates to:
  /// **'NID নম্বর (ঐচ্ছিক)'**
  String get profileNid;

  /// No description provided for @profileNidHint.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইয়ের জন্য'**
  String get profileNidHint;

  /// No description provided for @profileDone.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন করুন'**
  String get profileDone;

  /// No description provided for @selectHint.
  ///
  /// In bn, this message translates to:
  /// **'নির্বাচন করুন'**
  String get selectHint;

  /// No description provided for @commonBack.
  ///
  /// In bn, this message translates to:
  /// **'পেছনে'**
  String get commonBack;

  /// No description provided for @commonSeeAll.
  ///
  /// In bn, this message translates to:
  /// **'সব দেখুন'**
  String get commonSeeAll;

  /// No description provided for @commonSearch.
  ///
  /// In bn, this message translates to:
  /// **'খুঁজুন'**
  String get commonSearch;

  /// No description provided for @commonRetry.
  ///
  /// In bn, this message translates to:
  /// **'আবার চেষ্টা করুন'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত করুন'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In bn, this message translates to:
  /// **'সংরক্ষণ করুন'**
  String get commonSave;

  /// No description provided for @commonLoading.
  ///
  /// In bn, this message translates to:
  /// **'লোড হচ্ছে…'**
  String get commonLoading;

  /// No description provided for @commonRequired.
  ///
  /// In bn, this message translates to:
  /// **'এই ঘরটি পূরণ করুন'**
  String get commonRequired;

  /// No description provided for @errorGeneric.
  ///
  /// In bn, this message translates to:
  /// **'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In bn, this message translates to:
  /// **'ইন্টারনেট সংযোগ নেই'**
  String get errorNetwork;

  /// No description provided for @errorUpload.
  ///
  /// In bn, this message translates to:
  /// **'ছবি আপলোড হয়নি। আবার চেষ্টা করুন।'**
  String get errorUpload;

  /// No description provided for @errorPermission.
  ///
  /// In bn, this message translates to:
  /// **'এই কাজের অনুমতি আপনার নেই'**
  String get errorPermission;

  /// No description provided for @unitKg.
  ///
  /// In bn, this message translates to:
  /// **'কেজি'**
  String get unitKg;

  /// No description provided for @currencySymbol.
  ///
  /// In bn, this message translates to:
  /// **'৳'**
  String get currencySymbol;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In bn, this message translates to:
  /// **'অনেকবার চেষ্টা হয়েছে। কিছুক্ষণ পর আবার চেষ্টা করুন।'**
  String get errorTooManyRequests;

  /// No description provided for @locTitleDivision.
  ///
  /// In bn, this message translates to:
  /// **'এলাকা বাছুন'**
  String get locTitleDivision;

  /// No description provided for @locTitleDistrict.
  ///
  /// In bn, this message translates to:
  /// **'জেলা বাছুন'**
  String get locTitleDistrict;

  /// No description provided for @locTitleUpazila.
  ///
  /// In bn, this message translates to:
  /// **'উপজেলা বাছুন'**
  String get locTitleUpazila;

  /// No description provided for @locTitleVillage.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাম ও ঠিকানা'**
  String get locTitleVillage;

  /// No description provided for @locUseGps.
  ///
  /// In bn, this message translates to:
  /// **'আমার বর্তমান অবস্থান ব্যবহার করুন'**
  String get locUseGps;

  /// No description provided for @locGps.
  ///
  /// In bn, this message translates to:
  /// **'GPS'**
  String get locGps;

  /// No description provided for @locGpsLocating.
  ///
  /// In bn, this message translates to:
  /// **'অবস্থান খোঁজা হচ্ছে…'**
  String get locGpsLocating;

  /// No description provided for @locGpsFailed.
  ///
  /// In bn, this message translates to:
  /// **'অবস্থান পাওয়া যায়নি। লোকেশন চালু করে আবার চেষ্টা করুন।'**
  String get locGpsFailed;

  /// No description provided for @locRecent.
  ///
  /// In bn, this message translates to:
  /// **'সাম্প্রতিক ঠিকানা'**
  String get locRecent;

  /// No description provided for @locMapPinSaved.
  ///
  /// In bn, this message translates to:
  /// **'ম্যাপ পিন সেভ করা'**
  String get locMapPinSaved;

  /// No description provided for @locSearchAll.
  ///
  /// In bn, this message translates to:
  /// **'বিভাগ, জেলা, উপজেলা বা গ্রাম খুঁজুন'**
  String get locSearchAll;

  /// No description provided for @locSearchDistrict.
  ///
  /// In bn, this message translates to:
  /// **'জেলা খুঁজুন'**
  String get locSearchDistrict;

  /// No description provided for @locSearchUpazila.
  ///
  /// In bn, this message translates to:
  /// **'উপজেলা খুঁজুন'**
  String get locSearchUpazila;

  /// No description provided for @locStep.
  ///
  /// In bn, this message translates to:
  /// **'ধাপ {step}/{total} · {level}'**
  String locStep(String step, String total, String level);

  /// No description provided for @locLevelDivision.
  ///
  /// In bn, this message translates to:
  /// **'বিভাগ'**
  String get locLevelDivision;

  /// No description provided for @locLevelDistrict.
  ///
  /// In bn, this message translates to:
  /// **'জেলা'**
  String get locLevelDistrict;

  /// No description provided for @locLevelUpazila.
  ///
  /// In bn, this message translates to:
  /// **'উপজেলা'**
  String get locLevelUpazila;

  /// No description provided for @locLevelUnionVillage.
  ///
  /// In bn, this message translates to:
  /// **'ইউনিয়ন ও গ্রাম'**
  String get locLevelUnionVillage;

  /// No description provided for @locDivisionPill.
  ///
  /// In bn, this message translates to:
  /// **'{name} বিভাগ'**
  String locDivisionPill(String name);

  /// No description provided for @locDistrictCount.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি জেলা'**
  String locDistrictCount(String count);

  /// No description provided for @locUpazilaCount.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি উপজেলা'**
  String locUpazilaCount(String count);

  /// No description provided for @locUnionLabel.
  ///
  /// In bn, this message translates to:
  /// **'ইউনিয়ন / পৌরসভা'**
  String get locUnionLabel;

  /// No description provided for @locUnionHint.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা থেকে বাছুন'**
  String get locUnionHint;

  /// No description provided for @locVillageLabel.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাম / পাড়া / মহল্লা'**
  String get locVillageLabel;

  /// No description provided for @locVillageHint.
  ///
  /// In bn, this message translates to:
  /// **'নাম লিখুন বা মাইকে বলুন'**
  String get locVillageHint;

  /// No description provided for @locLandmarkLabel.
  ///
  /// In bn, this message translates to:
  /// **'চেনার চিহ্ন (ঐচ্ছিক)'**
  String get locLandmarkLabel;

  /// No description provided for @locLandmarkHint.
  ///
  /// In bn, this message translates to:
  /// **'যেমন: বাজারের পাশে, স্কুলের সামনে'**
  String get locLandmarkHint;

  /// No description provided for @locWhyTitle.
  ///
  /// In bn, this message translates to:
  /// **'কেন সঠিক ঠিকানা দরকার'**
  String get locWhyTitle;

  /// No description provided for @locWhyBody.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক ঠিক জায়গায় পৌঁছাবে, কাছের ক্রেতা ও লোড মিলবে।'**
  String get locWhyBody;

  /// No description provided for @locSaveAs.
  ///
  /// In bn, this message translates to:
  /// **'এই ঠিকানা সেভ করুন (পরে এক ট্যাপে বাছতে)'**
  String get locSaveAs;

  /// No description provided for @locTagHome.
  ///
  /// In bn, this message translates to:
  /// **'বাড়ি'**
  String get locTagHome;

  /// No description provided for @locTagFarm.
  ///
  /// In bn, this message translates to:
  /// **'খামার'**
  String get locTagFarm;

  /// No description provided for @locTagStore.
  ///
  /// In bn, this message translates to:
  /// **'গুদাম'**
  String get locTagStore;

  /// No description provided for @locTagOther.
  ///
  /// In bn, this message translates to:
  /// **'অন্যান্য'**
  String get locTagOther;

  /// No description provided for @locConfirm.
  ///
  /// In bn, this message translates to:
  /// **'এই ঠিকানা নিশ্চিত করুন'**
  String get locConfirm;

  /// No description provided for @locNoResults.
  ///
  /// In bn, this message translates to:
  /// **'কিছু পাওয়া যায়নি'**
  String get locNoResults;

  /// No description provided for @photoCamera.
  ///
  /// In bn, this message translates to:
  /// **'ক্যামেরা দিয়ে তুলুন'**
  String get photoCamera;

  /// No description provided for @photoGallery.
  ///
  /// In bn, this message translates to:
  /// **'গ্যালারি থেকে নিন'**
  String get photoGallery;

  /// No description provided for @homeComingSoon.
  ///
  /// In bn, this message translates to:
  /// **'এই অংশটি তৈরি হচ্ছে'**
  String get homeComingSoon;

  /// No description provided for @logout.
  ///
  /// In bn, this message translates to:
  /// **'লগআউট'**
  String get logout;

  /// No description provided for @comingSoon.
  ///
  /// In bn, this message translates to:
  /// **'শীঘ্রই আসছে'**
  String get comingSoon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
