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

  /// No description provided for @offerTitle.
  ///
  /// In bn, this message translates to:
  /// **'অফার দিন'**
  String get offerTitle;

  /// No description provided for @offerYourPrice.
  ///
  /// In bn, this message translates to:
  /// **'আপনার দাম'**
  String get offerYourPrice;

  /// No description provided for @offerDeliveryDate.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি তারিখ'**
  String get offerDeliveryDate;

  /// No description provided for @offerTotal.
  ///
  /// In bn, this message translates to:
  /// **'মোট মূল্য'**
  String get offerTotal;

  /// No description provided for @offerSend.
  ///
  /// In bn, this message translates to:
  /// **'অফার পাঠান'**
  String get offerSend;

  /// No description provided for @offerSent.
  ///
  /// In bn, this message translates to:
  /// **'অফার পাঠানো হয়েছে'**
  String get offerSent;

  /// No description provided for @farmerQty.
  ///
  /// In bn, this message translates to:
  /// **'{farmer} · {qty}'**
  String farmerQty(String farmer, String qty);

  /// No description provided for @offersTitle.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার অফার'**
  String get offersTitle;

  /// No description provided for @offerTabAll.
  ///
  /// In bn, this message translates to:
  /// **'সব'**
  String get offerTabAll;

  /// No description provided for @offerTabNew.
  ///
  /// In bn, this message translates to:
  /// **'নতুন'**
  String get offerTabNew;

  /// No description provided for @offerTabTalking.
  ///
  /// In bn, this message translates to:
  /// **'আলোচনায়'**
  String get offerTabTalking;

  /// No description provided for @marketRangeShort.
  ///
  /// In bn, this message translates to:
  /// **'বাজার দর: ৳ {min}–{max} / কেজি'**
  String marketRangeShort(String min, String max);

  /// No description provided for @buyerVerifiedRating.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত · রেটিং {rating}'**
  String buyerVerifiedRating(String rating);

  /// No description provided for @buyerRating.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং {rating}'**
  String buyerRating(String rating);

  /// No description provided for @newBuyerQty.
  ///
  /// In bn, this message translates to:
  /// **'নতুন ক্রেতা · {qty}'**
  String newBuyerQty(String qty);

  /// No description provided for @pricePerKgShort.
  ///
  /// In bn, this message translates to:
  /// **'৳ {price}/কেজি'**
  String pricePerKgShort(String price);

  /// No description provided for @negotiateTitle.
  ///
  /// In bn, this message translates to:
  /// **'দর কষাকষি'**
  String get negotiateTitle;

  /// No description provided for @rowBuyer.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা'**
  String get rowBuyer;

  /// No description provided for @rowFarmer.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক'**
  String get rowFarmer;

  /// No description provided for @verifiedSuffix.
  ///
  /// In bn, this message translates to:
  /// **'{name} (যাচাইকৃত)'**
  String verifiedSuffix(String name);

  /// No description provided for @rowBuyerOffer.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার অফার'**
  String get rowBuyerOffer;

  /// No description provided for @rowFarmerCounter.
  ///
  /// In bn, this message translates to:
  /// **'কৃষকের পাল্টা অফার'**
  String get rowFarmerCounter;

  /// No description provided for @rowMyOffer.
  ///
  /// In bn, this message translates to:
  /// **'আমার অফার'**
  String get rowMyOffer;

  /// No description provided for @rowOfferValidity.
  ///
  /// In bn, this message translates to:
  /// **'অফারের মেয়াদ'**
  String get rowOfferValidity;

  /// No description provided for @hoursLeft.
  ///
  /// In bn, this message translates to:
  /// **'{h} ঘণ্টা বাকি'**
  String hoursLeft(String h);

  /// No description provided for @offerExpired.
  ///
  /// In bn, this message translates to:
  /// **'মেয়াদ শেষ'**
  String get offerExpired;

  /// No description provided for @paymentSafeLoad.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেন · লোড হলেই পাবেন'**
  String get paymentSafeLoad;

  /// No description provided for @counterLabel.
  ///
  /// In bn, this message translates to:
  /// **'পাল্টা অফার দিন'**
  String get counterLabel;

  /// No description provided for @reject.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাখ্যান'**
  String get reject;

  /// No description provided for @counter.
  ///
  /// In bn, this message translates to:
  /// **'পাল্টা অফার'**
  String get counter;

  /// No description provided for @acceptOffer.
  ///
  /// In bn, this message translates to:
  /// **'অফার গ্রহণ করুন'**
  String get acceptOffer;

  /// No description provided for @rejectConfirmTitle.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাখ্যান করবেন?'**
  String get rejectConfirmTitle;

  /// No description provided for @rejectConfirmBody.
  ///
  /// In bn, this message translates to:
  /// **'অপর পক্ষকে জানানো হবে। এটি আর গ্রহণ করা যাবে না, তবে তারা নতুন প্রস্তাব দিতে পারবেন।'**
  String get rejectConfirmBody;

  /// No description provided for @noGoBack.
  ///
  /// In bn, this message translates to:
  /// **'না, ফিরে যান'**
  String get noGoBack;

  /// No description provided for @yesReject.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ, প্রত্যাখ্যান'**
  String get yesReject;

  /// No description provided for @offerAcceptedTitle.
  ///
  /// In bn, this message translates to:
  /// **'অফার গ্রহণ হয়েছে!'**
  String get offerAcceptedTitle;

  /// No description provided for @offerAcceptedBody.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা টাকা জমা দিলে অর্ডার নিশ্চিত হবে। তখন আপনি জানতে পারবেন।'**
  String get offerAcceptedBody;

  /// No description provided for @seeOrder.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার দেখুন'**
  String get seeOrder;

  /// No description provided for @counterSent.
  ///
  /// In bn, this message translates to:
  /// **'পাল্টা অফার পাঠানো হয়েছে'**
  String get counterSent;

  /// No description provided for @offerRejected.
  ///
  /// In bn, this message translates to:
  /// **'অফার প্রত্যাখ্যান করা হয়েছে'**
  String get offerRejected;

  /// No description provided for @offerStatusPending.
  ///
  /// In bn, this message translates to:
  /// **'নতুন'**
  String get offerStatusPending;

  /// No description provided for @offerStatusCountered.
  ///
  /// In bn, this message translates to:
  /// **'আলোচনায়'**
  String get offerStatusCountered;

  /// No description provided for @offerStatusAccepted.
  ///
  /// In bn, this message translates to:
  /// **'গৃহীত'**
  String get offerStatusAccepted;

  /// No description provided for @offerStatusRejected.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাখ্যাত'**
  String get offerStatusRejected;

  /// No description provided for @offerStatusWithdrawn.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাহার'**
  String get offerStatusWithdrawn;

  /// No description provided for @orderNowFromOffer.
  ///
  /// In bn, this message translates to:
  /// **'এই দামে অর্ডার করুন'**
  String get orderNowFromOffer;

  /// No description provided for @placeOrderTitle.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার নিশ্চিত করুন'**
  String get placeOrderTitle;

  /// No description provided for @deliveryAddress.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি ঠিকানা'**
  String get deliveryAddress;

  /// No description provided for @cropQtyTitle.
  ///
  /// In bn, this message translates to:
  /// **'{crop} – {qty}'**
  String cropQtyTitle(String crop, String qty);

  /// No description provided for @farmerPrice.
  ///
  /// In bn, this message translates to:
  /// **'{farmer} · ৳ {price}/কেজি'**
  String farmerPrice(String farmer, String price);

  /// No description provided for @platformTruck.
  ///
  /// In bn, this message translates to:
  /// **'প্ল্যাটফর্মের ট্রাক'**
  String get platformTruck;

  /// No description provided for @platformTruckSub.
  ///
  /// In bn, this message translates to:
  /// **'স্বয়ংক্রিয় পরিবহন বুকিং'**
  String get platformTruckSub;

  /// No description provided for @selfTransport.
  ///
  /// In bn, this message translates to:
  /// **'নিজে পরিবহন করব'**
  String get selfTransport;

  /// No description provided for @rowCropPrice.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের মূল্য'**
  String get rowCropPrice;

  /// No description provided for @rowTransport.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহন'**
  String get rowTransport;

  /// No description provided for @rowPlatformFee.
  ///
  /// In bn, this message translates to:
  /// **'প্ল্যাটফর্ম ফি ({pct}%)'**
  String rowPlatformFee(String pct);

  /// No description provided for @rowTotal.
  ///
  /// In bn, this message translates to:
  /// **'মোট'**
  String get rowTotal;

  /// No description provided for @payWithSafe.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে পেমেন্ট করুন'**
  String get payWithSafe;

  /// No description provided for @orderPlacedTitle.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার নিশ্চিত হয়েছে!'**
  String get orderPlacedTitle;

  /// No description provided for @orderPlacedBody.
  ///
  /// In bn, this message translates to:
  /// **'টাকা নিরাপদ লেনদেনে জমা আছে। মাল গাড়িতে উঠলেই কৃষক টাকা পাবেন।'**
  String get orderPlacedBody;

  /// No description provided for @errQtyTooMuch.
  ///
  /// In bn, this message translates to:
  /// **'উপলব্ধ পরিমাণের চেয়ে বেশি'**
  String get errQtyTooMuch;

  /// No description provided for @errAddressRequired.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি ঠিকানা দিন'**
  String get errAddressRequired;

  /// No description provided for @ordersTitle.
  ///
  /// In bn, this message translates to:
  /// **'আমার অর্ডার'**
  String get ordersTitle;

  /// No description provided for @ordersTabAll.
  ///
  /// In bn, this message translates to:
  /// **'সব'**
  String get ordersTabAll;

  /// No description provided for @ordersTabOngoing.
  ///
  /// In bn, this message translates to:
  /// **'চলমান'**
  String get ordersTabOngoing;

  /// No description provided for @ordersTabDone.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন'**
  String get ordersTabDone;

  /// No description provided for @ordersTabCancelled.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get ordersTabCancelled;

  /// No description provided for @qtyPrice.
  ///
  /// In bn, this message translates to:
  /// **'{qty} · ৳ {price}/কেজি'**
  String qtyPrice(String qty, String price);

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusTransportBooked.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক বুক'**
  String get orderStatusTransportBooked;

  /// No description provided for @orderStatusPickedUp.
  ///
  /// In bn, this message translates to:
  /// **'লোড হয়েছে'**
  String get orderStatusPickedUp;

  /// No description provided for @orderStatusInTransit.
  ///
  /// In bn, this message translates to:
  /// **'পথে আছে'**
  String get orderStatusInTransit;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In bn, this message translates to:
  /// **'পৌঁছেছে'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get orderStatusCancelled;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডারের বিবরণ'**
  String get orderDetailsTitle;

  /// No description provided for @orderNoLine.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার #{no}'**
  String orderNoLine(String no);

  /// No description provided for @rowPayment.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট'**
  String get rowPayment;

  /// No description provided for @paymentHeld.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে জমা'**
  String get paymentHeld;

  /// No description provided for @paymentPending.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষমাণ'**
  String get paymentPending;

  /// No description provided for @rowLoadAndMoney.
  ///
  /// In bn, this message translates to:
  /// **'গাড়িতে লোড + আপনার টাকা'**
  String get rowLoadAndMoney;

  /// No description provided for @rowPickupDate.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ'**
  String get rowPickupDate;

  /// No description provided for @orderStatusSection.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডারের অবস্থা'**
  String get orderStatusSection;

  /// No description provided for @stepConfirmed.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার নিশ্চিত'**
  String get stepConfirmed;

  /// No description provided for @stepTruckBooked.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা ট্রাক বুক করেছেন'**
  String get stepTruckBooked;

  /// No description provided for @stepTruckBookedSelf.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা নিজে পরিবহন করবেন'**
  String get stepTruckBookedSelf;

  /// No description provided for @stepLoaded.
  ///
  /// In bn, this message translates to:
  /// **'গাড়িতে লোড + আপনার টাকা'**
  String get stepLoaded;

  /// No description provided for @stepLoadedBuyer.
  ///
  /// In bn, this message translates to:
  /// **'গাড়িতে লোড + কৃষকের টাকা'**
  String get stepLoadedBuyer;

  /// No description provided for @stepDelivered.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি'**
  String get stepDelivered;

  /// No description provided for @stepWaiting.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষমাণ'**
  String get stepWaiting;

  /// No description provided for @orderProblem.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডারে সমস্যা?'**
  String get orderProblem;

  /// No description provided for @orderProblemSub.
  ///
  /// In bn, this message translates to:
  /// **'সমস্যা জানান বা সাহায্য নিন'**
  String get orderProblemSub;

  /// No description provided for @trackShipment.
  ///
  /// In bn, this message translates to:
  /// **'চালান ট্র্যাক করুন'**
  String get trackShipment;

  /// No description provided for @dateTime.
  ///
  /// In bn, this message translates to:
  /// **'{date}, {time}'**
  String dateTime(String date, String time);

  /// No description provided for @notifTitle.
  ///
  /// In bn, this message translates to:
  /// **'নোটিফিকেশন'**
  String get notifTitle;

  /// No description provided for @notifEmpty.
  ///
  /// In bn, this message translates to:
  /// **'কোনো নোটিফিকেশন নেই'**
  String get notifEmpty;

  /// No description provided for @nOfferNew.
  ///
  /// In bn, this message translates to:
  /// **'নতুন অফার: {crop}'**
  String nOfferNew(String crop);

  /// No description provided for @nOfferNewBody.
  ///
  /// In bn, this message translates to:
  /// **'{buyer} · ৳ {price}/কেজি · {qty}'**
  String nOfferNewBody(String buyer, String price, String qty);

  /// No description provided for @nOfferCounter.
  ///
  /// In bn, this message translates to:
  /// **'পাল্টা অফার: {crop}'**
  String nOfferCounter(String crop);

  /// No description provided for @nOfferCounterBody.
  ///
  /// In bn, this message translates to:
  /// **'{farmer} · ৳ {price}/কেজি'**
  String nOfferCounterBody(String farmer, String price);

  /// No description provided for @nOfferAccepted.
  ///
  /// In bn, this message translates to:
  /// **'অফার গৃহীত: {crop}'**
  String nOfferAccepted(String crop);

  /// No description provided for @nOfferAcceptedBody.
  ///
  /// In bn, this message translates to:
  /// **'৳ {price}/কেজি দামে অর্ডার করুন'**
  String nOfferAcceptedBody(String price);

  /// No description provided for @nOfferRejected.
  ///
  /// In bn, this message translates to:
  /// **'অফার প্রত্যাখ্যাত: {crop}'**
  String nOfferRejected(String crop);

  /// No description provided for @nOrderNew.
  ///
  /// In bn, this message translates to:
  /// **'নতুন অর্ডার #{no}'**
  String nOrderNew(String no);

  /// No description provided for @nOrderNewBody.
  ///
  /// In bn, this message translates to:
  /// **'{buyer} · {crop} {qty}'**
  String nOrderNewBody(String buyer, String crop, String qty);

  /// No description provided for @nListingApproved.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা অনুমোদিত: {crop}'**
  String nListingApproved(String crop);

  /// No description provided for @nListingRejected.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা বাতিল: {crop}'**
  String nListingRejected(String crop);

  /// No description provided for @nListingApprovedBody.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতারা এখন আপনার ফসল দেখতে পারবেন'**
  String get nListingApprovedBody;

  /// No description provided for @homeOffersSub.
  ///
  /// In bn, this message translates to:
  /// **'{crop} · সর্বোচ্চ ৳ {price}/কেজি'**
  String homeOffersSub(String crop, String price);

  /// No description provided for @stateErrorTitle.
  ///
  /// In bn, this message translates to:
  /// **'কিছু সমস্যা হয়েছে'**
  String get stateErrorTitle;

  /// No description provided for @stateErrorBody.
  ///
  /// In bn, this message translates to:
  /// **'আপনার দেওয়া তথ্য সঠিক নয়। অনুগ্রহ করে আবার চেষ্টা করুন।'**
  String get stateErrorBody;

  /// No description provided for @stateGetHelp.
  ///
  /// In bn, this message translates to:
  /// **'সাহায্য নিন'**
  String get stateGetHelp;

  /// No description provided for @stateOfflineBody.
  ///
  /// In bn, this message translates to:
  /// **'আপনার তথ্য সংরক্ষিত আছে। সংযোগ ফিরলে স্বয়ংক্রিয়ভাবে পাঠানো হবে।'**
  String get stateOfflineBody;

  /// No description provided for @emptyOrdersTitle.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো অর্ডার নেই'**
  String get emptyOrdersTitle;

  /// No description provided for @emptyOrdersFarmerBody.
  ///
  /// In bn, this message translates to:
  /// **'ফসল তালিকাভুক্ত করুন, ক্রেতারা অফার পাঠাবে।'**
  String get emptyOrdersFarmerBody;

  /// No description provided for @emptyOrdersBuyerBody.
  ///
  /// In bn, this message translates to:
  /// **'বাজার থেকে পছন্দের ফসল অর্ডার করুন।'**
  String get emptyOrdersBuyerBody;

  /// No description provided for @emptyOrdersBuyerCta.
  ///
  /// In bn, this message translates to:
  /// **'বাজার দেখুন'**
  String get emptyOrdersBuyerCta;

  /// No description provided for @rowMyCounter.
  ///
  /// In bn, this message translates to:
  /// **'আমার পাল্টা অফার'**
  String get rowMyCounter;

  /// No description provided for @rowOfferStatus.
  ///
  /// In bn, this message translates to:
  /// **'অবস্থা'**
  String get rowOfferStatus;

  /// No description provided for @navTrip.
  ///
  /// In bn, this message translates to:
  /// **'ট্রিপ'**
  String get navTrip;

  /// No description provided for @navLoad.
  ///
  /// In bn, this message translates to:
  /// **'লোড'**
  String get navLoad;

  /// No description provided for @navEarnings.
  ///
  /// In bn, this message translates to:
  /// **'আয়'**
  String get navEarnings;

  /// No description provided for @trStatToday.
  ///
  /// In bn, this message translates to:
  /// **'আজকের আয়'**
  String get trStatToday;

  /// No description provided for @trStatOngoing.
  ///
  /// In bn, this message translates to:
  /// **'চলমান ট্রিপ'**
  String get trStatOngoing;

  /// No description provided for @trOngoingTitle.
  ///
  /// In bn, this message translates to:
  /// **'চলমান: {no}'**
  String trOngoingTitle(String no);

  /// No description provided for @trOngoingSub.
  ///
  /// In bn, this message translates to:
  /// **'{n}টি পিকআপ · {status}'**
  String trOngoingSub(String n, String status);

  /// No description provided for @trContinue.
  ///
  /// In bn, this message translates to:
  /// **'চালিয়ে যান'**
  String get trContinue;

  /// No description provided for @trWhatToDo.
  ///
  /// In bn, this message translates to:
  /// **'কী করতে চান?'**
  String get trWhatToDo;

  /// No description provided for @trFindLoads.
  ///
  /// In bn, this message translates to:
  /// **'লোড খুঁজুন'**
  String get trFindLoads;

  /// No description provided for @trFindLoadsSub.
  ///
  /// In bn, this message translates to:
  /// **'কাছাকাছি {n}টি লোড'**
  String trFindLoadsSub(String n);

  /// No description provided for @trMyJobs.
  ///
  /// In bn, this message translates to:
  /// **'আমার কাজ'**
  String get trMyJobs;

  /// No description provided for @trMyJobsSub.
  ///
  /// In bn, this message translates to:
  /// **'{n}টি কাজ'**
  String trMyJobsSub(String n);

  /// No description provided for @trReturnLoads.
  ///
  /// In bn, this message translates to:
  /// **'ফিরতি লোড'**
  String get trReturnLoads;

  /// No description provided for @trReturnLoadsSub.
  ///
  /// In bn, this message translates to:
  /// **'খালি ফিরবেন না'**
  String get trReturnLoadsSub;

  /// No description provided for @trEarnings.
  ///
  /// In bn, this message translates to:
  /// **'আয়'**
  String get trEarnings;

  /// No description provided for @trEarningsSub.
  ///
  /// In bn, this message translates to:
  /// **'এ সপ্তাহে {amount}'**
  String trEarningsSub(String amount);

  /// No description provided for @trNearbyLoads.
  ///
  /// In bn, this message translates to:
  /// **'আপনার কাছাকাছি লোড'**
  String get trNearbyLoads;

  /// No description provided for @seeAllLink.
  ///
  /// In bn, this message translates to:
  /// **'সব দেখুন'**
  String get seeAllLink;

  /// No description provided for @trReturnChances.
  ///
  /// In bn, this message translates to:
  /// **'ফিরতি লোডের সুযোগ'**
  String get trReturnChances;

  /// No description provided for @trWeekEarnings.
  ///
  /// In bn, this message translates to:
  /// **'এ সপ্তাহের আয়'**
  String get trWeekEarnings;

  /// No description provided for @trThisWeek.
  ///
  /// In bn, this message translates to:
  /// **'এ সপ্তাহে'**
  String get trThisWeek;

  /// No description provided for @trPendingPay.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষমাণ'**
  String get trPendingPay;

  /// No description provided for @wdSat.
  ///
  /// In bn, this message translates to:
  /// **'শনি'**
  String get wdSat;

  /// No description provided for @wdSun.
  ///
  /// In bn, this message translates to:
  /// **'রবি'**
  String get wdSun;

  /// No description provided for @wdMon.
  ///
  /// In bn, this message translates to:
  /// **'সোম'**
  String get wdMon;

  /// No description provided for @wdTue.
  ///
  /// In bn, this message translates to:
  /// **'মঙ্গল'**
  String get wdTue;

  /// No description provided for @wdWed.
  ///
  /// In bn, this message translates to:
  /// **'বুধ'**
  String get wdWed;

  /// No description provided for @wdThu.
  ///
  /// In bn, this message translates to:
  /// **'বৃহঃ'**
  String get wdThu;

  /// No description provided for @wdFri.
  ///
  /// In bn, this message translates to:
  /// **'শুক্র'**
  String get wdFri;

  /// No description provided for @routeLine.
  ///
  /// In bn, this message translates to:
  /// **'{from} → {to}'**
  String routeLine(String from, String to);

  /// No description provided for @loadSub.
  ///
  /// In bn, this message translates to:
  /// **'{crop} · {qty}'**
  String loadSub(String crop, String qty);

  /// No description provided for @loadSubDate.
  ///
  /// In bn, this message translates to:
  /// **'{crop} · {qty} · {date}'**
  String loadSubDate(String crop, String qty, String date);

  /// No description provided for @noLoads.
  ///
  /// In bn, this message translates to:
  /// **'এখন কোনো লোড নেই'**
  String get noLoads;

  /// No description provided for @takaAmount.
  ///
  /// In bn, this message translates to:
  /// **'৳ {amount}'**
  String takaAmount(String amount);

  /// No description provided for @vehicleNeeded.
  ///
  /// In bn, this message translates to:
  /// **'লোড নিতে আগে গাড়ির তথ্য দিন'**
  String get vehicleNeeded;

  /// No description provided for @loadsTitle.
  ///
  /// In bn, this message translates to:
  /// **'উপলব্ধ লোড'**
  String get loadsTitle;

  /// No description provided for @filterAll.
  ///
  /// In bn, this message translates to:
  /// **'সব'**
  String get filterAll;

  /// No description provided for @filterNearby.
  ///
  /// In bn, this message translates to:
  /// **'কাছাকাছি'**
  String get filterNearby;

  /// No description provided for @filterFullLoad.
  ///
  /// In bn, this message translates to:
  /// **'ফুল লোড'**
  String get filterFullLoad;

  /// No description provided for @filterMultiPickup.
  ///
  /// In bn, this message translates to:
  /// **'একাধিক পিকআপ'**
  String get filterMultiPickup;

  /// No description provided for @loadDetailsTitle.
  ///
  /// In bn, this message translates to:
  /// **'লোডের বিবরণ'**
  String get loadDetailsTitle;

  /// No description provided for @rowGoods.
  ///
  /// In bn, this message translates to:
  /// **'মালামাল'**
  String get rowGoods;

  /// No description provided for @rowDestination.
  ///
  /// In bn, this message translates to:
  /// **'গন্তব্য'**
  String get rowDestination;

  /// No description provided for @rowDistance.
  ///
  /// In bn, this message translates to:
  /// **'দূরত্ব'**
  String get rowDistance;

  /// No description provided for @distanceLine.
  ///
  /// In bn, this message translates to:
  /// **'{km} কিমি · ~{h} ঘণ্টা'**
  String distanceLine(String km, String h);

  /// No description provided for @rowFare.
  ///
  /// In bn, this message translates to:
  /// **'ভাড়া'**
  String get rowFare;

  /// No description provided for @fareSafeLine.
  ///
  /// In bn, this message translates to:
  /// **'{amount} (নিরাপদ লেনদেন)'**
  String fareSafeLine(String amount);

  /// No description provided for @rowCustomer.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহক'**
  String get rowCustomer;

  /// No description provided for @nameVerified.
  ///
  /// In bn, this message translates to:
  /// **'{name} · যাচাইকৃত'**
  String nameVerified(String name);

  /// No description provided for @placeDate.
  ///
  /// In bn, this message translates to:
  /// **'{place} · {date}'**
  String placeDate(String place, String date);

  /// No description provided for @fitsTruck.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ট্রাকে মানানসই: {cap} ধারণক্ষমতা'**
  String fitsTruck(String cap);

  /// No description provided for @tooBigTruck.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ট্রাকের ধারণক্ষমতা {cap} — এই লোড বেশি'**
  String tooBigTruck(String cap);

  /// No description provided for @tonQty.
  ///
  /// In bn, this message translates to:
  /// **'{t} টন'**
  String tonQty(String t);

  /// No description provided for @sendFareOffer.
  ///
  /// In bn, this message translates to:
  /// **'ভাড়ার প্রস্তাব দিন'**
  String get sendFareOffer;

  /// No description provided for @acceptJob.
  ///
  /// In bn, this message translates to:
  /// **'কাজটি গ্রহণ করুন'**
  String get acceptJob;

  /// No description provided for @myBidLine.
  ///
  /// In bn, this message translates to:
  /// **'আপনার প্রস্তাব: {amount} · ক্রেতার উত্তরের অপেক্ষায়'**
  String myBidLine(String amount);

  /// No description provided for @bidSent.
  ///
  /// In bn, this message translates to:
  /// **'প্রস্তাব পাঠানো হয়েছে'**
  String get bidSent;

  /// No description provided for @loadTaken.
  ///
  /// In bn, this message translates to:
  /// **'এই লোড অন্য চালক পেয়েছেন'**
  String get loadTaken;

  /// No description provided for @fareOfferTitle.
  ///
  /// In bn, this message translates to:
  /// **'ভাড়ার প্রস্তাব দিন'**
  String get fareOfferTitle;

  /// No description provided for @suggestedFareRow.
  ///
  /// In bn, this message translates to:
  /// **'প্রস্তাবিত ভাড়া (প্ল্যাটফর্ম)'**
  String get suggestedFareRow;

  /// No description provided for @takaRange.
  ///
  /// In bn, this message translates to:
  /// **'৳ {min}–{max}'**
  String takaRange(String min, String max);

  /// No description provided for @otherBidsRow.
  ///
  /// In bn, this message translates to:
  /// **'অন্য প্রস্তাব'**
  String get otherBidsRow;

  /// No description provided for @otherBidsLine.
  ///
  /// In bn, this message translates to:
  /// **'{n}টি · সর্বনিম্ন {amount}'**
  String otherBidsLine(String n, String amount);

  /// No description provided for @noneYet.
  ///
  /// In bn, this message translates to:
  /// **'এখনো নেই'**
  String get noneYet;

  /// No description provided for @yourFare.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ভাড়া'**
  String get yourFare;

  /// No description provided for @fareNote.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা প্রস্তাব বেছে নিরাপদ লেনদেনে টাকা জমা দিলে কাজ নিশ্চিত হবে। এরপর ভাড়া বদলানো যাবে না।'**
  String get fareNote;

  /// No description provided for @sendProposal.
  ///
  /// In bn, this message translates to:
  /// **'প্রস্তাব পাঠান'**
  String get sendProposal;

  /// No description provided for @errFareInvalid.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক ভাড়া লিখুন'**
  String get errFareInvalid;

  /// No description provided for @myJobsTitle.
  ///
  /// In bn, this message translates to:
  /// **'আমার কাজ'**
  String get myJobsTitle;

  /// No description provided for @jobsToday.
  ///
  /// In bn, this message translates to:
  /// **'আজ'**
  String get jobsToday;

  /// No description provided for @jobsUpcoming.
  ///
  /// In bn, this message translates to:
  /// **'আসন্ন'**
  String get jobsUpcoming;

  /// No description provided for @jobsDone.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন'**
  String get jobsDone;

  /// No description provided for @jobTitle.
  ///
  /// In bn, this message translates to:
  /// **'{no} · {crop} {qty}'**
  String jobTitle(String no, String crop, String qty);

  /// No description provided for @badgeRunning.
  ///
  /// In bn, this message translates to:
  /// **'চলছে'**
  String get badgeRunning;

  /// No description provided for @badgeScheduled.
  ///
  /// In bn, this message translates to:
  /// **'নির্ধারিত'**
  String get badgeScheduled;

  /// No description provided for @badgeDone.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন'**
  String get badgeDone;

  /// No description provided for @noJobs.
  ///
  /// In bn, this message translates to:
  /// **'কোনো কাজ নেই'**
  String get noJobs;

  /// No description provided for @scheduleTitle.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ সূচি'**
  String get scheduleTitle;

  /// No description provided for @rowJob.
  ///
  /// In bn, this message translates to:
  /// **'কাজ'**
  String get rowJob;

  /// No description provided for @rowTotalStops.
  ///
  /// In bn, this message translates to:
  /// **'মোট স্টপ'**
  String get rowTotalStops;

  /// No description provided for @stopsOne.
  ///
  /// In bn, this message translates to:
  /// **'১টি পিকআপ + ১টি ডেলিভারি'**
  String get stopsOne;

  /// No description provided for @pickupOrder.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপের ক্রম'**
  String get pickupOrder;

  /// No description provided for @stopN.
  ///
  /// In bn, this message translates to:
  /// **'{n}. {name}'**
  String stopN(String n, String name);

  /// No description provided for @stopSub.
  ///
  /// In bn, this message translates to:
  /// **'{place} · {qty} · {date}'**
  String stopSub(String place, String qty, String date);

  /// No description provided for @stopDelivery.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি'**
  String get stopDelivery;

  /// No description provided for @seeRoute.
  ///
  /// In bn, this message translates to:
  /// **'রুট দেখুন'**
  String get seeRoute;

  /// No description provided for @tripStatusTitle.
  ///
  /// In bn, this message translates to:
  /// **'ট্রিপের অবস্থা'**
  String get tripStatusTitle;

  /// No description provided for @freeSpaceTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ট্রাকে {t} টন খালি'**
  String freeSpaceTitle(String t);

  /// No description provided for @freeSpaceSub.
  ///
  /// In bn, this message translates to:
  /// **'রুটে লোড আছে · আলাদা ভাড়া'**
  String get freeSpaceSub;

  /// No description provided for @seeLink.
  ///
  /// In bn, this message translates to:
  /// **'দেখুন'**
  String get seeLink;

  /// No description provided for @stepPickupN.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ {n} – {name}'**
  String stepPickupN(String n, String name);

  /// No description provided for @stepLoadedDone.
  ///
  /// In bn, this message translates to:
  /// **'লোড হয়েছে'**
  String get stepLoadedDone;

  /// No description provided for @stepDeliveryTo.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি – {name}'**
  String stepDeliveryTo(String name);

  /// No description provided for @offlineSafeNote.
  ///
  /// In bn, this message translates to:
  /// **'দুর্বল নেটওয়ার্কেও আপডেট সংরক্ষিত থাকে।'**
  String get offlineSafeNote;

  /// No description provided for @tripProblem.
  ///
  /// In bn, this message translates to:
  /// **'ট্রিপে সমস্যা?'**
  String get tripProblem;

  /// No description provided for @startLoading.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপে লোড শুরু করুন'**
  String get startLoading;

  /// No description provided for @loadConfirmTitle.
  ///
  /// In bn, this message translates to:
  /// **'মাল গাড়িতে উঠেছে?'**
  String get loadConfirmTitle;

  /// No description provided for @loadConfirmBody.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত করলে কৃষক টাকা পাবেন এবং ক্রেতাকে জানানো হবে।'**
  String get loadConfirmBody;

  /// No description provided for @yesLoaded.
  ///
  /// In bn, this message translates to:
  /// **'লোড হয়েছে'**
  String get yesLoaded;

  /// No description provided for @deliverNow.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি দিন'**
  String get deliverNow;

  /// No description provided for @tripDoneBtn.
  ///
  /// In bn, this message translates to:
  /// **'ট্রিপ সম্পন্ন'**
  String get tripDoneBtn;

  /// No description provided for @podTitle.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারির প্রমাণ'**
  String get podTitle;

  /// No description provided for @podPhoto.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারির ছবি তুলুন'**
  String get podPhoto;

  /// No description provided for @deliveredQty.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি করা পরিমাণ'**
  String get deliveredQty;

  /// No description provided for @buyerOtp.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহকের OTP'**
  String get buyerOtp;

  /// No description provided for @otpHint4.
  ///
  /// In bn, this message translates to:
  /// **'৪ সংখ্যার কোড'**
  String get otpHint4;

  /// No description provided for @podNote.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা OTP দিলে বা GPS ও ছবিতে ডেলিভারি প্রমাণ হলে সাথে সাথে ভাড়া ছাড়। পরে আটকানো যাবে না।'**
  String get podNote;

  /// No description provided for @podSubmit.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি সম্পন্ন'**
  String get podSubmit;

  /// No description provided for @errOtpWrong.
  ///
  /// In bn, this message translates to:
  /// **'OTP সঠিক নয়'**
  String get errOtpWrong;

  /// No description provided for @errOtp4.
  ///
  /// In bn, this message translates to:
  /// **'৪ সংখ্যার কোড দিন'**
  String get errOtp4;

  /// No description provided for @tripDoneTitle.
  ///
  /// In bn, this message translates to:
  /// **'ট্রিপ সম্পন্ন'**
  String get tripDoneTitle;

  /// No description provided for @tripDoneHeading.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি সম্পন্ন!'**
  String get tripDoneHeading;

  /// No description provided for @tripDoneBody.
  ///
  /// In bn, this message translates to:
  /// **'{amount} আপনার বিকাশে পাঠানো হয়েছে। এই ভাড়া চূড়ান্ত।'**
  String tripDoneBody(String amount);

  /// No description provided for @seeReceipt.
  ///
  /// In bn, this message translates to:
  /// **'রসিদ দেখুন'**
  String get seeReceipt;

  /// No description provided for @receiptSub.
  ///
  /// In bn, this message translates to:
  /// **'{amount} · বিকাশে পাঠানো'**
  String receiptSub(String amount);

  /// No description provided for @rateCustomer.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহককে রেটিং দিন'**
  String get rateCustomer;

  /// No description provided for @nameOrderNo.
  ///
  /// In bn, this message translates to:
  /// **'{name} · {no}'**
  String nameOrderNo(String name, String no);

  /// No description provided for @dontGoEmpty.
  ///
  /// In bn, this message translates to:
  /// **'খালি ফিরবেন না'**
  String get dontGoEmpty;

  /// No description provided for @acceptReturnLoad.
  ///
  /// In bn, this message translates to:
  /// **'ফিরতি লোড গ্রহণ করুন'**
  String get acceptReturnLoad;

  /// No description provided for @seeEarnings.
  ///
  /// In bn, this message translates to:
  /// **'আয় দেখুন'**
  String get seeEarnings;

  /// No description provided for @alreadyRated.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং দেওয়া হয়েছে'**
  String get alreadyRated;

  /// No description provided for @rateTitle.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং দিন'**
  String get rateTitle;

  /// No description provided for @roleCustomer.
  ///
  /// In bn, this message translates to:
  /// **'{name} (গ্রাহক)'**
  String roleCustomer(String name);

  /// No description provided for @justFinishedTrip.
  ///
  /// In bn, this message translates to:
  /// **'সদ্য শেষ হওয়া ট্রিপ'**
  String get justFinishedTrip;

  /// No description provided for @howWasCustomer.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহক কেমন ছিলেন?'**
  String get howWasCustomer;

  /// No description provided for @tagOnTimeLoad.
  ///
  /// In bn, this message translates to:
  /// **'সময়মতো লোড'**
  String get tagOnTimeLoad;

  /// No description provided for @tagCorrectInfo.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক তথ্য'**
  String get tagCorrectInfo;

  /// No description provided for @tagFastPay.
  ///
  /// In bn, this message translates to:
  /// **'দ্রুত পেমেন্ট'**
  String get tagFastPay;

  /// No description provided for @roleFarmerName.
  ///
  /// In bn, this message translates to:
  /// **'{name} (কৃষক)'**
  String roleFarmerName(String name);

  /// No description provided for @howWasSupplier.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহকারী কেমন ছিল?'**
  String get howWasSupplier;

  /// No description provided for @tagGoodQuality.
  ///
  /// In bn, this message translates to:
  /// **'ভালো মান'**
  String get tagGoodQuality;

  /// No description provided for @tagRightWeight.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক ওজন'**
  String get tagRightWeight;

  /// No description provided for @tagOnTime.
  ///
  /// In bn, this message translates to:
  /// **'সময়মতো'**
  String get tagOnTime;

  /// No description provided for @roleDriver.
  ///
  /// In bn, this message translates to:
  /// **'{name} (চালক)'**
  String roleDriver(String name);

  /// No description provided for @rateTransport.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহন রেটিং দিন'**
  String get rateTransport;

  /// No description provided for @commentOptional.
  ///
  /// In bn, this message translates to:
  /// **'মন্তব্য (ঐচ্ছিক)'**
  String get commentOptional;

  /// No description provided for @commentHint.
  ///
  /// In bn, this message translates to:
  /// **'অভিজ্ঞতা লিখুন'**
  String get commentHint;

  /// No description provided for @submit.
  ///
  /// In bn, this message translates to:
  /// **'জমা দিন'**
  String get submit;

  /// No description provided for @errPickStars.
  ///
  /// In bn, this message translates to:
  /// **'স্টার দিয়ে রেটিং দিন'**
  String get errPickStars;

  /// No description provided for @ratingThanks.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং দেওয়ার জন্য ধন্যবাদ'**
  String get ratingThanks;

  /// No description provided for @vehicleTitle.
  ///
  /// In bn, this message translates to:
  /// **'গাড়ি ও ধারণক্ষমতা'**
  String get vehicleTitle;

  /// No description provided for @truckPhoto.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাকের ছবি'**
  String get truckPhoto;

  /// No description provided for @vehicleType.
  ///
  /// In bn, this message translates to:
  /// **'গাড়ির ধরন'**
  String get vehicleType;

  /// No description provided for @regNo.
  ///
  /// In bn, this message translates to:
  /// **'রেজিস্ট্রেশন নম্বর'**
  String get regNo;

  /// No description provided for @regHint.
  ///
  /// In bn, this message translates to:
  /// **'ঢাকা মেট্রো-ট ১২-৩৪৫৬'**
  String get regHint;

  /// No description provided for @baseLocation.
  ///
  /// In bn, this message translates to:
  /// **'বেস লোকেশন (ট্রাক কোথায় থাকে)'**
  String get baseLocation;

  /// No description provided for @maxCapacity.
  ///
  /// In bn, this message translates to:
  /// **'সর্বোচ্চ ধারণক্ষমতা'**
  String get maxCapacity;

  /// No description provided for @tonUnit.
  ///
  /// In bn, this message translates to:
  /// **'টন'**
  String get tonUnit;

  /// No description provided for @preferredRoute.
  ///
  /// In bn, this message translates to:
  /// **'পছন্দের রুট'**
  String get preferredRoute;

  /// No description provided for @vt_pickup.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ ভ্যান'**
  String get vt_pickup;

  /// No description provided for @vt_small_open.
  ///
  /// In bn, this message translates to:
  /// **'ছোট ট্রাক (খোলা)'**
  String get vt_small_open;

  /// No description provided for @vt_medium_open.
  ///
  /// In bn, this message translates to:
  /// **'মাঝারি ট্রাক (খোলা)'**
  String get vt_medium_open;

  /// No description provided for @vt_medium_covered.
  ///
  /// In bn, this message translates to:
  /// **'মাঝারি ট্রাক (ঢাকা)'**
  String get vt_medium_covered;

  /// No description provided for @vt_large_open.
  ///
  /// In bn, this message translates to:
  /// **'বড় ট্রাক (খোলা)'**
  String get vt_large_open;

  /// No description provided for @vt_covered_van.
  ///
  /// In bn, this message translates to:
  /// **'কাভার্ড ভ্যান'**
  String get vt_covered_van;

  /// No description provided for @vt_refrigerated.
  ///
  /// In bn, this message translates to:
  /// **'রেফ্রিজারেটেড ভ্যান'**
  String get vt_refrigerated;

  /// No description provided for @successTitle.
  ///
  /// In bn, this message translates to:
  /// **'সফল হয়েছে!'**
  String get successTitle;

  /// No description provided for @successBody.
  ///
  /// In bn, this message translates to:
  /// **'আপনার কাজটি সফলভাবে সম্পন্ন হয়েছে।'**
  String get successBody;

  /// No description provided for @okBtn.
  ///
  /// In bn, this message translates to:
  /// **'ঠিক আছে'**
  String get okBtn;

  /// No description provided for @transportTitle.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহন'**
  String get transportTitle;

  /// No description provided for @tabBooked.
  ///
  /// In bn, this message translates to:
  /// **'বুক করা'**
  String get tabBooked;

  /// No description provided for @tabDone.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন'**
  String get tabDone;

  /// No description provided for @noOrderCrop.
  ///
  /// In bn, this message translates to:
  /// **'{no} · {crop}'**
  String noOrderCrop(String no, String crop);

  /// No description provided for @dsOpen.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক খোঁজা হচ্ছে'**
  String get dsOpen;

  /// No description provided for @dsAssigned.
  ///
  /// In bn, this message translates to:
  /// **'নির্ধারিত'**
  String get dsAssigned;

  /// No description provided for @dsPickedUp.
  ///
  /// In bn, this message translates to:
  /// **'পথে'**
  String get dsPickedUp;

  /// No description provided for @dsDelivered.
  ///
  /// In bn, this message translates to:
  /// **'পৌঁছেছে'**
  String get dsDelivered;

  /// No description provided for @nameStatus.
  ///
  /// In bn, this message translates to:
  /// **'{name} · {status}'**
  String nameStatus(String name, String status);

  /// No description provided for @bidsCountLine.
  ///
  /// In bn, this message translates to:
  /// **'{n}টি প্রস্তাব'**
  String bidsCountLine(String n);

  /// No description provided for @bookTruckBtn.
  ///
  /// In bn, this message translates to:
  /// **'+ ট্রাক বুক করুন'**
  String get bookTruckBtn;

  /// No description provided for @noTruckNeeded.
  ///
  /// In bn, this message translates to:
  /// **'সব অর্ডারে ট্রাক বুক করা আছে'**
  String get noTruckNeeded;

  /// No description provided for @noTransport.
  ///
  /// In bn, this message translates to:
  /// **'কোনো পরিবহন নেই'**
  String get noTransport;

  /// No description provided for @bookTruckTitle.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক বুক করুন'**
  String get bookTruckTitle;

  /// No description provided for @pickupLocation.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ লোকেশন'**
  String get pickupLocation;

  /// No description provided for @goodsWeight.
  ///
  /// In bn, this message translates to:
  /// **'মালামাল ও ওজন'**
  String get goodsWeight;

  /// No description provided for @dateLabel.
  ///
  /// In bn, this message translates to:
  /// **'তারিখ'**
  String get dateLabel;

  /// No description provided for @suggestedTrucks.
  ///
  /// In bn, this message translates to:
  /// **'প্রস্তাবিত ট্রাক'**
  String get suggestedTrucks;

  /// No description provided for @truckSub.
  ///
  /// In bn, this message translates to:
  /// **'{type} · {cap} · {rating}'**
  String truckSub(String type, String cap, String rating);

  /// No description provided for @waitingBids.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাকচালকদের প্রস্তাবের অপেক্ষায়…'**
  String get waitingBids;

  /// No description provided for @bookBtn.
  ///
  /// In bn, this message translates to:
  /// **'বুক করুন'**
  String get bookBtn;

  /// No description provided for @bookConfirmTitle.
  ///
  /// In bn, this message translates to:
  /// **'{name}-কে বুক করবেন?'**
  String bookConfirmTitle(String name);

  /// No description provided for @bookConfirmBody.
  ///
  /// In bn, this message translates to:
  /// **'ভাড়া {amount} নিরাপদ লেনদেনে জমা থাকবে।'**
  String bookConfirmBody(String amount);

  /// No description provided for @truckBooked.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক বুক হয়েছে'**
  String get truckBooked;

  /// No description provided for @assignedTitle.
  ///
  /// In bn, this message translates to:
  /// **'নির্ধারিত পরিবহন'**
  String get assignedTitle;

  /// No description provided for @verifiedDriverRating.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত চালক · রেটিং {r}'**
  String verifiedDriverRating(String r);

  /// No description provided for @driverRating.
  ///
  /// In bn, this message translates to:
  /// **'চালক · রেটিং {r}'**
  String driverRating(String r);

  /// No description provided for @rowTruck.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক'**
  String get rowTruck;

  /// No description provided for @rowCapacity.
  ///
  /// In bn, this message translates to:
  /// **'ধারণক্ষমতা'**
  String get rowCapacity;

  /// No description provided for @callBtn.
  ///
  /// In bn, this message translates to:
  /// **'কল করুন'**
  String get callBtn;

  /// No description provided for @trackBtn.
  ///
  /// In bn, this message translates to:
  /// **'ট্র্যাক করুন'**
  String get trackBtn;

  /// No description provided for @receiveTitle.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি গ্রহণ'**
  String get receiveTitle;

  /// No description provided for @rowOrder.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার'**
  String get rowOrder;

  /// No description provided for @rowOrdered.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডারকৃত'**
  String get rowOrdered;

  /// No description provided for @rowLoaded.
  ///
  /// In bn, this message translates to:
  /// **'লোডে মাপা'**
  String get rowLoaded;

  /// No description provided for @yourOtp.
  ///
  /// In bn, this message translates to:
  /// **'আপনার OTP: {code}'**
  String yourOtp(String code);

  /// No description provided for @otpNote.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক পৌঁছালে ড্রাইভারকে এই OTP দিন। দিলেই ভাড়া ছাড় হবে।'**
  String get otpNote;

  /// No description provided for @qualityFinalTitle.
  ///
  /// In bn, this message translates to:
  /// **'মান ও পরিমাণ লোডের সময়ই চূড়ান্ত'**
  String get qualityFinalTitle;

  /// No description provided for @qualityFinalBody.
  ///
  /// In bn, this message translates to:
  /// **'লোডের পর মান বা পরিমাণ নিয়ে টাকা ফেরত চাওয়া যাবে না। ডেলিভারি নিশ্চিত করলে ভাড়া ছাড় হবে।'**
  String get qualityFinalBody;

  /// No description provided for @deliveryPhotoOpt.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারির ছবি (ঐচ্ছিক)'**
  String get deliveryPhotoOpt;

  /// No description provided for @otherProblem.
  ///
  /// In bn, this message translates to:
  /// **'অন্য সমস্যা জানান'**
  String get otherProblem;

  /// No description provided for @otpGiven.
  ///
  /// In bn, this message translates to:
  /// **'OTP দিয়েছি'**
  String get otpGiven;

  /// No description provided for @otpWaitDriver.
  ///
  /// In bn, this message translates to:
  /// **'ড্রাইভার OTP দিলে এগোতে পারবেন'**
  String get otpWaitDriver;

  /// No description provided for @orderBookTruck.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক বুক করুন'**
  String get orderBookTruck;

  /// No description provided for @orderReceive.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি গ্রহণ'**
  String get orderReceive;

  /// No description provided for @orderRate.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং দিন'**
  String get orderRate;

  /// No description provided for @handedOver.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য হস্তান্তর করেছি'**
  String get handedOver;

  /// No description provided for @handedOverTitle.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য হস্তান্তর করেছেন?'**
  String get handedOverTitle;

  /// No description provided for @handedOverBody.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার গাড়িতে মাল তোলা হলে নিশ্চিত করুন।'**
  String get handedOverBody;

  /// No description provided for @receivedSelf.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য পেয়েছি'**
  String get receivedSelf;

  /// No description provided for @receivedTitle.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য পেয়েছেন?'**
  String get receivedTitle;

  /// No description provided for @receivedBody.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত করলে কৃষককে জানানো হবে।'**
  String get receivedBody;

  /// No description provided for @yesConfirm.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ, নিশ্চিত'**
  String get yesConfirm;

  /// No description provided for @nBidNew.
  ///
  /// In bn, this message translates to:
  /// **'নতুন ভাড়ার প্রস্তাব: {no}'**
  String nBidNew(String no);

  /// No description provided for @nBidNewBody.
  ///
  /// In bn, this message translates to:
  /// **'{name} · {amount}'**
  String nBidNewBody(String name, String amount);

  /// No description provided for @nJobAssigned.
  ///
  /// In bn, this message translates to:
  /// **'আপনি কাজ পেয়েছেন: {no}'**
  String nJobAssigned(String no);

  /// No description provided for @nTripPicked.
  ///
  /// In bn, this message translates to:
  /// **'মাল গাড়িতে উঠেছে: {no}'**
  String nTripPicked(String no);

  /// No description provided for @nTripDelivered.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি সম্পন্ন: {no}'**
  String nTripDelivered(String no);

  /// No description provided for @reportTitle.
  ///
  /// In bn, this message translates to:
  /// **'সমস্যা জানান'**
  String get reportTitle;

  /// No description provided for @reportGeneralTitle.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বা ট্রিপ'**
  String get reportGeneralTitle;

  /// No description provided for @reportGeneralSub.
  ///
  /// In bn, this message translates to:
  /// **'যে কাজ নিয়ে সমস্যা হয়েছে'**
  String get reportGeneralSub;

  /// No description provided for @reportWhat.
  ///
  /// In bn, this message translates to:
  /// **'কী সমস্যা হয়েছে?'**
  String get reportWhat;

  /// No description provided for @reason_driver_behavior.
  ///
  /// In bn, this message translates to:
  /// **'চালকের আচরণ'**
  String get reason_driver_behavior;

  /// No description provided for @reason_late_delivery.
  ///
  /// In bn, this message translates to:
  /// **'দেরিতে ডেলিভারি'**
  String get reason_late_delivery;

  /// No description provided for @reason_app_problem.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাপে সমস্যা'**
  String get reason_app_problem;

  /// No description provided for @reason_other.
  ///
  /// In bn, this message translates to:
  /// **'অন্যান্য'**
  String get reason_other;

  /// No description provided for @reportPhoto.
  ///
  /// In bn, this message translates to:
  /// **'ছবি দিন (ঐচ্ছিক)'**
  String get reportPhoto;

  /// No description provided for @reportDetails.
  ///
  /// In bn, this message translates to:
  /// **'বিস্তারিত (ঐচ্ছিক)'**
  String get reportDetails;

  /// No description provided for @reportDetailsHint.
  ///
  /// In bn, this message translates to:
  /// **'লিখুন বা ভয়েস রেকর্ড করুন'**
  String get reportDetailsHint;

  /// No description provided for @reportNote.
  ///
  /// In bn, this message translates to:
  /// **'কী হয়েছে লিখুন বা ভয়েসে বলুন। আমরা ২৪ ঘণ্টার মধ্যে উত্তর দেব। অভিযোগ করলে পেমেন্টের নিয়ম বদলায় না।'**
  String get reportNote;

  /// No description provided for @reportSubmit.
  ///
  /// In bn, this message translates to:
  /// **'অভিযোগ জমা দিন'**
  String get reportSubmit;

  /// No description provided for @reportSent.
  ///
  /// In bn, this message translates to:
  /// **'অভিযোগ জমা হয়েছে'**
  String get reportSent;

  /// No description provided for @errPickReason.
  ///
  /// In bn, this message translates to:
  /// **'সমস্যার ধরন বেছে নিন'**
  String get errPickReason;

  /// No description provided for @safePayTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেন'**
  String get safePayTitle;

  /// No description provided for @safePayExplain.
  ///
  /// In bn, this message translates to:
  /// **'মাল গাড়িতে উঠলে কৃষক, আর আপনার কাছে পৌঁছালে ট্রান্সপোর্টার নিরাপদ লেনদেন থেকে টাকা পাবেন। ১% ফি শুধু ক্রেতা দেবেন, লোড হলে কাটা হবে। ট্রাক রওনার আগে অর্ডার বাতিল করলে ভাড়ার ১০% কাটা যাবে, বাকি সব গোলাঘর থেকে ফেরত পাবেন। এরপর লোড বাতিল হলে ফসলের দাম ও ফি ফেরত পাবেন, ভাড়া নয়।'**
  String get safePayExplain;

  /// No description provided for @payBank.
  ///
  /// In bn, this message translates to:
  /// **'ব্যাংক ট্রান্সফার'**
  String get payBank;

  /// No description provided for @payBkash.
  ///
  /// In bn, this message translates to:
  /// **'বিকাশ / নগদ'**
  String get payBkash;

  /// No description provided for @payDemoSub.
  ///
  /// In bn, this message translates to:
  /// **'ডেমো — আসল টাকা কাটা হবে না'**
  String get payDemoSub;

  /// No description provided for @payAddMethod.
  ///
  /// In bn, this message translates to:
  /// **'অন্য মাধ্যম যোগ করুন'**
  String get payAddMethod;

  /// No description provided for @payAddMethodSub.
  ///
  /// In bn, this message translates to:
  /// **'বিকাশ, নগদ, রকেট বা ব্যাংক'**
  String get payAddMethodSub;

  /// No description provided for @payNow.
  ///
  /// In bn, this message translates to:
  /// **'{amount} পরিশোধ করুন'**
  String payNow(String amount);

  /// No description provided for @orderLine.
  ///
  /// In bn, this message translates to:
  /// **'{no} · {crop}'**
  String orderLine(String no, String crop);

  /// No description provided for @newOrderLabel.
  ///
  /// In bn, this message translates to:
  /// **'নতুন অর্ডার'**
  String get newOrderLabel;

  /// No description provided for @modStatReports.
  ///
  /// In bn, this message translates to:
  /// **'খোলা অভিযোগ'**
  String get modStatReports;

  /// No description provided for @modStatVerify.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই বাকি'**
  String get modStatVerify;

  /// No description provided for @modReportsTitle.
  ///
  /// In bn, this message translates to:
  /// **'অভিযোগ'**
  String get modReportsTitle;

  /// No description provided for @rs_open.
  ///
  /// In bn, this message translates to:
  /// **'নতুন'**
  String get rs_open;

  /// No description provided for @rs_inReview.
  ///
  /// In bn, this message translates to:
  /// **'পর্যালোচনায়'**
  String get rs_inReview;

  /// No description provided for @rs_resolved.
  ///
  /// In bn, this message translates to:
  /// **'সমাধান'**
  String get rs_resolved;

  /// No description provided for @rs_dismissed.
  ///
  /// In bn, this message translates to:
  /// **'খারিজ'**
  String get rs_dismissed;

  /// No description provided for @noReports.
  ///
  /// In bn, this message translates to:
  /// **'কোনো অভিযোগ নেই'**
  String get noReports;

  /// No description provided for @reportDetailTitle.
  ///
  /// In bn, this message translates to:
  /// **'অভিযোগের বিবরণ'**
  String get reportDetailTitle;

  /// No description provided for @rowReason.
  ///
  /// In bn, this message translates to:
  /// **'সমস্যা'**
  String get rowReason;

  /// No description provided for @rowReporter.
  ///
  /// In bn, this message translates to:
  /// **'অভিযোগকারী'**
  String get rowReporter;

  /// No description provided for @rowDate.
  ///
  /// In bn, this message translates to:
  /// **'তারিখ'**
  String get rowDate;

  /// No description provided for @rowDetails.
  ///
  /// In bn, this message translates to:
  /// **'বিস্তারিত'**
  String get rowDetails;

  /// No description provided for @rowModNote.
  ///
  /// In bn, this message translates to:
  /// **'মডারেটরের বার্তা'**
  String get rowModNote;

  /// No description provided for @nameRole.
  ///
  /// In bn, this message translates to:
  /// **'{name} ({role})'**
  String nameRole(String name, String role);

  /// No description provided for @startReview.
  ///
  /// In bn, this message translates to:
  /// **'পর্যালোচনা শুরু করুন'**
  String get startReview;

  /// No description provided for @resolveReport.
  ///
  /// In bn, this message translates to:
  /// **'সমাধান হয়েছে'**
  String get resolveReport;

  /// No description provided for @dismissReport.
  ///
  /// In bn, this message translates to:
  /// **'খারিজ করুন'**
  String get dismissReport;

  /// No description provided for @escalateReport.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাডমিনকে জানান'**
  String get escalateReport;

  /// No description provided for @escalatedBadge.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাডমিনকে জানানো হয়েছে'**
  String get escalatedBadge;

  /// No description provided for @noteSheetTitle.
  ///
  /// In bn, this message translates to:
  /// **'অভিযোগকারীকে বার্তা (ঐচ্ছিক)'**
  String get noteSheetTitle;

  /// No description provided for @noteHint.
  ///
  /// In bn, this message translates to:
  /// **'কী ব্যবস্থা নেওয়া হলো লিখুন'**
  String get noteHint;

  /// No description provided for @sendBtn.
  ///
  /// In bn, this message translates to:
  /// **'পাঠান'**
  String get sendBtn;

  /// No description provided for @doneToast.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন হয়েছে'**
  String get doneToast;

  /// No description provided for @verifyTitle.
  ///
  /// In bn, this message translates to:
  /// **'পরিচয় যাচাই'**
  String get verifyTitle;

  /// No description provided for @verifyEmpty.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইয়ের অপেক্ষায় কেউ নেই'**
  String get verifyEmpty;

  /// No description provided for @rowNid.
  ///
  /// In bn, this message translates to:
  /// **'NID নম্বর'**
  String get rowNid;

  /// No description provided for @rowJoined.
  ///
  /// In bn, this message translates to:
  /// **'যোগদান'**
  String get rowJoined;

  /// No description provided for @verifyApprove.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই করুন'**
  String get verifyApprove;

  /// No description provided for @verifyRejectBtn.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাখ্যান'**
  String get verifyRejectBtn;

  /// No description provided for @verifyRejectTitle.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই প্রত্যাখ্যান করবেন?'**
  String get verifyRejectTitle;

  /// No description provided for @verifyRejectBody.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবহারকারীকে আবার সঠিক NID দিতে বলা হবে।'**
  String get verifyRejectBody;

  /// No description provided for @nameRolePhone.
  ///
  /// In bn, this message translates to:
  /// **'{role} · {phone}'**
  String nameRolePhone(String role, String phone);

  /// No description provided for @nVerifyOk.
  ///
  /// In bn, this message translates to:
  /// **'আপনার পরিচয় যাচাই হয়েছে'**
  String get nVerifyOk;

  /// No description provided for @nVerifyOkBody.
  ///
  /// In bn, this message translates to:
  /// **'এখন আপনার প্রোফাইলে যাচাইকৃত চিহ্ন দেখাবে।'**
  String get nVerifyOkBody;

  /// No description provided for @nVerifyRejected.
  ///
  /// In bn, this message translates to:
  /// **'পরিচয় যাচাই হয়নি'**
  String get nVerifyRejected;

  /// No description provided for @nVerifyRejectedBody.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক NID নম্বর দিয়ে আবার চেষ্টা করুন।'**
  String get nVerifyRejectedBody;

  /// No description provided for @nReportResolved.
  ///
  /// In bn, this message translates to:
  /// **'আপনার অভিযোগের সমাধান হয়েছে'**
  String get nReportResolved;

  /// No description provided for @nReportDismissed.
  ///
  /// In bn, this message translates to:
  /// **'আপনার অভিযোগ খারিজ হয়েছে'**
  String get nReportDismissed;

  /// No description provided for @navUsers.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবহারকারী'**
  String get navUsers;

  /// No description provided for @navModeration.
  ///
  /// In bn, this message translates to:
  /// **'মডারেশন'**
  String get navModeration;

  /// No description provided for @navPrices.
  ///
  /// In bn, this message translates to:
  /// **'দাম'**
  String get navPrices;

  /// No description provided for @adminUsersSection.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবহারকারী'**
  String get adminUsersSection;

  /// No description provided for @statTotalUsers.
  ///
  /// In bn, this message translates to:
  /// **'মোট ব্যবহারকারী'**
  String get statTotalUsers;

  /// No description provided for @adminListingsSection.
  ///
  /// In bn, this message translates to:
  /// **'তালিকা'**
  String get adminListingsSection;

  /// No description provided for @adminOrdersSection.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার ও অভিযোগ'**
  String get adminOrdersSection;

  /// No description provided for @statCompletedOrders.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন অর্ডার'**
  String get statCompletedOrders;

  /// No description provided for @usersTitle.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবহারকারী'**
  String get usersTitle;

  /// No description provided for @userSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'নাম বা মোবাইল নম্বর খুঁজুন'**
  String get userSearchHint;

  /// No description provided for @noUsers.
  ///
  /// In bn, this message translates to:
  /// **'কেউ পাওয়া যায়নি'**
  String get noUsers;

  /// No description provided for @noRoleYet.
  ///
  /// In bn, this message translates to:
  /// **'ভূমিকা নেই'**
  String get noRoleYet;

  /// No description provided for @suspendedBadge.
  ///
  /// In bn, this message translates to:
  /// **'স্থগিত'**
  String get suspendedBadge;

  /// No description provided for @userDetailTitle.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবহারকারীর বিবরণ'**
  String get userDetailTitle;

  /// No description provided for @statusActiveUser.
  ///
  /// In bn, this message translates to:
  /// **'সক্রিয়'**
  String get statusActiveUser;

  /// No description provided for @rowVerification.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই'**
  String get rowVerification;

  /// No description provided for @vNone.
  ///
  /// In bn, this message translates to:
  /// **'করা হয়নি'**
  String get vNone;

  /// No description provided for @vPending.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষায়'**
  String get vPending;

  /// No description provided for @vVerified.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত'**
  String get vVerified;

  /// No description provided for @vRejected.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাখ্যাত'**
  String get vRejected;

  /// No description provided for @rowRating.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং'**
  String get rowRating;

  /// No description provided for @ratingLine.
  ///
  /// In bn, this message translates to:
  /// **'{avg} ({n}টি রেটিং)'**
  String ratingLine(String avg, String n);

  /// No description provided for @suspendUser.
  ///
  /// In bn, this message translates to:
  /// **'স্থগিত করুন'**
  String get suspendUser;

  /// No description provided for @activateUser.
  ///
  /// In bn, this message translates to:
  /// **'সক্রিয় করুন'**
  String get activateUser;

  /// No description provided for @suspendTitle.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবহারকারী স্থগিত করবেন?'**
  String get suspendTitle;

  /// No description provided for @suspendBody.
  ///
  /// In bn, this message translates to:
  /// **'স্থগিত থাকলে তিনি নতুন তালিকা, অফার বা অর্ডার করতে পারবেন না।'**
  String get suspendBody;

  /// No description provided for @changeRole.
  ///
  /// In bn, this message translates to:
  /// **'ভূমিকা পরিবর্তন'**
  String get changeRole;

  /// No description provided for @roleChanged.
  ///
  /// In bn, this message translates to:
  /// **'ভূমিকা পরিবর্তন হয়েছে'**
  String get roleChanged;

  /// No description provided for @cantEditSelf.
  ///
  /// In bn, this message translates to:
  /// **'নিজের অ্যাকাউন্ট এখানে বদলানো যাবে না'**
  String get cantEditSelf;

  /// No description provided for @moderationTitle.
  ///
  /// In bn, this message translates to:
  /// **'মডারেশন'**
  String get moderationTitle;

  /// No description provided for @pricesTitle.
  ///
  /// In bn, this message translates to:
  /// **'বাজার দর'**
  String get pricesTitle;

  /// No description provided for @priceSub.
  ///
  /// In bn, this message translates to:
  /// **'আজ ৳ {price}/কেজি · ৳ {min}–{max}'**
  String priceSub(String price, String min, String max);

  /// No description provided for @noPrice.
  ///
  /// In bn, this message translates to:
  /// **'দাম দেওয়া হয়নি'**
  String get noPrice;

  /// No description provided for @fieldTodayPrice.
  ///
  /// In bn, this message translates to:
  /// **'আজকের দাম'**
  String get fieldTodayPrice;

  /// No description provided for @fieldMinPrice.
  ///
  /// In bn, this message translates to:
  /// **'সর্বনিম্ন দাম'**
  String get fieldMinPrice;

  /// No description provided for @fieldMaxPrice.
  ///
  /// In bn, this message translates to:
  /// **'সর্বোচ্চ দাম'**
  String get fieldMaxPrice;

  /// No description provided for @priceSaved.
  ///
  /// In bn, this message translates to:
  /// **'দাম সংরক্ষণ হয়েছে'**
  String get priceSaved;

  /// No description provided for @errPriceRange.
  ///
  /// In bn, this message translates to:
  /// **'সর্বনিম্ন ≤ আজকের দাম ≤ সর্বোচ্চ হতে হবে'**
  String get errPriceRange;

  /// No description provided for @cropsTitle.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের তালিকা'**
  String get cropsTitle;

  /// No description provided for @addCrop.
  ///
  /// In bn, this message translates to:
  /// **'+ নতুন ফসল'**
  String get addCrop;

  /// No description provided for @cropNameBn.
  ///
  /// In bn, this message translates to:
  /// **'নাম (বাংলা)'**
  String get cropNameBn;

  /// No description provided for @cropNameEn.
  ///
  /// In bn, this message translates to:
  /// **'নাম (English)'**
  String get cropNameEn;

  /// No description provided for @cropCategory.
  ///
  /// In bn, this message translates to:
  /// **'ধরন'**
  String get cropCategory;

  /// No description provided for @catOther.
  ///
  /// In bn, this message translates to:
  /// **'অন্যান্য'**
  String get catOther;

  /// No description provided for @cropOn.
  ///
  /// In bn, this message translates to:
  /// **'চালু'**
  String get cropOn;

  /// No description provided for @cropOff.
  ///
  /// In bn, this message translates to:
  /// **'বন্ধ'**
  String get cropOff;

  /// No description provided for @customCrop.
  ///
  /// In bn, this message translates to:
  /// **'নতুন যোগ করা'**
  String get customCrop;

  /// No description provided for @cropSaved.
  ///
  /// In bn, this message translates to:
  /// **'সংরক্ষণ হয়েছে'**
  String get cropSaved;

  /// No description provided for @cropsSub.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রির তালিকায় কোন ফসল দেখাবে'**
  String get cropsSub;

  /// No description provided for @pricesSub.
  ///
  /// In bn, this message translates to:
  /// **'প্রতিদিনের বাজার দর দিন'**
  String get pricesSub;

  /// No description provided for @verifiedBadge.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত'**
  String get verifiedBadge;

  /// No description provided for @roleDistrict.
  ///
  /// In bn, this message translates to:
  /// **'{role} · {district}'**
  String roleDistrict(String role, String district);

  /// No description provided for @ratingShort.
  ///
  /// In bn, this message translates to:
  /// **'{avg} ({n})'**
  String ratingShort(String avg, String n);

  /// No description provided for @statDoneDeals.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন লেনদেন'**
  String get statDoneDeals;

  /// No description provided for @statTotalOrders.
  ///
  /// In bn, this message translates to:
  /// **'মোট অর্ডার'**
  String get statTotalOrders;

  /// No description provided for @statDoneTrips.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন ট্রিপ'**
  String get statDoneTrips;

  /// No description provided for @shareTrack.
  ///
  /// In bn, this message translates to:
  /// **'আমার ট্র্যাক রেকর্ড শেয়ার করুন'**
  String get shareTrack;

  /// No description provided for @shareTrackSub.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত সারাংশ · QR ও লিংক'**
  String get shareTrackSub;

  /// No description provided for @shareLink.
  ///
  /// In bn, this message translates to:
  /// **'শেয়ার'**
  String get shareLink;

  /// No description provided for @rowNidVerify.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকরণ (NID)'**
  String get rowNidVerify;

  /// No description provided for @rowBizVerify.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবসা যাচাইকরণ'**
  String get rowBizVerify;

  /// No description provided for @rowVerifyRating.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকরণ ও রেটিং'**
  String get rowVerifyRating;

  /// No description provided for @verifyDone.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই সম্পন্ন'**
  String get verifyDone;

  /// No description provided for @verifyPendingSub.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইয়ের অপেক্ষায়'**
  String get verifyPendingSub;

  /// No description provided for @verifyNoneSub.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই করা হয়নি'**
  String get verifyNoneSub;

  /// No description provided for @verifyRejectedSub.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই হয়নি — আবার চেষ্টা করুন'**
  String get verifyRejectedSub;

  /// No description provided for @rowMyRatings.
  ///
  /// In bn, this message translates to:
  /// **'আমার রেটিং ও রিভিউ'**
  String get rowMyRatings;

  /// No description provided for @rowRatings.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং ও রিভিউ'**
  String get rowRatings;

  /// No description provided for @profileReviews.
  ///
  /// In bn, this message translates to:
  /// **'{n}টি রিভিউ'**
  String profileReviews(String n);

  /// No description provided for @rowMyContracts.
  ///
  /// In bn, this message translates to:
  /// **'আমার চুক্তি'**
  String get rowMyContracts;

  /// No description provided for @rowContracts.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি'**
  String get rowContracts;

  /// No description provided for @rowPayMethod.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট মাধ্যম'**
  String get rowPayMethod;

  /// No description provided for @rowPayAccount.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট অ্যাকাউন্ট'**
  String get rowPayAccount;

  /// No description provided for @rowLanguage.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা / Language'**
  String get rowLanguage;

  /// No description provided for @languageSub.
  ///
  /// In bn, this message translates to:
  /// **'{lang} · চাপলে ভাষা পরিবর্তনের অপশন খুলবে'**
  String languageSub(String lang);

  /// No description provided for @rowHelp.
  ///
  /// In bn, this message translates to:
  /// **'সাহায্য'**
  String get rowHelp;

  /// No description provided for @helpSub.
  ///
  /// In bn, this message translates to:
  /// **'ভয়েস গাইড, হেল্পলাইন'**
  String get helpSub;

  /// No description provided for @logoutTitle.
  ///
  /// In bn, this message translates to:
  /// **'লগআউট করবেন?'**
  String get logoutTitle;

  /// No description provided for @logoutBody.
  ///
  /// In bn, this message translates to:
  /// **'আবার ঢুকতে মোবাইল নম্বর ও OTP লাগবে। আপনার লেনদেনের ইতিহাস সংরক্ষিত থাকবে।'**
  String get logoutBody;

  /// No description provided for @langSheetTitle.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা পরিবর্তন / Change language'**
  String get langSheetTitle;

  /// No description provided for @langBnSub.
  ///
  /// In bn, this message translates to:
  /// **'Bangla'**
  String get langBnSub;

  /// No description provided for @langEnSub.
  ///
  /// In bn, this message translates to:
  /// **'ইংরেজি'**
  String get langEnSub;

  /// No description provided for @langSheetNote.
  ///
  /// In bn, this message translates to:
  /// **'পরে প্রোফাইল থেকে আবার ভাষা বদলাতে পারবেন।'**
  String get langSheetNote;

  /// No description provided for @loginTermsPre.
  ///
  /// In bn, this message translates to:
  /// **'চালিয়ে গেলে আপনি '**
  String get loginTermsPre;

  /// No description provided for @loginTermsLink.
  ///
  /// In bn, this message translates to:
  /// **'শর্তাবলী ও গোপনীয়তা নীতিতে'**
  String get loginTermsLink;

  /// No description provided for @loginTermsPost.
  ///
  /// In bn, this message translates to:
  /// **' সম্মত হচ্ছেন।'**
  String get loginTermsPost;

  /// No description provided for @termsTitle.
  ///
  /// In bn, this message translates to:
  /// **'শর্তাবলী ও গোপনীয়তা নীতি'**
  String get termsTitle;

  /// No description provided for @termsUpdated.
  ///
  /// In bn, this message translates to:
  /// **'সর্বশেষ হালনাগাদ: নভেম্বর ২০২৬'**
  String get termsUpdated;

  /// No description provided for @termsS1Title.
  ///
  /// In bn, this message translates to:
  /// **'১. গোলাঘর কী'**
  String get termsS1Title;

  /// No description provided for @termsS1Body.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর কৃষক, ক্রেতা ও পরিবহনকারীকে সরাসরি যুক্ত করে, যাতে মধ্যস্বত্বভোগী ছাড়াই ন্যায্য দামে ফসল কেনা-বেচা হয়। মোবাইল নম্বর ও OTP দিয়ে অ্যাকাউন্ট খুলতে হয়; একটি নম্বরে একটি অ্যাকাউন্ট।'**
  String get termsS1Body;

  /// No description provided for @termsS2Title.
  ///
  /// In bn, this message translates to:
  /// **'২. তালিকা ও মডারেশন'**
  String get termsS2Title;

  /// No description provided for @termsS2Body.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক সঠিক ফসল, মান, পরিমাণ, দাম ও ছবি দেবেন। মডারেটর অনুমোদনের পরই তালিকা ক্রেতারা দেখতে পান। ভুল বা প্রতারণামূলক তালিকা লুকানো হতে পারে এবং বারবার হলে অ্যাকাউন্ট স্থগিত হতে পারে।'**
  String get termsS2Body;

  /// No description provided for @termsS3Title.
  ///
  /// In bn, this message translates to:
  /// **'৩. নিরাপদ লেনদেন ও ফি'**
  String get termsS3Title;

  /// No description provided for @termsS3Body.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার টাকা নিরাপদ লেনদেনে জমা থাকে। মাল গাড়িতে উঠলে কৃষক এবং ডেলিভারি OTP দিলে পরিবহনকারী টাকা পান। ১% প্ল্যাটফর্ম ফি শুধু ক্রেতা দেন। মান ও পরিমাণ লোডের সময়ই চূড়ান্ত হয়।'**
  String get termsS3Body;

  /// No description provided for @termsS4Title.
  ///
  /// In bn, this message translates to:
  /// **'৪. বাতিল ও ফেরত'**
  String get termsS4Title;

  /// No description provided for @termsS4Body.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক রওনার আগে অর্ডার বাতিল করলে ভাড়ার ১০% কাটা যাবে, বাকি টাকা ফেরত পাবেন। এরপর লোড বাতিল হলে ফসলের দাম ও ফি ফেরত পাবেন, ভাড়া নয়। সমস্যা হলে অ্যাপ থেকে অভিযোগ করুন; আমরা ২৪ ঘণ্টার মধ্যে উত্তর দিই।'**
  String get termsS4Body;

  /// No description provided for @termsS5Title.
  ///
  /// In bn, this message translates to:
  /// **'৫. পরিবহন ও ডেলিভারি'**
  String get termsS5Title;

  /// No description provided for @termsS5Body.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহনকারী সঠিক গাড়ির তথ্য দেবেন এবং ক্রেতার OTP ছাড়া ডেলিভারি সম্পন্ন দেখাবেন না। ক্রেতা ট্রাক পৌঁছালে তবেই OTP দেবেন।'**
  String get termsS5Body;

  /// No description provided for @termsS6Title.
  ///
  /// In bn, this message translates to:
  /// **'৬. আপনার তথ্য'**
  String get termsS6Title;

  /// No description provided for @termsS6Body.
  ///
  /// In bn, this message translates to:
  /// **'আমরা নাম, মোবাইল নম্বর, ঠিকানা, ছবি, NID নম্বর (ঐচ্ছিক) ও লেনদেনের তথ্য রাখি শুধু অ্যাপ চালাতে, যাচাই করতে ও বিরোধ মেটাতে। ব্যবসার অংশীদার শুধু প্রয়োজনীয় তথ্য (নাম, এলাকা, রেটিং) দেখেন। আমরা আপনার তথ্য বিক্রি করি না।'**
  String get termsS6Body;

  /// No description provided for @termsS7Title.
  ///
  /// In bn, this message translates to:
  /// **'৭. আচরণ ও রেটিং'**
  String get termsS7Title;

  /// No description provided for @termsS7Body.
  ///
  /// In bn, this message translates to:
  /// **'সব ব্যবহারকারী সৎ ও সম্মানজনক আচরণ করবেন। প্রতিটি লেনদেনের পর রেটিং দেওয়া যায়; ভুয়া রেটিং বা হয়রানি করলে অ্যাকাউন্ট স্থগিত হতে পারে।'**
  String get termsS7Body;

  /// No description provided for @mpTitle.
  ///
  /// In bn, this message translates to:
  /// **'বাজার দর'**
  String get mpTitle;

  /// No description provided for @mpSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'ফসল খুঁজুন'**
  String get mpSearchHint;

  /// No description provided for @mpWholesale.
  ///
  /// In bn, this message translates to:
  /// **'পাইকারি বাজার দর'**
  String get mpWholesale;

  /// No description provided for @mpUpdated.
  ///
  /// In bn, this message translates to:
  /// **'আপডেট: {when}'**
  String mpUpdated(String when);

  /// No description provided for @pctChange.
  ///
  /// In bn, this message translates to:
  /// **'{sign}{pct}%'**
  String pctChange(String sign, String pct);

  /// No description provided for @mpEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এখনো দাম দেওয়া হয়নি'**
  String get mpEmpty;

  /// No description provided for @trendTitle.
  ///
  /// In bn, this message translates to:
  /// **'{crop} – দামের প্রবণতা'**
  String trendTitle(String crop);

  /// No description provided for @period7.
  ///
  /// In bn, this message translates to:
  /// **'৭ দিন'**
  String get period7;

  /// No description provided for @period30.
  ///
  /// In bn, this message translates to:
  /// **'৩০ দিন'**
  String get period30;

  /// No description provided for @period90.
  ///
  /// In bn, this message translates to:
  /// **'৩ মাস'**
  String get period90;

  /// No description provided for @sinceWeek.
  ///
  /// In bn, this message translates to:
  /// **'গত সপ্তাহ থেকে {pct}'**
  String sinceWeek(String pct);

  /// No description provided for @sinceMonth.
  ///
  /// In bn, this message translates to:
  /// **'গত মাস থেকে {pct}'**
  String sinceMonth(String pct);

  /// No description provided for @since3Months.
  ///
  /// In bn, this message translates to:
  /// **'৩ মাস আগে থেকে {pct}'**
  String since3Months(String pct);

  /// No description provided for @rowHighest.
  ///
  /// In bn, this message translates to:
  /// **'সর্বোচ্চ'**
  String get rowHighest;

  /// No description provided for @rowLowest.
  ///
  /// In bn, this message translates to:
  /// **'সর্বনিম্ন'**
  String get rowLowest;

  /// No description provided for @rowAverage.
  ///
  /// In bn, this message translates to:
  /// **'গড়'**
  String get rowAverage;

  /// No description provided for @priceAlert.
  ///
  /// In bn, this message translates to:
  /// **'দাম এলার্ট সেট করুন ({price} হলে জানাবে)'**
  String priceAlert(String price);

  /// No description provided for @sellAtPrice.
  ///
  /// In bn, this message translates to:
  /// **'এই দামে ফসল বিক্রি করুন'**
  String get sellAtPrice;

  /// No description provided for @findInMarket.
  ///
  /// In bn, this message translates to:
  /// **'বাজারে খুঁজুন'**
  String get findInMarket;

  /// No description provided for @trendNoData.
  ///
  /// In bn, this message translates to:
  /// **'এই সময়ের দামের তথ্য এখনো নেই'**
  String get trendNoData;

  /// No description provided for @payTitle.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট'**
  String get payTitle;

  /// No description provided for @payHeldFarmer.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে জমা'**
  String get payHeldFarmer;

  /// No description provided for @payReceivedMonth.
  ///
  /// In bn, this message translates to:
  /// **'এ মাসে পেয়েছেন'**
  String get payReceivedMonth;

  /// No description provided for @payHeldBuyer.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে'**
  String get payHeldBuyer;

  /// No description provided for @payPaidMonth.
  ///
  /// In bn, this message translates to:
  /// **'এ মাসে পরিশোধ'**
  String get payPaidMonth;

  /// No description provided for @payReceiveMethod.
  ///
  /// In bn, this message translates to:
  /// **'টাকা গ্রহণের মাধ্যম'**
  String get payReceiveMethod;

  /// No description provided for @payMethodSub.
  ///
  /// In bn, this message translates to:
  /// **'বিকাশ · {phone}'**
  String payMethodSub(String phone);

  /// No description provided for @changeLink.
  ///
  /// In bn, this message translates to:
  /// **'পরিবর্তন'**
  String get changeLink;

  /// No description provided for @payHistory.
  ///
  /// In bn, this message translates to:
  /// **'লেনদেন ইতিহাস'**
  String get payHistory;

  /// No description provided for @payItemTitle.
  ///
  /// In bn, this message translates to:
  /// **'{crop} – {qty}'**
  String payItemTitle(String crop, String qty);

  /// No description provided for @payHeldSub.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে · {date}'**
  String payHeldSub(String date);

  /// No description provided for @paySentSub.
  ///
  /// In bn, this message translates to:
  /// **'বিকাশে পাঠানো · {date}'**
  String paySentSub(String date);

  /// No description provided for @payPaidSub.
  ///
  /// In bn, this message translates to:
  /// **'পরিশোধিত · {date}'**
  String payPaidSub(String date);

  /// No description provided for @payTransportTitle.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহন – {name}'**
  String payTransportTitle(String name);

  /// No description provided for @payEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো লেনদেন নেই'**
  String get payEmpty;

  /// No description provided for @receiptTitle.
  ///
  /// In bn, this message translates to:
  /// **'রসিদ'**
  String get receiptTitle;

  /// No description provided for @receiptPaid.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট সফল · {method}'**
  String receiptPaid(String method);

  /// No description provided for @receiptHeld.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে জমা আছে'**
  String get receiptHeld;

  /// No description provided for @methodBkash.
  ///
  /// In bn, this message translates to:
  /// **'বিকাশ'**
  String get methodBkash;

  /// No description provided for @methodBank.
  ///
  /// In bn, this message translates to:
  /// **'ব্যাংক'**
  String get methodBank;

  /// No description provided for @rowReceiptNo.
  ///
  /// In bn, this message translates to:
  /// **'রসিদ নং'**
  String get rowReceiptNo;

  /// No description provided for @rowCrop.
  ///
  /// In bn, this message translates to:
  /// **'ফসল'**
  String get rowCrop;

  /// No description provided for @rowPrice.
  ///
  /// In bn, this message translates to:
  /// **'দাম'**
  String get rowPrice;

  /// No description provided for @rowFareLabel.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহন ভাড়া'**
  String get rowFareLabel;

  /// No description provided for @rowRoute.
  ///
  /// In bn, this message translates to:
  /// **'রুট'**
  String get rowRoute;

  /// No description provided for @pdfDownload.
  ///
  /// In bn, this message translates to:
  /// **'PDF ডাউনলোড'**
  String get pdfDownload;

  /// No description provided for @cropQty.
  ///
  /// In bn, this message translates to:
  /// **'{crop}, {qty}'**
  String cropQty(String crop, String qty);

  /// No description provided for @earnTitle.
  ///
  /// In bn, this message translates to:
  /// **'আয়'**
  String get earnTitle;

  /// No description provided for @earnHistory.
  ///
  /// In bn, this message translates to:
  /// **'আয়ের ইতিহাস'**
  String get earnHistory;

  /// No description provided for @earnHeldSub.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে জমা'**
  String get earnHeldSub;

  /// No description provided for @earnPaidSub.
  ///
  /// In bn, this message translates to:
  /// **'পরিশোধিত · বিকাশ'**
  String get earnPaidSub;

  /// No description provided for @earnEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো আয় নেই'**
  String get earnEmpty;
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
