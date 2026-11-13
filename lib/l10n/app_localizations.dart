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

  /// No description provided for @greetingMorning.
  ///
  /// In bn, this message translates to:
  /// **'শুভ সকাল,'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In bn, this message translates to:
  /// **'শুভ দুপুর,'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In bn, this message translates to:
  /// **'শুভ সন্ধ্যা,'**
  String get greetingEvening;

  /// No description provided for @navHome.
  ///
  /// In bn, this message translates to:
  /// **'হোম'**
  String get navHome;

  /// No description provided for @navMarket.
  ///
  /// In bn, this message translates to:
  /// **'বাজার'**
  String get navMarket;

  /// No description provided for @navSell.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রি'**
  String get navSell;

  /// No description provided for @navOrders.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার'**
  String get navOrders;

  /// No description provided for @navProfile.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল'**
  String get navProfile;

  /// No description provided for @navListings.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা'**
  String get navListings;

  /// No description provided for @navReports.
  ///
  /// In bn, this message translates to:
  /// **'রিপোর্ট'**
  String get navReports;

  /// No description provided for @navVerify.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই'**
  String get navVerify;

  /// No description provided for @farmerSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'ফসল, ক্রেতা বা এলাকা খুঁজুন'**
  String get farmerSearchHint;

  /// No description provided for @homeNewOffers.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি নতুন অফার এসেছে'**
  String homeNewOffers(String count);

  /// No description provided for @homeSee.
  ///
  /// In bn, this message translates to:
  /// **'দেখুন'**
  String get homeSee;

  /// No description provided for @homeTodayPrices.
  ///
  /// In bn, this message translates to:
  /// **'আজকের বাজার দর'**
  String get homeTodayPrices;

  /// No description provided for @homeWhatToDo.
  ///
  /// In bn, this message translates to:
  /// **'আপনি কী করতে চান?'**
  String get homeWhatToDo;

  /// No description provided for @homeSellCrop.
  ///
  /// In bn, this message translates to:
  /// **'ফসল বিক্রি করুন'**
  String get homeSellCrop;

  /// No description provided for @homeSellCropSub.
  ///
  /// In bn, this message translates to:
  /// **'২ মিনিটে তালিকা দিন'**
  String get homeSellCropSub;

  /// No description provided for @homeMyListings.
  ///
  /// In bn, this message translates to:
  /// **'আমার তালিকা'**
  String get homeMyListings;

  /// No description provided for @homeMyListingsSub.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি চলমান তালিকা'**
  String homeMyListingsSub(String count);

  /// No description provided for @homeBuyerDemand.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার চাহিদা'**
  String get homeBuyerDemand;

  /// No description provided for @homeBuyerDemandSub.
  ///
  /// In bn, this message translates to:
  /// **'কাছাকাছি চাহিদা দেখুন'**
  String get homeBuyerDemandSub;

  /// No description provided for @homePayments.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট'**
  String get homePayments;

  /// No description provided for @homePaymentsSub.
  ///
  /// In bn, this message translates to:
  /// **'এ মাসে {amount}'**
  String homePaymentsSub(String amount);

  /// No description provided for @homeOngoingOrders.
  ///
  /// In bn, this message translates to:
  /// **'চলমান অর্ডার'**
  String get homeOngoingOrders;

  /// No description provided for @homeBannerExportTitle.
  ///
  /// In bn, this message translates to:
  /// **'বিদেশে ফসল বিক্রি করুন'**
  String get homeBannerExportTitle;

  /// No description provided for @homeBannerExportSub.
  ///
  /// In bn, this message translates to:
  /// **'রপ্তানি গাইড ও বিদেশি ক্রেতা'**
  String get homeBannerExportSub;

  /// No description provided for @homeTips.
  ///
  /// In bn, this message translates to:
  /// **'কৃষি টিপস'**
  String get homeTips;

  /// No description provided for @tipBetterPrice.
  ///
  /// In bn, this message translates to:
  /// **'ভালো দাম পাওয়ার উপায়'**
  String get tipBetterPrice;

  /// No description provided for @tipPackaging.
  ///
  /// In bn, this message translates to:
  /// **'প্যাকেজিং টিপস'**
  String get tipPackaging;

  /// No description provided for @tipGrading.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড বোঝার নিয়ম'**
  String get tipGrading;

  /// No description provided for @tipListen.
  ///
  /// In bn, this message translates to:
  /// **'শুনুন · {time}'**
  String tipListen(String time);

  /// No description provided for @pricePerKg.
  ///
  /// In bn, this message translates to:
  /// **'{price}/কেজি'**
  String pricePerKg(String price);

  /// No description provided for @sellTitle.
  ///
  /// In bn, this message translates to:
  /// **'ফসল বিক্রি করুন'**
  String get sellTitle;

  /// No description provided for @sellStep1.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের তথ্য'**
  String get sellStep1;

  /// No description provided for @sellStep2.
  ///
  /// In bn, this message translates to:
  /// **'দাম ও স্থান'**
  String get sellStep2;

  /// No description provided for @sellStep3.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত করুন'**
  String get sellStep3;

  /// No description provided for @sellChooseCrop.
  ///
  /// In bn, this message translates to:
  /// **'ফসল বাছুন'**
  String get sellChooseCrop;

  /// No description provided for @sellOtherCropHint.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের নাম লিখুন'**
  String get sellOtherCropHint;

  /// No description provided for @sellGrade.
  ///
  /// In bn, this message translates to:
  /// **'মান (গ্রেড)'**
  String get sellGrade;

  /// No description provided for @gradeLabel.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড {grade}'**
  String gradeLabel(String grade);

  /// No description provided for @sellQuantity.
  ///
  /// In bn, this message translates to:
  /// **'পরিমাণ'**
  String get sellQuantity;

  /// No description provided for @sellAddPhoto.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের ছবি তুলুন'**
  String get sellAddPhoto;

  /// No description provided for @sellPrice.
  ///
  /// In bn, this message translates to:
  /// **'দাম (প্রতি কেজি)'**
  String get sellPrice;

  /// No description provided for @sellPriceUnit.
  ///
  /// In bn, this message translates to:
  /// **'৳/কেজি'**
  String get sellPriceUnit;

  /// No description provided for @sellMarketRange.
  ///
  /// In bn, this message translates to:
  /// **'আজকের বাজার দর: ৳ {min}–{max} / কেজি'**
  String sellMarketRange(String min, String max);

  /// No description provided for @sellAvailableFrom.
  ///
  /// In bn, this message translates to:
  /// **'কবে থেকে পাওয়া যাবে'**
  String get sellAvailableFrom;

  /// No description provided for @sellToday.
  ///
  /// In bn, this message translates to:
  /// **'আজ'**
  String get sellToday;

  /// No description provided for @sellTomorrow.
  ///
  /// In bn, this message translates to:
  /// **'কাল'**
  String get sellTomorrow;

  /// No description provided for @sellPickDate.
  ///
  /// In bn, this message translates to:
  /// **'তারিখ বাছুন'**
  String get sellPickDate;

  /// No description provided for @sellPickup.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ ঠিকানা'**
  String get sellPickup;

  /// No description provided for @sellNext.
  ///
  /// In bn, this message translates to:
  /// **'পরবর্তী'**
  String get sellNext;

  /// No description provided for @sellEdit.
  ///
  /// In bn, this message translates to:
  /// **'সম্পাদনা'**
  String get sellEdit;

  /// No description provided for @sellPublish.
  ///
  /// In bn, this message translates to:
  /// **'প্রকাশ করুন'**
  String get sellPublish;

  /// No description provided for @fieldCrop.
  ///
  /// In bn, this message translates to:
  /// **'ফসল'**
  String get fieldCrop;

  /// No description provided for @fieldQuantity.
  ///
  /// In bn, this message translates to:
  /// **'পরিমাণ'**
  String get fieldQuantity;

  /// No description provided for @fieldPrice.
  ///
  /// In bn, this message translates to:
  /// **'দাম'**
  String get fieldPrice;

  /// No description provided for @fieldAvailability.
  ///
  /// In bn, this message translates to:
  /// **'প্রাপ্যতা'**
  String get fieldAvailability;

  /// No description provided for @fieldPickup.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ'**
  String get fieldPickup;

  /// No description provided for @fieldMyPrice.
  ///
  /// In bn, this message translates to:
  /// **'আমার দাম'**
  String get fieldMyPrice;

  /// No description provided for @fieldMarketPrice.
  ///
  /// In bn, this message translates to:
  /// **'বাজার দর'**
  String get fieldMarketPrice;

  /// No description provided for @qtyKg.
  ///
  /// In bn, this message translates to:
  /// **'{qty} কেজি'**
  String qtyKg(String qty);

  /// No description provided for @priceLine.
  ///
  /// In bn, this message translates to:
  /// **'৳ {price} / কেজি'**
  String priceLine(String price);

  /// No description provided for @rangeLine.
  ///
  /// In bn, this message translates to:
  /// **'৳ {min}–{max} / কেজি'**
  String rangeLine(String min, String max);

  /// No description provided for @availableFromDate.
  ///
  /// In bn, this message translates to:
  /// **'{date} থেকে'**
  String availableFromDate(String date);

  /// No description provided for @cropWithGrade.
  ///
  /// In bn, this message translates to:
  /// **'{crop} (গ্রেড {grade})'**
  String cropWithGrade(String crop, String grade);

  /// No description provided for @errPhotoRequired.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের একটি ছবি দিন'**
  String get errPhotoRequired;

  /// No description provided for @errQtyInvalid.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক পরিমাণ দিন'**
  String get errQtyInvalid;

  /// No description provided for @errPriceInvalid.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক দাম দিন'**
  String get errPriceInvalid;

  /// No description provided for @listingSuccessTitle.
  ///
  /// In bn, this message translates to:
  /// **'ফসল তালিকায় যোগ হয়েছে!'**
  String get listingSuccessTitle;

  /// No description provided for @listingSuccessBody.
  ///
  /// In bn, this message translates to:
  /// **'মডারেটর অনুমোদনের পর ক্রেতারা আপনার ফসল দেখতে ও অফার দিতে পারবেন।'**
  String get listingSuccessBody;

  /// No description provided for @listingSuccessCta.
  ///
  /// In bn, this message translates to:
  /// **'আমার তালিকা দেখুন'**
  String get listingSuccessCta;

  /// No description provided for @myListingsTitle.
  ///
  /// In bn, this message translates to:
  /// **'আমার তালিকা'**
  String get myListingsTitle;

  /// No description provided for @tabOngoing.
  ///
  /// In bn, this message translates to:
  /// **'চলমান'**
  String get tabOngoing;

  /// No description provided for @tabSold.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রিত'**
  String get tabSold;

  /// No description provided for @tabDraft.
  ///
  /// In bn, this message translates to:
  /// **'খসড়া'**
  String get tabDraft;

  /// No description provided for @emptyFilter.
  ///
  /// In bn, this message translates to:
  /// **'এই ফিল্টারে এখন কিছু নেই'**
  String get emptyFilter;

  /// No description provided for @addNewCrop.
  ///
  /// In bn, this message translates to:
  /// **'+ নতুন ফসল যোগ করুন'**
  String get addNewCrop;

  /// No description provided for @statusPending.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদনের অপেক্ষায়'**
  String get statusPending;

  /// No description provided for @statusActive.
  ///
  /// In bn, this message translates to:
  /// **'চলমান'**
  String get statusActive;

  /// No description provided for @statusSold.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রিত'**
  String get statusSold;

  /// No description provided for @statusHidden.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get statusHidden;

  /// No description provided for @listingSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'{qty} কেজি · ৳ {price}/কেজি'**
  String listingSubtitle(String qty, String price);

  /// No description provided for @cropDetailsTitle.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের বিবরণ'**
  String get cropDetailsTitle;

  /// No description provided for @seeBuyerOffers.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার অফার দেখুন ({count})'**
  String seeBuyerOffers(String count);

  /// No description provided for @moderationNote.
  ///
  /// In bn, this message translates to:
  /// **'মডারেটরের মন্তব্য: {note}'**
  String moderationNote(String note);

  /// No description provided for @markSold.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রি হয়েছে চিহ্নিত করুন'**
  String get markSold;

  /// No description provided for @modHomeQueue.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদনের অপেক্ষায় থাকা তালিকা'**
  String get modHomeQueue;

  /// No description provided for @modStatPending.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষমাণ তালিকা'**
  String get modStatPending;

  /// No description provided for @modStatActive.
  ///
  /// In bn, this message translates to:
  /// **'চলমান তালিকা'**
  String get modStatActive;

  /// No description provided for @modStatHidden.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল তালিকা'**
  String get modStatHidden;

  /// No description provided for @modListingsTitle.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা যাচাই'**
  String get modListingsTitle;

  /// No description provided for @modReviewTitle.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা পর্যালোচনা'**
  String get modReviewTitle;

  /// No description provided for @modFarmer.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক'**
  String get modFarmer;

  /// No description provided for @modApprove.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদন দিন'**
  String get modApprove;

  /// No description provided for @modReject.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল করুন'**
  String get modReject;

  /// No description provided for @modRejectReasonTitle.
  ///
  /// In bn, this message translates to:
  /// **'বাতিলের কারণ'**
  String get modRejectReasonTitle;

  /// No description provided for @modRejectReasonHint.
  ///
  /// In bn, this message translates to:
  /// **'যেমন: ছবি অস্পষ্ট, দাম অস্বাভাবিক'**
  String get modRejectReasonHint;

  /// No description provided for @modApproved.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা অনুমোদিত হয়েছে'**
  String get modApproved;

  /// No description provided for @modRejected.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা বাতিল হয়েছে'**
  String get modRejected;

  /// No description provided for @modQueueEmpty.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষমাণ কোনো তালিকা নেই'**
  String get modQueueEmpty;

  /// No description provided for @submittedOn.
  ///
  /// In bn, this message translates to:
  /// **'জমা: {date}'**
  String submittedOn(String date);

  /// No description provided for @cropOther.
  ///
  /// In bn, this message translates to:
  /// **'অন্যান্য'**
  String get cropOther;

  /// No description provided for @profileLanguage.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা'**
  String get profileLanguage;

  /// No description provided for @profileRole.
  ///
  /// In bn, this message translates to:
  /// **'ভূমিকা'**
  String get profileRole;

  /// No description provided for @profilePhone.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর'**
  String get profilePhone;

  /// No description provided for @tabComingTitle.
  ///
  /// In bn, this message translates to:
  /// **'এই অংশটি পরের ধাপে আসছে'**
  String get tabComingTitle;

  /// No description provided for @navCollect.
  ///
  /// In bn, this message translates to:
  /// **'সংগ্রহ'**
  String get navCollect;

  /// No description provided for @navDemand.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা'**
  String get navDemand;

  /// No description provided for @buyerSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'ফসল, কৃষক বা এলাকা খুঁজুন'**
  String get buyerSearchHint;

  /// No description provided for @statOngoingOrders.
  ///
  /// In bn, this message translates to:
  /// **'চলমান অর্ডার'**
  String get statOngoingOrders;

  /// No description provided for @statInTransit.
  ///
  /// In bn, this message translates to:
  /// **'পথে আছে'**
  String get statInTransit;

  /// No description provided for @statSafePay.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে'**
  String get statSafePay;

  /// No description provided for @statNewOffers.
  ///
  /// In bn, this message translates to:
  /// **'নতুন অফার'**
  String get statNewOffers;

  /// No description provided for @countTi.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি'**
  String countTi(String count);

  /// No description provided for @catAll.
  ///
  /// In bn, this message translates to:
  /// **'সব'**
  String get catAll;

  /// No description provided for @catVegetable.
  ///
  /// In bn, this message translates to:
  /// **'সবজি'**
  String get catVegetable;

  /// No description provided for @catFruit.
  ///
  /// In bn, this message translates to:
  /// **'ফল'**
  String get catFruit;

  /// No description provided for @catGrain.
  ///
  /// In bn, this message translates to:
  /// **'শস্য'**
  String get catGrain;

  /// No description provided for @catFish.
  ///
  /// In bn, this message translates to:
  /// **'মাছ'**
  String get catFish;

  /// No description provided for @catSpice.
  ///
  /// In bn, this message translates to:
  /// **'মসলা'**
  String get catSpice;

  /// No description provided for @catPulse.
  ///
  /// In bn, this message translates to:
  /// **'ডাল'**
  String get catPulse;

  /// No description provided for @quickActions.
  ///
  /// In bn, this message translates to:
  /// **'দ্রুত কাজ'**
  String get quickActions;

  /// No description provided for @actPostDemand.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা পোস্ট করুন'**
  String get actPostDemand;

  /// No description provided for @actPostDemandSub.
  ///
  /// In bn, this message translates to:
  /// **'কৃষকরা অফার দেবেন'**
  String get actPostDemandSub;

  /// No description provided for @actMarket.
  ///
  /// In bn, this message translates to:
  /// **'বাজার'**
  String get actMarket;

  /// No description provided for @actMarketSub.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি ফসল'**
  String actMarketSub(String count);

  /// No description provided for @actProcurement.
  ///
  /// In bn, this message translates to:
  /// **'সংগ্রহ ড্যাশবোর্ড'**
  String get actProcurement;

  /// No description provided for @actProcurementSub.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা ও সংগ্রহ'**
  String get actProcurementSub;

  /// No description provided for @actBookTruck.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক বুক করুন'**
  String get actBookTruck;

  /// No description provided for @actBookTruckSub.
  ///
  /// In bn, this message translates to:
  /// **'ভাড়া তুলনা করে বুক'**
  String get actBookTruckSub;

  /// No description provided for @bannerPoolTitle.
  ///
  /// In bn, this message translates to:
  /// **'নতুন: ডিজিটাল পুলিং'**
  String get bannerPoolTitle;

  /// No description provided for @bannerPoolSub.
  ///
  /// In bn, this message translates to:
  /// **'একাধিক কৃষক থেকে বড় অর্ডার'**
  String get bannerPoolSub;

  /// No description provided for @bannerTry.
  ///
  /// In bn, this message translates to:
  /// **'চেষ্টা করুন'**
  String get bannerTry;

  /// No description provided for @topSuppliers.
  ///
  /// In bn, this message translates to:
  /// **'শীর্ষ সরবরাহকারী'**
  String get topSuppliers;

  /// No description provided for @recommendedCrops.
  ///
  /// In bn, this message translates to:
  /// **'আপনার জন্য সুপারিশকৃত ফসল'**
  String get recommendedCrops;

  /// No description provided for @onTimePct.
  ///
  /// In bn, this message translates to:
  /// **'{pct}% সময়মতো'**
  String onTimePct(String pct);

  /// No description provided for @marketTitle.
  ///
  /// In bn, this message translates to:
  /// **'বাজার'**
  String get marketTitle;

  /// No description provided for @marketSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'ফসল, এলাকা বা কৃষক খুঁজুন'**
  String get marketSearchHint;

  /// No description provided for @resultsCount.
  ///
  /// In bn, this message translates to:
  /// **'ফলাফল: {count}টি'**
  String resultsCount(String count);

  /// No description provided for @filterLabel.
  ///
  /// In bn, this message translates to:
  /// **'ফিল্টার: এলাকা, পরিমাণ, দাম'**
  String get filterLabel;

  /// No description provided for @listingLine.
  ///
  /// In bn, this message translates to:
  /// **'{qty} কেজি · {place}'**
  String listingLine(String qty, String place);

  /// No description provided for @listingLineRated.
  ///
  /// In bn, this message translates to:
  /// **'{qty} কেজি · {place} · {rating}'**
  String listingLineRated(String qty, String place, String rating);

  /// No description provided for @filterTitle.
  ///
  /// In bn, this message translates to:
  /// **'ফিল্টার'**
  String get filterTitle;

  /// No description provided for @filterDistrict.
  ///
  /// In bn, this message translates to:
  /// **'এলাকা (জেলা)'**
  String get filterDistrict;

  /// No description provided for @filterAnyDistrict.
  ///
  /// In bn, this message translates to:
  /// **'সব জেলা'**
  String get filterAnyDistrict;

  /// No description provided for @filterMinQty.
  ///
  /// In bn, this message translates to:
  /// **'ন্যূনতম পরিমাণ'**
  String get filterMinQty;

  /// No description provided for @filterMaxPrice.
  ///
  /// In bn, this message translates to:
  /// **'সর্বোচ্চ দাম (প্রতি কেজি)'**
  String get filterMaxPrice;

  /// No description provided for @filterApply.
  ///
  /// In bn, this message translates to:
  /// **'ফিল্টার করুন'**
  String get filterApply;

  /// No description provided for @filterClear.
  ///
  /// In bn, this message translates to:
  /// **'মুছুন'**
  String get filterClear;

  /// No description provided for @searchTitle.
  ///
  /// In bn, this message translates to:
  /// **'খুঁজুন'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In bn, this message translates to:
  /// **'আলু, টমেটো, এলাকা…'**
  String get searchHint;

  /// No description provided for @recentSearches.
  ///
  /// In bn, this message translates to:
  /// **'সাম্প্রতিক খোঁজ'**
  String get recentSearches;

  /// No description provided for @clearRecent.
  ///
  /// In bn, this message translates to:
  /// **'মুছুন'**
  String get clearRecent;

  /// No description provided for @popularNow.
  ///
  /// In bn, this message translates to:
  /// **'জনপ্রিয় এখন'**
  String get popularNow;

  /// No description provided for @suggestions.
  ///
  /// In bn, this message translates to:
  /// **'পরামর্শ'**
  String get suggestions;

  /// No description provided for @voiceGuide.
  ///
  /// In bn, this message translates to:
  /// **'মাইক চেপে ফসলের নাম বলুন'**
  String get voiceGuide;

  /// No description provided for @suggestListings.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি তালিকা'**
  String suggestListings(String count);

  /// No description provided for @suggestListingsRange.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি তালিকা · ৳ {min}–{max}'**
  String suggestListingsRange(String count, String min, String max);

  /// No description provided for @noResults.
  ///
  /// In bn, this message translates to:
  /// **'কোনো ফসল পাওয়া যায়নি'**
  String get noResults;

  /// No description provided for @marketRangeFair.
  ///
  /// In bn, this message translates to:
  /// **'বাজার দর ৳ {min}–{max} / কেজি · ন্যায্য দামের মধ্যে'**
  String marketRangeFair(String min, String max);

  /// No description provided for @marketRangeOnly.
  ///
  /// In bn, this message translates to:
  /// **'বাজার দর ৳ {min}–{max} / কেজি'**
  String marketRangeOnly(String min, String max);

  /// No description provided for @qtyAvailable.
  ///
  /// In bn, this message translates to:
  /// **'{qty} কেজি উপলব্ধ'**
  String qtyAvailable(String qty);

  /// No description provided for @fieldAvailable.
  ///
  /// In bn, this message translates to:
  /// **'উপলব্ধ'**
  String get fieldAvailable;

  /// No description provided for @fieldLocation.
  ///
  /// In bn, this message translates to:
  /// **'অবস্থান'**
  String get fieldLocation;

  /// No description provided for @placeWithKm.
  ///
  /// In bn, this message translates to:
  /// **'{place} ({km} কিমি)'**
  String placeWithKm(String place, String km);

  /// No description provided for @sectionFarmer.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক'**
  String get sectionFarmer;

  /// No description provided for @sectionDelivery.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি ও পরিবহন'**
  String get sectionDelivery;

  /// No description provided for @fieldPayment.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট'**
  String get fieldPayment;

  /// No description provided for @safePayment.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেন'**
  String get safePayment;

  /// No description provided for @reviewsCount.
  ///
  /// In bn, this message translates to:
  /// **'রিভিউ ({count})'**
  String reviewsCount(String count);

  /// No description provided for @similarCrops.
  ///
  /// In bn, this message translates to:
  /// **'একই ধরনের ফসল'**
  String get similarCrops;

  /// No description provided for @makeOffer.
  ///
  /// In bn, this message translates to:
  /// **'অফার দিন'**
  String get makeOffer;

  /// No description provided for @placeOrder.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার করুন'**
  String get placeOrder;

  /// No description provided for @farmerCardSub.
  ///
  /// In bn, this message translates to:
  /// **'{verified}রেটিং {rating} · {count} লেনদেন'**
  String farmerCardSub(String verified, String rating, String count);

  /// No description provided for @verifiedDot.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত · '**
  String get verifiedDot;

  /// No description provided for @profileLink.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল'**
  String get profileLink;

  /// No description provided for @farmerProfileTitle.
  ///
  /// In bn, this message translates to:
  /// **'কৃষকের প্রোফাইল'**
  String get farmerProfileTitle;

  /// No description provided for @verifiedNid.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত (NID)'**
  String get verifiedNid;

  /// No description provided for @notVerified.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই বাকি'**
  String get notVerified;

  /// No description provided for @statRating.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং'**
  String get statRating;

  /// No description provided for @statOnTime.
  ///
  /// In bn, this message translates to:
  /// **'সময়মতো সরবরাহ'**
  String get statOnTime;

  /// No description provided for @statCompleted.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন লেনদেন'**
  String get statCompleted;

  /// No description provided for @statComplaints.
  ///
  /// In bn, this message translates to:
  /// **'মান অভিযোগ'**
  String get statComplaints;

  /// No description provided for @ratingWithCount.
  ///
  /// In bn, this message translates to:
  /// **'{rating} ({count})'**
  String ratingWithCount(String rating, String count);

  /// No description provided for @availableCrops.
  ///
  /// In bn, this message translates to:
  /// **'উপলব্ধ ফসল'**
  String get availableCrops;

  /// No description provided for @sendMessage.
  ///
  /// In bn, this message translates to:
  /// **'বার্তা পাঠান'**
  String get sendMessage;

  /// No description provided for @notAvailable.
  ///
  /// In bn, this message translates to:
  /// **'—'**
  String get notAvailable;

  /// No description provided for @qtyTon.
  ///
  /// In bn, this message translates to:
  /// **'{t} টন'**
  String qtyTon(String t);

  /// No description provided for @backToHome.
  ///
  /// In bn, this message translates to:
  /// **'হোম'**
  String get backToHome;
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
