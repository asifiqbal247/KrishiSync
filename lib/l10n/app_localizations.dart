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
  /// **'পণ্য গাড়িতে উঠলেই কৃষকের টাকা, ক্রেতার কাছে পৌঁছালেই ট্রান্সপোর্টারের টাকা।'**
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
  /// **'টাকা নিরাপদ লেনদেনে জমা আছে। পণ্য গাড়িতে উঠলেই কৃষক টাকা পাবেন।'**
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
  /// **'পণ্য'**
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
  /// **'পণ্য গাড়িতে উঠেছে?'**
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
  /// **'পণ্য ও ওজন'**
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
  /// **'ক্রেতার গাড়িতে পণ্য তোলা হলে নিশ্চিত করুন।'**
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
  /// **'পণ্য গাড়িতে উঠেছে: {no}'**
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
  /// **'পণ্য গাড়িতে উঠলে কৃষক, আর আপনার কাছে পৌঁছালে ট্রান্সপোর্টার নিরাপদ লেনদেন থেকে টাকা পাবেন। ১% ফি শুধু ক্রেতা দেবেন, লোড হলে কাটা হবে। ট্রাক রওনার আগে অর্ডার বাতিল করলে ভাড়ার ১০% কাটা যাবে, বাকি সব গোলাঘর থেকে ফেরত পাবেন। এরপর লোড বাতিল হলে ফসলের দাম ও ফি ফেরত পাবেন, ভাড়া নয়।'**
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
  /// **'ক্রেতার টাকা নিরাপদ লেনদেনে জমা থাকে। পণ্য গাড়িতে উঠলে কৃষক এবং ডেলিভারি OTP দিলে পরিবহনকারী টাকা পান। ১% প্ল্যাটফর্ম ফি শুধু ক্রেতা দেন। মান ও পরিমাণ লোডের সময়ই চূড়ান্ত হয়।'**
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

  /// No description provided for @nidVerifyTitle.
  ///
  /// In bn, this message translates to:
  /// **'NID যাচাইকরণ'**
  String get nidVerifyTitle;

  /// No description provided for @nidVerifyIntro.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত প্রোফাইল ক্রেতার আস্থা বাড়ায়।'**
  String get nidVerifyIntro;

  /// No description provided for @nidNumberLabel.
  ///
  /// In bn, this message translates to:
  /// **'NID নম্বর'**
  String get nidNumberLabel;

  /// No description provided for @nidNumberHint.
  ///
  /// In bn, this message translates to:
  /// **'১০ বা ১৭ সংখ্যা'**
  String get nidNumberHint;

  /// No description provided for @nidFront.
  ///
  /// In bn, this message translates to:
  /// **'NID কার্ডের সামনের ছবি'**
  String get nidFront;

  /// No description provided for @nidBack.
  ///
  /// In bn, this message translates to:
  /// **'NID কার্ডের পেছনের ছবি'**
  String get nidBack;

  /// No description provided for @selfie.
  ///
  /// In bn, this message translates to:
  /// **'আপনার সেলফি'**
  String get selfie;

  /// No description provided for @submitVerify.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইয়ের জন্য জমা দিন'**
  String get submitVerify;

  /// No description provided for @errNid.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক NID নম্বর দিন (১০ বা ১৭ সংখ্যা)'**
  String get errNid;

  /// No description provided for @errPhotoNeeded.
  ///
  /// In bn, this message translates to:
  /// **'ছবি দিন'**
  String get errPhotoNeeded;

  /// No description provided for @verifySent.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইয়ের জন্য জমা হয়েছে'**
  String get verifySent;

  /// No description provided for @bizVerifyTitle.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবসা যাচাইকরণ'**
  String get bizVerifyTitle;

  /// No description provided for @bizVerifyIntro.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত ব্যবসা কৃষকদের আস্থা বাড়ায়।'**
  String get bizVerifyIntro;

  /// No description provided for @bizName.
  ///
  /// In bn, this message translates to:
  /// **'প্রতিষ্ঠানের নাম'**
  String get bizName;

  /// No description provided for @bizAddress.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবসার ঠিকানা'**
  String get bizAddress;

  /// No description provided for @bizAddressHint.
  ///
  /// In bn, this message translates to:
  /// **'বিভাগ › জেলা › উপজেলা › এলাকা'**
  String get bizAddressHint;

  /// No description provided for @tradeLicense.
  ///
  /// In bn, this message translates to:
  /// **'ট্রেড লাইসেন্স নম্বর'**
  String get tradeLicense;

  /// No description provided for @tinLabel.
  ///
  /// In bn, this message translates to:
  /// **'TIN / BIN নম্বর'**
  String get tinLabel;

  /// No description provided for @tinHint.
  ///
  /// In bn, this message translates to:
  /// **'১২ সংখ্যা'**
  String get tinHint;

  /// No description provided for @licensePhoto.
  ///
  /// In bn, this message translates to:
  /// **'ট্রেড লাইসেন্সের ছবি'**
  String get licensePhoto;

  /// No description provided for @verifyStatusTitle.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকরণ ও রেটিং'**
  String get verifyStatusTitle;

  /// No description provided for @drivingLicense.
  ///
  /// In bn, this message translates to:
  /// **'ড্রাইভিং লাইসেন্স'**
  String get drivingLicense;

  /// No description provided for @vehiclePapers.
  ///
  /// In bn, this message translates to:
  /// **'গাড়ির কাগজপত্র (ফিটনেস)'**
  String get vehiclePapers;

  /// No description provided for @inReview.
  ///
  /// In bn, this message translates to:
  /// **'পর্যালোচনায়'**
  String get inReview;

  /// No description provided for @rowDocs.
  ///
  /// In bn, this message translates to:
  /// **'কাগজপত্র'**
  String get rowDocs;

  /// No description provided for @rowBizName.
  ///
  /// In bn, this message translates to:
  /// **'প্রতিষ্ঠান'**
  String get rowBizName;

  /// No description provided for @ratingsTitle.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং ও রিভিউ'**
  String get ratingsTitle;

  /// No description provided for @outOf5.
  ///
  /// In bn, this message translates to:
  /// **'{avg} / ৫'**
  String outOf5(String avg);

  /// No description provided for @outOf5Count.
  ///
  /// In bn, this message translates to:
  /// **'{avg} / ৫ ({n}টি রিভিউ)'**
  String outOf5Count(String avg, String n);

  /// No description provided for @reviewsOnlyDone.
  ///
  /// In bn, this message translates to:
  /// **'{n}টি রিভিউ · শুধু সম্পন্ন লেনদেন থেকে'**
  String reviewsOnlyDone(String n);

  /// No description provided for @noReviews.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো রিভিউ নেই'**
  String get noReviews;

  /// No description provided for @tag_good_quality.
  ///
  /// In bn, this message translates to:
  /// **'ভালো মান'**
  String get tag_good_quality;

  /// No description provided for @tag_right_weight.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক ওজন'**
  String get tag_right_weight;

  /// No description provided for @tag_on_time.
  ///
  /// In bn, this message translates to:
  /// **'সময়মতো'**
  String get tag_on_time;

  /// No description provided for @tag_on_time_load.
  ///
  /// In bn, this message translates to:
  /// **'সময়মতো লোড'**
  String get tag_on_time_load;

  /// No description provided for @tag_correct_info.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক তথ্য'**
  String get tag_correct_info;

  /// No description provided for @tag_fast_pay.
  ///
  /// In bn, this message translates to:
  /// **'দ্রুত পেমেন্ট'**
  String get tag_fast_pay;

  /// No description provided for @trackTitle.
  ///
  /// In bn, this message translates to:
  /// **'চালান ট্র্যাকিং'**
  String get trackTitle;

  /// No description provided for @truckCapRating.
  ///
  /// In bn, this message translates to:
  /// **'{type} · {cap} · {rating}'**
  String truckCapRating(String type, String cap, String rating);

  /// No description provided for @rowEta.
  ///
  /// In bn, this message translates to:
  /// **'আপনার কাছে পৌঁছাবে'**
  String get rowEta;

  /// No description provided for @rowStatus.
  ///
  /// In bn, this message translates to:
  /// **'অবস্থা'**
  String get rowStatus;

  /// No description provided for @rowRemaining.
  ///
  /// In bn, this message translates to:
  /// **'মোট দূরত্ব'**
  String get rowRemaining;

  /// No description provided for @kmOnly.
  ///
  /// In bn, this message translates to:
  /// **'{km} কিমি'**
  String kmOnly(String km);

  /// No description provided for @tsWaitingPickup.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপের অপেক্ষায়'**
  String get tsWaitingPickup;

  /// No description provided for @tsOnWay.
  ///
  /// In bn, this message translates to:
  /// **'আপনার দিকে আসছে'**
  String get tsOnWay;

  /// No description provided for @tsDelivered.
  ///
  /// In bn, this message translates to:
  /// **'পৌঁছেছে'**
  String get tsDelivered;

  /// No description provided for @messageBtn.
  ///
  /// In bn, this message translates to:
  /// **'বার্তা'**
  String get messageBtn;

  /// No description provided for @buyerProfileTitle.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার প্রোফাইল'**
  String get buyerProfileTitle;

  /// No description provided for @verifiedBusiness.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত ব্যবসা · ট্রেড লাইসেন্স'**
  String get verifiedBusiness;

  /// No description provided for @unverifiedBuyer.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা (ব্যবসা)'**
  String get unverifiedBuyer;

  /// No description provided for @statReviews.
  ///
  /// In bn, this message translates to:
  /// **'রিভিউ'**
  String get statReviews;

  /// No description provided for @statVerification.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই'**
  String get statVerification;

  /// No description provided for @seeDemands.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা দেখুন'**
  String get seeDemands;

  /// No description provided for @messageShort.
  ///
  /// In bn, this message translates to:
  /// **'বার্তা'**
  String get messageShort;

  /// No description provided for @cancelOrder.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বাতিল করুন'**
  String get cancelOrder;

  /// No description provided for @cancelOrderTitle.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বাতিল করবেন?'**
  String get cancelOrderTitle;

  /// No description provided for @cancelOrderBody.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক রওনার আগে বাতিল করলে ভাড়ার ১০% ({fee}) ট্রান্সপোর্টার পাবেন, বাকি {refund} গোলাঘর থেকে ফেরত পাবেন।'**
  String cancelOrderBody(String fee, String refund);

  /// No description provided for @cancelOrderBodyNoFee.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বাতিল করলে পুরো {refund} গোলাঘর থেকে ফেরত পাবেন।'**
  String cancelOrderBodyNoFee(String refund);

  /// No description provided for @yesCancel.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ, বাতিল করুন'**
  String get yesCancel;

  /// No description provided for @orderCancelled.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বাতিল হয়েছে'**
  String get orderCancelled;

  /// No description provided for @nOrderCancelled.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বাতিল: {no}'**
  String nOrderCancelled(String no);

  /// No description provided for @editProfileTitle.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল সম্পাদনা'**
  String get editProfileTitle;

  /// No description provided for @profileSaved.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল সংরক্ষণ হয়েছে'**
  String get profileSaved;

  /// No description provided for @postDemandTitle.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা পোস্ট করুন'**
  String get postDemandTitle;

  /// No description provided for @stepProductQty.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য ও পরিমাণ'**
  String get stepProductQty;

  /// No description provided for @stepDelivery.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি'**
  String get stepDelivery;

  /// No description provided for @fieldCropName.
  ///
  /// In bn, this message translates to:
  /// **'ফসল'**
  String get fieldCropName;

  /// No description provided for @fieldGradeSize.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড / মান'**
  String get fieldGradeSize;

  /// No description provided for @fieldTargetPrice.
  ///
  /// In bn, this message translates to:
  /// **'লক্ষ্য দাম'**
  String get fieldTargetPrice;

  /// No description provided for @marketRateLine.
  ///
  /// In bn, this message translates to:
  /// **'বাজার দর: ৳ {min}–{max} / কেজি'**
  String marketRateLine(String min, String max);

  /// No description provided for @deliveryLocation.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি লোকেশন'**
  String get deliveryLocation;

  /// No description provided for @deliveryDate.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি তারিখ'**
  String get deliveryDate;

  /// No description provided for @repeatOnce.
  ///
  /// In bn, this message translates to:
  /// **'একবার'**
  String get repeatOnce;

  /// No description provided for @repeatOnceSub.
  ///
  /// In bn, this message translates to:
  /// **'শুধু এই অর্ডার'**
  String get repeatOnceSub;

  /// No description provided for @repeatMonthly.
  ///
  /// In bn, this message translates to:
  /// **'নিয়মিত (রিপিট)'**
  String get repeatMonthly;

  /// No description provided for @repeatMonthlySub.
  ///
  /// In bn, this message translates to:
  /// **'প্রতি মাসে'**
  String get repeatMonthlySub;

  /// No description provided for @publishDemand.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা প্রকাশ করুন'**
  String get publishDemand;

  /// No description provided for @demandPosted.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা প্রকাশ হয়েছে'**
  String get demandPosted;

  /// No description provided for @myDemandsTitle.
  ///
  /// In bn, this message translates to:
  /// **'আমার চাহিদা'**
  String get myDemandsTitle;

  /// No description provided for @noDemands.
  ///
  /// In bn, this message translates to:
  /// **'কোনো চাহিদা নেই'**
  String get noDemands;

  /// No description provided for @demandLine.
  ///
  /// In bn, this message translates to:
  /// **'{crop} – {qty}'**
  String demandLine(String crop, String qty);

  /// No description provided for @demandSubTarget.
  ///
  /// In bn, this message translates to:
  /// **'{date} · লক্ষ্য ৳ {price}'**
  String demandSubTarget(String date, String price);

  /// No description provided for @offersReceived.
  ///
  /// In bn, this message translates to:
  /// **'প্রাপ্ত অফার ({n})'**
  String offersReceived(String n);

  /// No description provided for @sortPrice.
  ///
  /// In bn, this message translates to:
  /// **'দাম'**
  String get sortPrice;

  /// No description provided for @sortQuality.
  ///
  /// In bn, this message translates to:
  /// **'মান'**
  String get sortQuality;

  /// No description provided for @sortRating.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং'**
  String get sortRating;

  /// No description provided for @commitSub.
  ///
  /// In bn, this message translates to:
  /// **'{qty} · গ্রেড {grade} · {rating}'**
  String commitSub(String qty, String grade, String rating);

  /// No description provided for @selectedTotal.
  ///
  /// In bn, this message translates to:
  /// **'নির্বাচিত মোট'**
  String get selectedTotal;

  /// No description provided for @ofKg.
  ///
  /// In bn, this message translates to:
  /// **'{a} / {b} কেজি'**
  String ofKg(String a, String b);

  /// No description provided for @acceptSelected.
  ///
  /// In bn, this message translates to:
  /// **'নির্বাচিত অফার গ্রহণ'**
  String get acceptSelected;

  /// No description provided for @noCommits.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো কৃষক অফার দেননি'**
  String get noCommits;

  /// No description provided for @commitsAccepted.
  ///
  /// In bn, this message translates to:
  /// **'অফার গ্রহণ হয়েছে, অর্ডার তৈরি হয়েছে'**
  String get commitsAccepted;

  /// No description provided for @selectCommit.
  ///
  /// In bn, this message translates to:
  /// **'অন্তত একটি অফার বেছে নিন'**
  String get selectCommit;

  /// No description provided for @acceptedBadge.
  ///
  /// In bn, this message translates to:
  /// **'গৃহীত'**
  String get acceptedBadge;

  /// No description provided for @closeDemand.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা বন্ধ করুন'**
  String get closeDemand;

  /// No description provided for @demandClosed.
  ///
  /// In bn, this message translates to:
  /// **'বন্ধ'**
  String get demandClosed;

  /// No description provided for @demandOpen.
  ///
  /// In bn, this message translates to:
  /// **'চলমান'**
  String get demandOpen;

  /// No description provided for @demandFilled.
  ///
  /// In bn, this message translates to:
  /// **'পূর্ণ'**
  String get demandFilled;

  /// No description provided for @buyerDemandsTitle.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার চাহিদা'**
  String get buyerDemandsTitle;

  /// No description provided for @demandSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'ফসল বা এলাকা খুঁজুন'**
  String get demandSearchHint;

  /// No description provided for @filterBigOrder.
  ///
  /// In bn, this message translates to:
  /// **'বড় অর্ডার'**
  String get filterBigOrder;

  /// No description provided for @filterExport.
  ///
  /// In bn, this message translates to:
  /// **'বিদেশি'**
  String get filterExport;

  /// No description provided for @demandRowSub.
  ///
  /// In bn, this message translates to:
  /// **'{buyer} · {date}'**
  String demandRowSub(String buyer, String date);

  /// No description provided for @poolingSub.
  ///
  /// In bn, this message translates to:
  /// **'পুলিং চলছে · {pct}% পূর্ণ'**
  String poolingSub(String pct);

  /// No description provided for @demandDetailsTitle.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদার বিবরণ'**
  String get demandDetailsTitle;

  /// No description provided for @rowNeed.
  ///
  /// In bn, this message translates to:
  /// **'প্রয়োজন'**
  String get rowNeed;

  /// No description provided for @rowDelivery.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি'**
  String get rowDelivery;

  /// No description provided for @ratingTrades.
  ///
  /// In bn, this message translates to:
  /// **'{avg} ({n} লেনদেন)'**
  String ratingTrades(String avg, String n);

  /// No description provided for @poolingProgress.
  ///
  /// In bn, this message translates to:
  /// **'পুলিং অগ্রগতি'**
  String get poolingProgress;

  /// No description provided for @poolingNote.
  ///
  /// In bn, this message translates to:
  /// **'একাধিক কৃষক মিলে এই অর্ডার পূরণ করা যাবে।'**
  String get poolingNote;

  /// No description provided for @futureHarvest.
  ///
  /// In bn, this message translates to:
  /// **'ভবিষ্যৎ ফসল থেকে দেব (হারভেস্ট)'**
  String get futureHarvest;

  /// No description provided for @wantToSupply.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহ দিতে চাই'**
  String get wantToSupply;

  /// No description provided for @howMuchSupply.
  ///
  /// In bn, this message translates to:
  /// **'কত কেজি দিতে পারবেন?'**
  String get howMuchSupply;

  /// No description provided for @readyFrom.
  ///
  /// In bn, this message translates to:
  /// **'প্রস্তুত থাকবে'**
  String get readyFrom;

  /// No description provided for @estTotal.
  ///
  /// In bn, this message translates to:
  /// **'মোট পাবেন (আনুমানিক)'**
  String get estTotal;

  /// No description provided for @commitSent.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহের প্রস্তাব পাঠানো হয়েছে'**
  String get commitSent;

  /// No description provided for @myCommitLine.
  ///
  /// In bn, this message translates to:
  /// **'আপনার প্রস্তাব: {qty} · {status}'**
  String myCommitLine(String qty, String status);

  /// No description provided for @commitPending.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষমাণ'**
  String get commitPending;

  /// No description provided for @errQtyLeft.
  ///
  /// In bn, this message translates to:
  /// **'বাকি আছে {qty}'**
  String errQtyLeft(String qty);

  /// No description provided for @nCommitNew.
  ///
  /// In bn, this message translates to:
  /// **'নতুন সরবরাহ প্রস্তাব: {crop}'**
  String nCommitNew(String crop);

  /// No description provided for @nCommitNewBody.
  ///
  /// In bn, this message translates to:
  /// **'{farmer} · {qty}'**
  String nCommitNewBody(String farmer, String qty);

  /// No description provided for @nCommitAccepted.
  ///
  /// In bn, this message translates to:
  /// **'আপনার সরবরাহ গৃহীত: {no}'**
  String nCommitAccepted(String no);

  /// No description provided for @closeDemandBody.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা বন্ধ করলে কৃষকরা আর সরবরাহ প্রস্তাব দিতে পারবেন না। গৃহীত অর্ডার চলবে।'**
  String get closeDemandBody;

  /// No description provided for @messagesTitle.
  ///
  /// In bn, this message translates to:
  /// **'বার্তা'**
  String get messagesTitle;

  /// No description provided for @searchNameHint.
  ///
  /// In bn, this message translates to:
  /// **'নাম খুঁজুন'**
  String get searchNameHint;

  /// No description provided for @noChats.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো বার্তা নেই'**
  String get noChats;

  /// No description provided for @typeMessage.
  ///
  /// In bn, this message translates to:
  /// **'বার্তা লিখুন…'**
  String get typeMessage;

  /// No description provided for @yesterday.
  ///
  /// In bn, this message translates to:
  /// **'গতকাল'**
  String get yesterday;

  /// No description provided for @chatStart.
  ///
  /// In bn, this message translates to:
  /// **'কথা শুরু করুন'**
  String get chatStart;

  /// No description provided for @nameWithRole.
  ///
  /// In bn, this message translates to:
  /// **'{name} ({role})'**
  String nameWithRole(String name, String role);

  /// No description provided for @roleDriverShort.
  ///
  /// In bn, this message translates to:
  /// **'চালক'**
  String get roleDriverShort;

  /// No description provided for @helpTitle.
  ///
  /// In bn, this message translates to:
  /// **'সাহায্য ও সহায়তা'**
  String get helpTitle;

  /// No description provided for @callHelpline.
  ///
  /// In bn, this message translates to:
  /// **'হেল্পলাইনে কল করুন'**
  String get callHelpline;

  /// No description provided for @commonQuestions.
  ///
  /// In bn, this message translates to:
  /// **'সাধারণ প্রশ্ন'**
  String get commonQuestions;

  /// No description provided for @listenTime.
  ///
  /// In bn, this message translates to:
  /// **'শুনুন · {t}'**
  String listenTime(String t);

  /// No description provided for @chatHelp.
  ///
  /// In bn, this message translates to:
  /// **'চ্যাটে সাহায্য নিন'**
  String get chatHelp;

  /// No description provided for @faqTitle.
  ///
  /// In bn, this message translates to:
  /// **'প্রশ্ন ও উত্তর'**
  String get faqTitle;

  /// No description provided for @faqUseful.
  ///
  /// In bn, this message translates to:
  /// **'এই উত্তর কি কাজে লেগেছে?'**
  String get faqUseful;

  /// No description provided for @faqYes.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ 👍'**
  String get faqYes;

  /// No description provided for @faqNo.
  ///
  /// In bn, this message translates to:
  /// **'না 👎'**
  String get faqNo;

  /// No description provided for @faqThanks.
  ///
  /// In bn, this message translates to:
  /// **'মতামতের জন্য ধন্যবাদ'**
  String get faqThanks;

  /// No description provided for @supportName.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর সহায়তা'**
  String get supportName;

  /// No description provided for @q1.
  ///
  /// In bn, this message translates to:
  /// **'কীভাবে ফসল বিক্রি করবেন'**
  String get q1;

  /// No description provided for @q1Farmer.
  ///
  /// In bn, this message translates to:
  /// **'নিচের \"বিক্রি\" বোতাম চাপুন → ফসল, মান, পরিমাণ ও ছবি দিন → দাম, তারিখ ও পিকআপ ঠিকানা দিন → প্রকাশ করুন। মডারেটর অনুমোদনের পর ক্রেতারা দেখতে ও অফার দিতে পারবেন।'**
  String get q1Farmer;

  /// No description provided for @q2.
  ///
  /// In bn, this message translates to:
  /// **'কীভাবে পেমেন্ট পাবেন'**
  String get q2;

  /// No description provided for @q2Farmer.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাকে পণ্য লোড শেষ হলেই আপনার টাকা নিরাপদ লেনদেন থেকে ছাড় হয়। এই পেমেন্ট চূড়ান্ত — পরে আটকানো বা ফেরত নেওয়া যাবে না।'**
  String get q2Farmer;

  /// No description provided for @q2Transporter.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার কাছে পণ্য পৌঁছে ক্রেতার OTP দিলে ভাড়া পাবেন। রওনার আগে অর্ডার বাতিল হলে ভাড়ার ১০% পাবেন।'**
  String get q2Transporter;

  /// No description provided for @q2Buyer.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডারের টাকা নিরাপদ লেনদেনে জমা থাকে। মান ও পরিমাণ লোডের সময়ই চূড়ান্ত হয়, তাই লোডের আগে দেখে নিন।'**
  String get q2Buyer;

  /// No description provided for @q3.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক কে বুক করেন?'**
  String get q3;

  /// No description provided for @q3Buyer.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডারে \"প্ল্যাটফর্মের ট্রাক\" বাছলে ট্রাকচালকরা ভাড়ার প্রস্তাব দেন, আপনি একটি বেছে বুক করেন। \"নিজে পরিবহন করব\" বাছলে আপনি নিজে পণ্য নিয়ে যাবেন।'**
  String get q3Buyer;

  /// No description provided for @q4.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেন কী?'**
  String get q4;

  /// No description provided for @q4Body.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার টাকা গোলাঘরে জমা থাকে। পণ্য লোড হলে কৃষক এবং ডেলিভারি হলে পরিবহনকারী টাকা পান। এতে কেউ ঠকেন না।'**
  String get q4Body;

  /// No description provided for @q5.
  ///
  /// In bn, this message translates to:
  /// **'অফার বাতিল করলে কী হবে?'**
  String get q5;

  /// No description provided for @q5Body.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাখ্যাত অফার আর গ্রহণ করা যায় না, তবে ক্রেতা নতুন অফার দিতে পারেন। অর্ডার হওয়ার আগে কোনো টাকা কাটা হয় না।'**
  String get q5Body;

  /// No description provided for @voiceGuideTitle.
  ///
  /// In bn, this message translates to:
  /// **'ভয়েস গাইড'**
  String get voiceGuideTitle;

  /// No description provided for @pmTitle.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট মাধ্যম'**
  String get pmTitle;

  /// No description provided for @pmIntro.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক ও ট্রান্সপোর্টার: টাকা কোথায় পাবেন · ক্রেতা: কোথা থেকে টাকা দেবেন'**
  String get pmIntro;

  /// No description provided for @pmDefault.
  ///
  /// In bn, this message translates to:
  /// **'ডিফল্ট'**
  String get pmDefault;

  /// No description provided for @pmMakeDefault.
  ///
  /// In bn, this message translates to:
  /// **'বদলান'**
  String get pmMakeDefault;

  /// No description provided for @pmNameMatched.
  ///
  /// In bn, this message translates to:
  /// **'নাম মিলেছে: {name}'**
  String pmNameMatched(String name);

  /// No description provided for @pmWalletLine.
  ///
  /// In bn, this message translates to:
  /// **'{type} · {number}'**
  String pmWalletLine(String type, String number);

  /// No description provided for @pmBankSub.
  ///
  /// In bn, this message translates to:
  /// **'{name} · {branch} শাখা'**
  String pmBankSub(String name, String branch);

  /// No description provided for @pmAdd.
  ///
  /// In bn, this message translates to:
  /// **'+ নতুন মাধ্যম যোগ করুন'**
  String get pmAdd;

  /// No description provided for @pmSafetyTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপত্তা'**
  String get pmSafetyTitle;

  /// No description provided for @pmSafetyBody.
  ///
  /// In bn, this message translates to:
  /// **'নাম মেলানো ছাড়া নতুন মাধ্যমে টাকা যাবে না। মাধ্যম বদলালে ২৪ ঘণ্টা আগের মাধ্যমেই টাকা যাবে, যাতে কেউ প্রতারণা করতে না পারে।'**
  String get pmSafetyBody;

  /// No description provided for @pmNone.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো মাধ্যম যোগ করা হয়নি'**
  String get pmNone;

  /// No description provided for @pmAddTitle.
  ///
  /// In bn, this message translates to:
  /// **'মাধ্যম যোগ করুন'**
  String get pmAddTitle;

  /// No description provided for @pmWhich.
  ///
  /// In bn, this message translates to:
  /// **'কোন মাধ্যম যোগ করবেন?'**
  String get pmWhich;

  /// No description provided for @pmBkash.
  ///
  /// In bn, this message translates to:
  /// **'বিকাশ'**
  String get pmBkash;

  /// No description provided for @pmNagad.
  ///
  /// In bn, this message translates to:
  /// **'নগদ'**
  String get pmNagad;

  /// No description provided for @pmRocket.
  ///
  /// In bn, this message translates to:
  /// **'রকেট'**
  String get pmRocket;

  /// No description provided for @pmBank.
  ///
  /// In bn, this message translates to:
  /// **'ব্যাংক অ্যাকাউন্ট'**
  String get pmBank;

  /// No description provided for @pmWalletInstant.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল ওয়ালেট · সাথে সাথে টাকা'**
  String get pmWalletInstant;

  /// No description provided for @pmWallet.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল ওয়ালেট'**
  String get pmWallet;

  /// No description provided for @pmBankSlow.
  ///
  /// In bn, this message translates to:
  /// **'বড় অঙ্কের জন্য · ১ কার্যদিবস'**
  String get pmBankSlow;

  /// No description provided for @pmNumberTitle.
  ///
  /// In bn, this message translates to:
  /// **'{type} নম্বর'**
  String pmNumberTitle(String type);

  /// No description provided for @pmOwnNumber.
  ///
  /// In bn, this message translates to:
  /// **'নম্বরটি আপনার নিজের নামে হতে হবে। অন্যের নম্বরে টাকা পাঠানো যাবে না।'**
  String get pmOwnNumber;

  /// No description provided for @pmWhyTitle.
  ///
  /// In bn, this message translates to:
  /// **'কেন'**
  String get pmWhyTitle;

  /// No description provided for @pmWhyBody.
  ///
  /// In bn, this message translates to:
  /// **'ভুল নম্বরে টাকা চলে যাওয়া ও প্রতারণা ঠেকাতে।'**
  String get pmWhyBody;

  /// No description provided for @pmVerifyTitle.
  ///
  /// In bn, this message translates to:
  /// **'নম্বর যাচাই'**
  String get pmVerifyTitle;

  /// No description provided for @pmVerifySub.
  ///
  /// In bn, this message translates to:
  /// **'{type} অ্যাকাউন্টের নাম ও প্রোফাইলের নাম এক'**
  String pmVerifySub(String type);

  /// No description provided for @pmVerifyIntro.
  ///
  /// In bn, this message translates to:
  /// **'{number} নম্বরটি আপনার প্রোফাইলের নামে যোগ হবে।'**
  String pmVerifyIntro(String number);

  /// No description provided for @pmSetDefault.
  ///
  /// In bn, this message translates to:
  /// **'এটিকে ডিফল্ট মাধ্যম হিসেবে রাখুন'**
  String get pmSetDefault;

  /// No description provided for @pmSaved.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট মাধ্যম সংরক্ষণ হয়েছে'**
  String get pmSaved;

  /// No description provided for @pmBankTitle.
  ///
  /// In bn, this message translates to:
  /// **'ব্যাংক অ্যাকাউন্ট'**
  String get pmBankTitle;

  /// No description provided for @pmBankName.
  ///
  /// In bn, this message translates to:
  /// **'ব্যাংক'**
  String get pmBankName;

  /// No description provided for @pmBranch.
  ///
  /// In bn, this message translates to:
  /// **'শাখা'**
  String get pmBranch;

  /// No description provided for @pmAccName.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্টের নাম'**
  String get pmAccName;

  /// No description provided for @pmAccNameHint.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইলের নামের সাথে মিলতে হবে'**
  String get pmAccNameHint;

  /// No description provided for @pmAccNo.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট নম্বর'**
  String get pmAccNo;

  /// No description provided for @pmAccNoHint.
  ///
  /// In bn, this message translates to:
  /// **'১৩–১৭ সংখ্যা'**
  String get pmAccNoHint;

  /// No description provided for @pmBankNote.
  ///
  /// In bn, this message translates to:
  /// **'রাউটিং নম্বর শাখা থেকে স্বয়ংক্রিয়ভাবে বসবে। যাচাইয়ের জন্য ১ টাকা পাঠানো হবে (১ কার্যদিবস)।'**
  String get pmBankNote;

  /// No description provided for @pmStartVerify.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই শুরু করুন'**
  String get pmStartVerify;

  /// No description provided for @pmErrAccNo.
  ///
  /// In bn, this message translates to:
  /// **'১৩–১৭ সংখ্যার অ্যাকাউন্ট নম্বর দিন'**
  String get pmErrAccNo;

  /// No description provided for @pmErrName.
  ///
  /// In bn, this message translates to:
  /// **'নাম প্রোফাইলের সাথে মিলছে না'**
  String get pmErrName;

  /// No description provided for @pmSendCode.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই কোড পাঠান'**
  String get pmSendCode;

  /// No description provided for @pmSave.
  ///
  /// In bn, this message translates to:
  /// **'সেভ করুন'**
  String get pmSave;

  /// No description provided for @pmVerifying.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই হচ্ছে'**
  String get pmVerifying;

  /// No description provided for @pmVerifiedShort.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত'**
  String get pmVerifiedShort;

  /// No description provided for @tipTitle.
  ///
  /// In bn, this message translates to:
  /// **'কৃষি টিপস'**
  String get tipTitle;

  /// No description provided for @tipPriceBody1.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রির আগে \"বাজার দর\" দেখুন। দাম বাজারের সীমার মধ্যে রাখলে ক্রেতা দ্রুত অফার দেন।'**
  String get tipPriceBody1;

  /// No description provided for @tipPriceBody2.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের পরিষ্কার ছবি দিন — দিনের আলোয়, কাছ থেকে। ভালো ছবিতে বেশি দাম পাওয়া যায়।'**
  String get tipPriceBody2;

  /// No description provided for @tipPriceBody3.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার চাহিদা দেখে একসাথে বড় চালান দিন; পুলিং করলে পরিবহন খরচ কমে।'**
  String get tipPriceBody3;

  /// No description provided for @tipPackBody1.
  ///
  /// In bn, this message translates to:
  /// **'টমেটো ও নরম সবজি ২০ কেজির ক্রেটে রাখুন, বস্তায় নয় — এতে কম নষ্ট হয়।'**
  String get tipPackBody1;

  /// No description provided for @tipPackBody2.
  ///
  /// In bn, this message translates to:
  /// **'আলু ও পেঁয়াজ শুকনো, বাতাস চলাচল করে এমন বস্তায় রাখুন।'**
  String get tipPackBody2;

  /// No description provided for @tipPackBody3.
  ///
  /// In bn, this message translates to:
  /// **'লোডের আগে ভেজা বা পচা ফসল আলাদা করুন — মান লোডের সময়ই চূড়ান্ত হয়।'**
  String get tipPackBody3;

  /// No description provided for @tipGradeBody1.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড A: সমান আকার, দাগহীন, পুরো পাকা বা নির্দিষ্ট পাকা।'**
  String get tipGradeBody1;

  /// No description provided for @tipGradeBody2.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড B: সামান্য দাগ বা আকারে কিছুটা ভিন্ন, তবে খাওয়ার উপযোগী।'**
  String get tipGradeBody2;

  /// No description provided for @tipGradeBody3.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড C: বেশি দাগ বা ছোট আকার — প্রক্রিয়াজাতকরণের জন্য।'**
  String get tipGradeBody3;

  /// No description provided for @globalBuyersTitle.
  ///
  /// In bn, this message translates to:
  /// **'বিদেশি ক্রেতা'**
  String get globalBuyersTitle;

  /// No description provided for @globalBuyersIntro.
  ///
  /// In bn, this message translates to:
  /// **'বিদেশি ক্রেতা ও আমদানিকারকদের কাছে ফসল বিক্রি করুন।'**
  String get globalBuyersIntro;

  /// No description provided for @noExportDemand.
  ///
  /// In bn, this message translates to:
  /// **'এখনো বিদেশি ক্রেতার চাহিদা নেই। রপ্তানির প্রস্তুতি নিতে গাইড দেখুন।'**
  String get noExportDemand;

  /// No description provided for @seeExportGuide.
  ///
  /// In bn, this message translates to:
  /// **'রপ্তানি গাইড দেখুন'**
  String get seeExportGuide;

  /// No description provided for @exportGuideTitle.
  ///
  /// In bn, this message translates to:
  /// **'রপ্তানি গাইড'**
  String get exportGuideTitle;

  /// No description provided for @exportSteps.
  ///
  /// In bn, this message translates to:
  /// **'ধাপসমূহ'**
  String get exportSteps;

  /// No description provided for @exStep1.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল যাচাই'**
  String get exStep1;

  /// No description provided for @exStep1Sub.
  ///
  /// In bn, this message translates to:
  /// **'NID ও জমির তথ্য'**
  String get exStep1Sub;

  /// No description provided for @exStep2.
  ///
  /// In bn, this message translates to:
  /// **'মান সনদ'**
  String get exStep2;

  /// No description provided for @exStep2Sub.
  ///
  /// In bn, this message translates to:
  /// **'ফাইটোস্যানিটারি সার্টিফিকেট'**
  String get exStep2Sub;

  /// No description provided for @exStep3.
  ///
  /// In bn, this message translates to:
  /// **'প্যাকেজিং'**
  String get exStep3;

  /// No description provided for @exStep3Sub.
  ///
  /// In bn, this message translates to:
  /// **'রপ্তানি মান অনুযায়ী'**
  String get exStep3Sub;

  /// No description provided for @exStep4.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি ও পেমেন্ট'**
  String get exStep4;

  /// No description provided for @exStep4Sub.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেন বা LC'**
  String get exStep4Sub;

  /// No description provided for @exDocs.
  ///
  /// In bn, this message translates to:
  /// **'প্রয়োজনীয় কাগজপত্র'**
  String get exDocs;

  /// No description provided for @exDoc1.
  ///
  /// In bn, this message translates to:
  /// **'ফাইটোস্যানিটারি সার্টিফিকেট'**
  String get exDoc1;

  /// No description provided for @exDoc1Sub.
  ///
  /// In bn, this message translates to:
  /// **'কৃষি সম্প্রসারণ অধিদপ্তর'**
  String get exDoc1Sub;

  /// No description provided for @exDoc2.
  ///
  /// In bn, this message translates to:
  /// **'ট্রেড লাইসেন্স'**
  String get exDoc2;

  /// No description provided for @exDoc2Sub.
  ///
  /// In bn, this message translates to:
  /// **'অথবা কৃষক সমবায় সনদ'**
  String get exDoc2Sub;

  /// No description provided for @shareTitle.
  ///
  /// In bn, this message translates to:
  /// **'ট্র্যাক রেকর্ড শেয়ার'**
  String get shareTitle;

  /// No description provided for @statRatingReviews.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং ({n} রিভিউ)'**
  String statRatingReviews(String n);

  /// No description provided for @memberSince.
  ///
  /// In bn, this message translates to:
  /// **'{year} থেকে'**
  String memberSince(String year);

  /// No description provided for @memberLabel.
  ///
  /// In bn, this message translates to:
  /// **'সদস্য'**
  String get memberLabel;

  /// No description provided for @shareCode.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর আইডি: {code}'**
  String shareCode(String code);

  /// No description provided for @shareVerifiedToday.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর যাচাইকৃত · আপডেট: আজ'**
  String get shareVerifiedToday;

  /// No description provided for @shareQrNote.
  ///
  /// In bn, this message translates to:
  /// **'QR স্ক্যান করলে এই তথ্য দেখা যাবে'**
  String get shareQrNote;

  /// No description provided for @whatToShow.
  ///
  /// In bn, this message translates to:
  /// **'কী দেখাবেন'**
  String get whatToShow;

  /// No description provided for @showDeals.
  ///
  /// In bn, this message translates to:
  /// **'লেনদেন সংখ্যা ও সময়মতো %'**
  String get showDeals;

  /// No description provided for @showRatings.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং ও রিভিউ'**
  String get showRatings;

  /// No description provided for @showMoney.
  ///
  /// In bn, this message translates to:
  /// **'টাকার পরিমাণ'**
  String get showMoney;

  /// No description provided for @visibleAll.
  ///
  /// In bn, this message translates to:
  /// **'সবাই দেখতে পাবে'**
  String get visibleAll;

  /// No description provided for @hiddenPrivacy.
  ///
  /// In bn, this message translates to:
  /// **'গোপনীয়তার জন্য বন্ধ'**
  String get hiddenPrivacy;

  /// No description provided for @onLabel.
  ///
  /// In bn, this message translates to:
  /// **'চালু'**
  String get onLabel;

  /// No description provided for @offLabel.
  ///
  /// In bn, this message translates to:
  /// **'বন্ধ'**
  String get offLabel;

  /// No description provided for @loanNote.
  ///
  /// In bn, this message translates to:
  /// **'ব্যাংক বা এনজিওতে দেখিয়ে নিজে লোন নিতে পারবেন (অ্যাপে কোনো লোন নেই)।'**
  String get loanNote;

  /// No description provided for @copyLink.
  ///
  /// In bn, this message translates to:
  /// **'লিংক কপি'**
  String get copyLink;

  /// No description provided for @shareNow.
  ///
  /// In bn, this message translates to:
  /// **'শেয়ার করুন'**
  String get shareNow;

  /// No description provided for @copied.
  ///
  /// In bn, this message translates to:
  /// **'কপি হয়েছে'**
  String get copied;

  /// No description provided for @shareHeader.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর ট্র্যাক রেকর্ড'**
  String get shareHeader;

  /// No description provided for @shareMoneyLine.
  ///
  /// In bn, this message translates to:
  /// **'মোট লেনদেন: {amount}'**
  String shareMoneyLine(String amount);

  /// No description provided for @historyTitle.
  ///
  /// In bn, this message translates to:
  /// **'লেনদেনের ইতিহাস'**
  String get historyTitle;

  /// No description provided for @histIncomeMonth.
  ///
  /// In bn, this message translates to:
  /// **'এ মাসে আয়'**
  String get histIncomeMonth;

  /// No description provided for @histBuyMonth.
  ///
  /// In bn, this message translates to:
  /// **'এ মাসে কেনা'**
  String get histBuyMonth;

  /// No description provided for @histSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার নং, ফসল বা নাম খুঁজুন'**
  String get histSearchHint;

  /// No description provided for @histReceived.
  ///
  /// In bn, this message translates to:
  /// **'পেয়েছেন'**
  String get histReceived;

  /// No description provided for @histPaid.
  ///
  /// In bn, this message translates to:
  /// **'পরিশোধিত'**
  String get histPaid;

  /// No description provided for @histHeld.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেনে'**
  String get histHeld;

  /// No description provided for @histCancelled.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get histCancelled;

  /// No description provided for @monthTotal.
  ///
  /// In bn, this message translates to:
  /// **'মোট {amount}'**
  String monthTotal(String amount);

  /// No description provided for @histRowSub.
  ///
  /// In bn, this message translates to:
  /// **'{party} · {date} · {status}'**
  String histRowSub(String party, String date, String status);

  /// No description provided for @histEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এই সময়ে কোনো লেনদেন নেই'**
  String get histEmpty;

  /// No description provided for @statementBtn.
  ///
  /// In bn, this message translates to:
  /// **'স্টেটমেন্ট ডাউনলোড / শেয়ার'**
  String get statementBtn;

  /// No description provided for @statementTitle.
  ///
  /// In bn, this message translates to:
  /// **'স্টেটমেন্ট তৈরি'**
  String get statementTitle;

  /// No description provided for @periodLabel.
  ///
  /// In bn, this message translates to:
  /// **'সময়কাল'**
  String get periodLabel;

  /// No description provided for @periodThisMonth.
  ///
  /// In bn, this message translates to:
  /// **'এ মাস'**
  String get periodThisMonth;

  /// No description provided for @periodLast3.
  ///
  /// In bn, this message translates to:
  /// **'গত ৩ মাস'**
  String get periodLast3;

  /// No description provided for @period12.
  ///
  /// In bn, this message translates to:
  /// **'১২ মাস · ব্যাংকের জন্য'**
  String get period12;

  /// No description provided for @periodCustom.
  ///
  /// In bn, this message translates to:
  /// **'নিজে বাছুন'**
  String get periodCustom;

  /// No description provided for @rowPeriod.
  ///
  /// In bn, this message translates to:
  /// **'সময়কাল'**
  String get rowPeriod;

  /// No description provided for @rowTotalDeals.
  ///
  /// In bn, this message translates to:
  /// **'মোট লেনদেন'**
  String get rowTotalDeals;

  /// No description provided for @rowTotalIncome.
  ///
  /// In bn, this message translates to:
  /// **'মোট আয়'**
  String get rowTotalIncome;

  /// No description provided for @rowTotalSpent.
  ///
  /// In bn, this message translates to:
  /// **'মোট খরচ'**
  String get rowTotalSpent;

  /// No description provided for @dateRange.
  ///
  /// In bn, this message translates to:
  /// **'{from} – {to}'**
  String dateRange(String from, String to);

  /// No description provided for @statementPrivacy.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ফোন নম্বর ও NID স্টেটমেন্টে লুকানো থাকবে।'**
  String get statementPrivacy;

  /// No description provided for @shareLabel.
  ///
  /// In bn, this message translates to:
  /// **'শেয়ার করুন'**
  String get shareLabel;

  /// No description provided for @shareWhatsapp.
  ///
  /// In bn, this message translates to:
  /// **'হোয়াটসঅ্যাপ'**
  String get shareWhatsapp;

  /// No description provided for @shareEmail.
  ///
  /// In bn, this message translates to:
  /// **'ইমেইল'**
  String get shareEmail;

  /// No description provided for @shareMessenger.
  ///
  /// In bn, this message translates to:
  /// **'মেসেঞ্জার'**
  String get shareMessenger;

  /// No description provided for @shareOther.
  ///
  /// In bn, this message translates to:
  /// **'অন্যান্য'**
  String get shareOther;

  /// No description provided for @pdfDownloadFull.
  ///
  /// In bn, this message translates to:
  /// **'PDF ডাউনলোড করুন'**
  String get pdfDownloadFull;

  /// No description provided for @statementHeader.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর স্টেটমেন্ট'**
  String get statementHeader;

  /// No description provided for @statementVerified.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর যাচাইকৃত'**
  String get statementVerified;

  /// No description provided for @priceAlertOn.
  ///
  /// In bn, this message translates to:
  /// **'দাম সতর্কতা চালু · {price} · বন্ধ করুন'**
  String priceAlertOn(String price);

  /// No description provided for @priceAlertTitle.
  ///
  /// In bn, this message translates to:
  /// **'দাম সতর্কতা'**
  String get priceAlertTitle;

  /// No description provided for @priceAlertHintUp.
  ///
  /// In bn, this message translates to:
  /// **'দাম এই টার্গেটে বা তার বেশি হলে অ্যাপে নোটিফিকেশন পাবেন।'**
  String get priceAlertHintUp;

  /// No description provided for @priceAlertHintDown.
  ///
  /// In bn, this message translates to:
  /// **'দাম এই টার্গেটে বা তার কম হলে অ্যাপে নোটিফিকেশন পাবেন।'**
  String get priceAlertHintDown;

  /// No description provided for @priceAlertSet.
  ///
  /// In bn, this message translates to:
  /// **'দাম সতর্কতা চালু হয়েছে'**
  String get priceAlertSet;

  /// No description provided for @priceAlertRemoveQ.
  ///
  /// In bn, this message translates to:
  /// **'দাম সতর্কতা বন্ধ করবেন?'**
  String get priceAlertRemoveQ;

  /// No description provided for @priceAlertRemoveBody.
  ///
  /// In bn, this message translates to:
  /// **'এই ফসলের দাম নিয়ে আর নোটিফিকেশন পাবেন না।'**
  String get priceAlertRemoveBody;

  /// No description provided for @priceAlertRemove.
  ///
  /// In bn, this message translates to:
  /// **'বন্ধ করুন'**
  String get priceAlertRemove;

  /// No description provided for @nPriceAlert.
  ///
  /// In bn, this message translates to:
  /// **'{crop}-এর দাম টার্গেটে পৌঁছেছে'**
  String nPriceAlert(String crop);

  /// No description provided for @nPriceAlertBody.
  ///
  /// In bn, this message translates to:
  /// **'আজকের দাম {price}/কেজি'**
  String nPriceAlertBody(String price);

  /// No description provided for @contractsTitle.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি'**
  String get contractsTitle;

  /// No description provided for @contractNew.
  ///
  /// In bn, this message translates to:
  /// **'নতুন'**
  String get contractNew;

  /// No description provided for @contractActive.
  ///
  /// In bn, this message translates to:
  /// **'চলমান'**
  String get contractActive;

  /// No description provided for @contractPending.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষমাণ'**
  String get contractPending;

  /// No description provided for @contractDone.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন'**
  String get contractDone;

  /// No description provided for @contractRejected.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাখ্যাত'**
  String get contractRejected;

  /// No description provided for @contractCancelled.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get contractCancelled;

  /// No description provided for @contractsEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এখানে কোনো চুক্তি নেই'**
  String get contractsEmpty;

  /// No description provided for @freqMonthly.
  ///
  /// In bn, this message translates to:
  /// **'মাসিক'**
  String get freqMonthly;

  /// No description provided for @freqWeekly.
  ///
  /// In bn, this message translates to:
  /// **'সাপ্তাহিক'**
  String get freqWeekly;

  /// No description provided for @contractFarmerSub.
  ///
  /// In bn, this message translates to:
  /// **'{freq} {crop} সরবরাহ · {months} মাস'**
  String contractFarmerSub(String freq, String crop, String months);

  /// No description provided for @contractLine.
  ///
  /// In bn, this message translates to:
  /// **'{crop} – {freq} {qty}'**
  String contractLine(String crop, String freq, String qty);

  /// No description provided for @contractBuyerSub.
  ///
  /// In bn, this message translates to:
  /// **'{name} · {range}'**
  String contractBuyerSub(String name, String range);

  /// No description provided for @newContractBtn.
  ///
  /// In bn, this message translates to:
  /// **'+ নতুন চুক্তি'**
  String get newContractBtn;

  /// No description provided for @contractDetailsTitle.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তির বিবরণ'**
  String get contractDetailsTitle;

  /// No description provided for @buyerVerifiedLine.
  ///
  /// In bn, this message translates to:
  /// **'{name} (যাচাইকৃত)'**
  String buyerVerifiedLine(String name);

  /// No description provided for @contractPriceFixed.
  ///
  /// In bn, this message translates to:
  /// **'{price} / কেজি (নির্ধারিত)'**
  String contractPriceFixed(String price);

  /// No description provided for @contractTerms.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তির শর্ত'**
  String get contractTerms;

  /// No description provided for @rowTerm.
  ///
  /// In bn, this message translates to:
  /// **'মেয়াদ'**
  String get rowTerm;

  /// No description provided for @perMonthQty.
  ///
  /// In bn, this message translates to:
  /// **'প্রতি মাসে {qty}'**
  String perMonthQty(String qty);

  /// No description provided for @perWeekQty.
  ///
  /// In bn, this message translates to:
  /// **'প্রতি সপ্তাহে {qty}'**
  String perWeekQty(String qty);

  /// No description provided for @contractPayValue.
  ///
  /// In bn, this message translates to:
  /// **'প্রতি লোডের সময় (নিরাপদ লেনদেন থেকে)'**
  String get contractPayValue;

  /// No description provided for @acceptContract.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি গ্রহণ'**
  String get acceptContract;

  /// No description provided for @rejectContractQ.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি প্রত্যাখ্যান করবেন?'**
  String get rejectContractQ;

  /// No description provided for @rejectContractBody.
  ///
  /// In bn, this message translates to:
  /// **'অপর পক্ষকে জানানো হবে। এটি আর গ্রহণ করা যাবে না, তবে তারা নতুন প্রস্তাব দিতে পারবেন।'**
  String get rejectContractBody;

  /// No description provided for @cancelContractQ.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি বাতিল করবেন?'**
  String get cancelContractQ;

  /// No description provided for @cancelContractBody.
  ///
  /// In bn, this message translates to:
  /// **'বাকি সরবরাহ বন্ধ হবে। আগে লোড হওয়া পণ্যের পেমেন্ট ফেরত হবে না — যা হয়েছে তা চূড়ান্ত।'**
  String get cancelContractBody;

  /// No description provided for @yesCancelIt.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ, বাতিল করুন'**
  String get yesCancelIt;

  /// No description provided for @contractAccepted.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি গ্রহণ করা হয়েছে'**
  String get contractAccepted;

  /// No description provided for @newContractTitle.
  ///
  /// In bn, this message translates to:
  /// **'নতুন চুক্তি'**
  String get newContractTitle;

  /// No description provided for @fieldSupplier.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহকারী'**
  String get fieldSupplier;

  /// No description provided for @fieldCropGrade.
  ///
  /// In bn, this message translates to:
  /// **'ফসল ও মান'**
  String get fieldCropGrade;

  /// No description provided for @cropGradeValue.
  ///
  /// In bn, this message translates to:
  /// **'{crop}, গ্রেড {grade}'**
  String cropGradeValue(String crop, String grade);

  /// No description provided for @fieldQtyPerDelivery.
  ///
  /// In bn, this message translates to:
  /// **'পরিমাণ (প্রতি ডেলিভারি)'**
  String get fieldQtyPerDelivery;

  /// No description provided for @fieldFixedPrice.
  ///
  /// In bn, this message translates to:
  /// **'নির্ধারিত দাম'**
  String get fieldFixedPrice;

  /// No description provided for @sendContract.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি পাঠান'**
  String get sendContract;

  /// No description provided for @contractSent.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি পাঠানো হয়েছে'**
  String get contractSent;

  /// No description provided for @errSelectSupplier.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহকারী বাছুন'**
  String get errSelectSupplier;

  /// No description provided for @errSelectCrop.
  ///
  /// In bn, this message translates to:
  /// **'ফসল বাছুন'**
  String get errSelectCrop;

  /// No description provided for @searchFarmerHint.
  ///
  /// In bn, this message translates to:
  /// **'কৃষকের নাম খুঁজুন'**
  String get searchFarmerHint;

  /// No description provided for @contractStatusTitle.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তির অবস্থা'**
  String get contractStatusTitle;

  /// No description provided for @rowContract.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি'**
  String get rowContract;

  /// No description provided for @rowSupplier.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহকারী'**
  String get rowSupplier;

  /// No description provided for @rowBuyerLabel.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা'**
  String get rowBuyerLabel;

  /// No description provided for @deliverySchedule.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি সূচি'**
  String get deliverySchedule;

  /// No description provided for @monthDelivery.
  ///
  /// In bn, this message translates to:
  /// **'{month} ডেলিভারি'**
  String monthDelivery(String month);

  /// No description provided for @weekDelivery.
  ///
  /// In bn, this message translates to:
  /// **'সপ্তাহ {n} ডেলিভারি'**
  String weekDelivery(String n);

  /// No description provided for @deliveryOrdered.
  ///
  /// In bn, this message translates to:
  /// **'{qty} · অর্ডার হয়েছে'**
  String deliveryOrdered(String qty);

  /// No description provided for @deliveryDue.
  ///
  /// In bn, this message translates to:
  /// **'নির্ধারিত: {date}'**
  String deliveryDue(String date);

  /// No description provided for @cancelContract.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি বাতিল'**
  String get cancelContract;

  /// No description provided for @renewContract.
  ///
  /// In bn, this message translates to:
  /// **'নবায়ন করুন'**
  String get renewContract;

  /// No description provided for @orderDeliveryQ.
  ///
  /// In bn, this message translates to:
  /// **'এই ডেলিভারির অর্ডার দেবেন?'**
  String get orderDeliveryQ;

  /// No description provided for @orderDeliveryBody.
  ///
  /// In bn, this message translates to:
  /// **'{qty} · {amount} নিরাপদ লেনদেনে জমা থাকবে, পণ্য পৌঁছালে কৃষক পাবেন।'**
  String orderDeliveryBody(String qty, String amount);

  /// No description provided for @orderNow.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার দিন'**
  String get orderNow;

  /// No description provided for @contractRenewed.
  ///
  /// In bn, this message translates to:
  /// **'নবায়নের প্রস্তাব পাঠানো হয়েছে'**
  String get contractRenewed;

  /// No description provided for @nContractNew.
  ///
  /// In bn, this message translates to:
  /// **'নতুন চুক্তির প্রস্তাব: {crop}'**
  String nContractNew(String crop);

  /// No description provided for @nContractActive.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি গ্রহণ করেছেন: {crop}'**
  String nContractActive(String crop);

  /// No description provided for @nContractRejected.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি প্রত্যাখ্যাত: {crop}'**
  String nContractRejected(String crop);

  /// No description provided for @nContractCancelled.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি বাতিল: {crop}'**
  String nContractCancelled(String crop);

  /// No description provided for @nContractOrder.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তির ডেলিভারি অর্ডার: {no}'**
  String nContractOrder(String no);

  /// No description provided for @truckComingTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার পণ্য নিতে ট্রাক'**
  String get truckComingTitle;

  /// No description provided for @truckBookedByBuyer.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা ট্রাক বুক করেছেন'**
  String get truckBookedByBuyer;

  /// No description provided for @truckBookedBody.
  ///
  /// In bn, this message translates to:
  /// **'{name} এই ট্রাক পাঠাচ্ছেন। ভাড়া ক্রেতা দেবেন, আপনাকে কিছু বুক করতে বা দিতে হবে না।'**
  String truckBookedBody(String name);

  /// No description provided for @truckNotBooked.
  ///
  /// In bn, this message translates to:
  /// **'এখনো ট্রাক বুক হয়নি'**
  String get truckNotBooked;

  /// No description provided for @truckNotBookedBody.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা ট্রাক বুক করলে এখানে ড্রাইভার ও আপনার OTP দেখাবে।'**
  String get truckNotBookedBody;

  /// No description provided for @rowWhenComes.
  ///
  /// In bn, this message translates to:
  /// **'কখন আসবে'**
  String get rowWhenComes;

  /// No description provided for @rowWhereComes.
  ///
  /// In bn, this message translates to:
  /// **'কোথায় আসবে'**
  String get rowWhereComes;

  /// No description provided for @cropQtyComma.
  ///
  /// In bn, this message translates to:
  /// **'{a}, {b}'**
  String cropQtyComma(String a, String b);

  /// No description provided for @nameDistrict.
  ///
  /// In bn, this message translates to:
  /// **'{name}, {district}'**
  String nameDistrict(String name, String district);

  /// No description provided for @truckComingSection.
  ///
  /// In bn, this message translates to:
  /// **'যে ট্রাক আসছে'**
  String get truckComingSection;

  /// No description provided for @yourLoadOtp.
  ///
  /// In bn, this message translates to:
  /// **'আপনার OTP: {code}'**
  String yourLoadOtp(String code);

  /// No description provided for @yourLoadOtpBody.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য প্রস্তুত রাখুন। ওজন দেখে তবেই ড্রাইভারকে এই OTP দিন, সাথে সাথে টাকা পাবেন।'**
  String get yourLoadOtpBody;

  /// No description provided for @weightMoreTitle.
  ///
  /// In bn, this message translates to:
  /// **'বেশি ওজন'**
  String get weightMoreTitle;

  /// No description provided for @waitingBuyer.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতার উত্তরের অপেক্ষা'**
  String get waitingBuyer;

  /// No description provided for @waitingBuyerBody.
  ///
  /// In bn, this message translates to:
  /// **'স্কেলে {qty} বেশি এসেছে। ক্রেতা অনুমোদন দিলে বাড়তি পণ্যের টাকাও পাবেন।'**
  String waitingBuyerBody(String qty);

  /// No description provided for @rowWeighed.
  ///
  /// In bn, this message translates to:
  /// **'মাপা হয়েছে'**
  String get rowWeighed;

  /// No description provided for @rowExtraPrice.
  ///
  /// In bn, this message translates to:
  /// **'বাড়তি দাম'**
  String get rowExtraPrice;

  /// No description provided for @rowReplyTime.
  ///
  /// In bn, this message translates to:
  /// **'উত্তরের সময়'**
  String get rowReplyTime;

  /// No description provided for @minutes.
  ///
  /// In bn, this message translates to:
  /// **'{n} মিনিট'**
  String minutes(String n);

  /// No description provided for @ifNoReply.
  ///
  /// In bn, this message translates to:
  /// **'উত্তর না এলে'**
  String get ifNoReply;

  /// No description provided for @ifNoReplyBody.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা {n} মিনিটে উত্তর না দিলে শুধু {qty} লোড হবে।'**
  String ifNoReplyBody(String n, String qty);

  /// No description provided for @trackChalan.
  ///
  /// In bn, this message translates to:
  /// **'চালান ট্র্যাক করুন'**
  String get trackChalan;

  /// No description provided for @goHome.
  ///
  /// In bn, this message translates to:
  /// **'হোমে যান'**
  String get goHome;

  /// No description provided for @weightLessTitle.
  ///
  /// In bn, this message translates to:
  /// **'ওজন কম'**
  String get weightLessTitle;

  /// No description provided for @loadedTitle.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য লোড হয়েছে'**
  String get loadedTitle;

  /// No description provided for @weightLessHeading.
  ///
  /// In bn, this message translates to:
  /// **'ওজন কম ধরা পড়েছে'**
  String get weightLessHeading;

  /// No description provided for @weightLessBody.
  ///
  /// In bn, this message translates to:
  /// **'ডিজিটাল স্কেলে যত কেজি মাপা হয়েছে, আপনি ততটুকুর টাকা পেয়েছেন।'**
  String get weightLessBody;

  /// No description provided for @moneySent.
  ///
  /// In bn, this message translates to:
  /// **'টাকা পাঠানো হয়েছে!'**
  String get moneySent;

  /// No description provided for @moneySentBody.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য গাড়িতে ওঠার সাথে সাথে আপনার টাকা ছাড় হয়েছে।'**
  String get moneySentBody;

  /// No description provided for @rowWeightDigital.
  ///
  /// In bn, this message translates to:
  /// **'ওজন (ডিজিটাল)'**
  String get rowWeightDigital;

  /// No description provided for @rowReceivedTotal.
  ///
  /// In bn, this message translates to:
  /// **'মোট পেয়েছেন'**
  String get rowReceivedTotal;

  /// No description provided for @rowMethod.
  ///
  /// In bn, this message translates to:
  /// **'মাধ্যম'**
  String get rowMethod;

  /// No description provided for @moneyFinal.
  ///
  /// In bn, this message translates to:
  /// **'এই টাকা চূড়ান্ত'**
  String get moneyFinal;

  /// No description provided for @moneyFinalBody.
  ///
  /// In bn, this message translates to:
  /// **'পরে কোনো সমস্যা হলেও এই টাকা আটকানো বা ফেরত নেওয়া যাবে না।'**
  String get moneyFinalBody;

  /// No description provided for @moneyFinalLessBody.
  ///
  /// In bn, this message translates to:
  /// **'ওজন ও ছবি সংরক্ষিত আছে। বাকি টাকা ক্রেতা ফেরত পাবেন।'**
  String get moneyFinalLessBody;

  /// No description provided for @seePayments.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট দেখুন'**
  String get seePayments;

  /// No description provided for @weighTitle.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ: লোড ও ওজন'**
  String get weighTitle;

  /// No description provided for @nameDot.
  ///
  /// In bn, this message translates to:
  /// **'{a} · {b}'**
  String nameDot(String a, String b);

  /// No description provided for @gradeStop.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড {grade} · স্টপ {i}/{n}'**
  String gradeStop(String grade, String i, String n);

  /// No description provided for @oneMon.
  ///
  /// In bn, this message translates to:
  /// **'১ মন'**
  String get oneMon;

  /// No description provided for @monFixed.
  ///
  /// In bn, this message translates to:
  /// **'{kg} কেজি (নির্ধারিত)'**
  String monFixed(String kg);

  /// No description provided for @scaleNote.
  ///
  /// In bn, this message translates to:
  /// **'ডিজিটাল স্কেল · সময় ও লোকেশনসহ সংরক্ষিত'**
  String get scaleNote;

  /// No description provided for @scalePhotos.
  ///
  /// In bn, this message translates to:
  /// **'স্কেল ও পণ্যের ছবি তুলুন ({n}/{max})'**
  String scalePhotos(String n, String max);

  /// No description provided for @farmerOtp.
  ///
  /// In bn, this message translates to:
  /// **'কৃষকের OTP'**
  String get farmerOtp;

  /// No description provided for @weighNote.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক OTP দিলে লোড নিশ্চিত ও টাকা ছাড় হবে। কম হলে বাকি টাকা ক্রেতা পাবেন, বেশি হলে আগে অনুমোদন লাগবে।'**
  String get weighNote;

  /// No description provided for @notLoadedReport.
  ///
  /// In bn, this message translates to:
  /// **'লোড হয়নি? বাতিল জানান'**
  String get notLoadedReport;

  /// No description provided for @otpAndLoad.
  ///
  /// In bn, this message translates to:
  /// **'OTP দিন ও লোড নিশ্চিত করুন'**
  String get otpAndLoad;

  /// No description provided for @extraWaitNote.
  ///
  /// In bn, this message translates to:
  /// **'{extra} বেশি — ক্রেতার উত্তরের অপেক্ষা। উত্তর না এলে শুধু {qty} লোড হবে।'**
  String extraWaitNote(String extra, String qty);

  /// No description provided for @extraLoadOrdered.
  ///
  /// In bn, this message translates to:
  /// **'শুধু অর্ডারের {qty} লোড করুন'**
  String extraLoadOrdered(String qty);

  /// No description provided for @extraApprovedNote.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা অনুমোদন দিয়েছেন — {qty} লোড করুন'**
  String extraApprovedNote(String qty);

  /// No description provided for @loadDone.
  ///
  /// In bn, this message translates to:
  /// **'{qty} লোড নিশ্চিত হয়েছে'**
  String loadDone(String qty);

  /// No description provided for @weightDiffTitle.
  ///
  /// In bn, this message translates to:
  /// **'ওজনের পার্থক্য'**
  String get weightDiffTitle;

  /// No description provided for @weightLessRefund.
  ///
  /// In bn, this message translates to:
  /// **'ওজন কম হয়েছে: {amount} ফেরত পাবেন'**
  String weightLessRefund(String amount);

  /// No description provided for @weightLessRefundBody.
  ///
  /// In bn, this message translates to:
  /// **'{no} · {crop}। ডিজিটাল স্কেলে যত কেজি মাপা হয়েছে, আপনি শুধু ততটুকুর দাম দেবেন।'**
  String weightLessRefundBody(String no, String crop);

  /// No description provided for @rowOrderedKg.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার করেছিলেন'**
  String get rowOrderedKg;

  /// No description provided for @rowLoadWeighed.
  ///
  /// In bn, this message translates to:
  /// **'লোডে মাপা হয়েছে'**
  String get rowLoadWeighed;

  /// No description provided for @rowLess.
  ///
  /// In bn, this message translates to:
  /// **'কম'**
  String get rowLess;

  /// No description provided for @rowCropRefund.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের দাম ফেরত (৳ {price}/কেজি)'**
  String rowCropRefund(String price);

  /// No description provided for @rowFeeRefund.
  ///
  /// In bn, this message translates to:
  /// **'ফি ফেরত ({pct}%)'**
  String rowFeeRefund(String pct);

  /// No description provided for @rowTotalRefund.
  ///
  /// In bn, this message translates to:
  /// **'মোট ফেরত'**
  String get rowTotalRefund;

  /// No description provided for @weightLessNote.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক {qty}-এর দাম পেয়েছেন। পরিবহন ভাড়া একই থাকবে। টাকা ৩ কর্মদিবসের মধ্যে একই মাধ্যমে ফেরত যাবে।'**
  String weightLessNote(String qty);

  /// No description provided for @seeWeighReport.
  ///
  /// In bn, this message translates to:
  /// **'ওজন ও ছবির রিপোর্ট দেখুন'**
  String get seeWeighReport;

  /// No description provided for @seeRefundStatus.
  ///
  /// In bn, this message translates to:
  /// **'রিফান্ডের অবস্থা দেখুন'**
  String get seeRefundStatus;

  /// No description provided for @noLoadPhotos.
  ///
  /// In bn, this message translates to:
  /// **'লোডের সময় কোনো ছবি তোলা হয়নি'**
  String get noLoadPhotos;

  /// No description provided for @weighReportTitle.
  ///
  /// In bn, this message translates to:
  /// **'ওজন রিপোর্ট · {qty}'**
  String weighReportTitle(String qty);

  /// No description provided for @extraNeedApproval.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদন দরকার: {qty} বেশি'**
  String extraNeedApproval(String qty);

  /// No description provided for @extraNeedApprovalBody.
  ///
  /// In bn, this message translates to:
  /// **'{farmer} · {crop}। বাড়তি পণ্য নিতে চাইলে বাড়তি টাকা দিন, তারপর লোড নিশ্চিত হবে।'**
  String extraNeedApprovalBody(String farmer, String crop);

  /// No description provided for @rowScaleWeighed.
  ///
  /// In bn, this message translates to:
  /// **'স্কেলে মাপা হয়েছে'**
  String get rowScaleWeighed;

  /// No description provided for @rowMore.
  ///
  /// In bn, this message translates to:
  /// **'বেশি'**
  String get rowMore;

  /// No description provided for @rowExtraPriceAt.
  ///
  /// In bn, this message translates to:
  /// **'বাড়তি দাম (৳ {price}/কেজি)'**
  String rowExtraPriceAt(String price);

  /// No description provided for @rowFeePct.
  ///
  /// In bn, this message translates to:
  /// **'ফি ({pct}%)'**
  String rowFeePct(String pct);

  /// No description provided for @rowTotalToPay.
  ///
  /// In bn, this message translates to:
  /// **'মোট দিতে হবে'**
  String get rowTotalToPay;

  /// No description provided for @extraNote.
  ///
  /// In bn, this message translates to:
  /// **'{n} মিনিটের মধ্যে উত্তর না দিলে শুধু অর্ডারের পরিমাণ লোড হবে। অনুমোদনের পর লোড হলে এই টাকা কৃষক পেয়ে যাবেন, তখন আর ফেরত হবে না।'**
  String extraNote(String n);

  /// No description provided for @approveAndPay.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদন ও {amount} দিন'**
  String approveAndPay(String amount);

  /// No description provided for @keepOrdered.
  ///
  /// In bn, this message translates to:
  /// **'না, {qty}-ই থাক'**
  String keepOrdered(String qty);

  /// No description provided for @extraApproved.
  ///
  /// In bn, this message translates to:
  /// **'বাড়তি ওজন অনুমোদন করা হয়েছে'**
  String get extraApproved;

  /// No description provided for @extraDeclined.
  ///
  /// In bn, this message translates to:
  /// **'শুধু অর্ডারের পরিমাণ লোড হবে'**
  String get extraDeclined;

  /// No description provided for @extraExpiredNote.
  ///
  /// In bn, this message translates to:
  /// **'সময় পেরিয়ে গেছে — শুধু {qty} লোড হবে'**
  String extraExpiredNote(String qty);

  /// No description provided for @refundTitle.
  ///
  /// In bn, this message translates to:
  /// **'রিফান্ড'**
  String get refundTitle;

  /// No description provided for @refundSubCancel.
  ///
  /// In bn, this message translates to:
  /// **'{crop} – {qty} · অর্ডার বাতিল হয়েছে (ট্রাক রওনার আগে)'**
  String refundSubCancel(String crop, String qty);

  /// No description provided for @refundSubWeight.
  ///
  /// In bn, this message translates to:
  /// **'{crop} · ওজনে {qty} কম ধরা পড়েছে'**
  String refundSubWeight(String crop, String qty);

  /// No description provided for @rowCropValue.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের মূল্য'**
  String get rowCropValue;

  /// No description provided for @rowTransportCut.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহন (১০% কেটে)'**
  String get rowTransportCut;

  /// No description provided for @rowPlatformFeePct.
  ///
  /// In bn, this message translates to:
  /// **'প্ল্যাটফর্ম ফি ({pct}%)'**
  String rowPlatformFeePct(String pct);

  /// No description provided for @refundStepCancelled.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বাতিল হয়েছে'**
  String get refundStepCancelled;

  /// No description provided for @refundStepWeighed.
  ///
  /// In bn, this message translates to:
  /// **'ওজন কম ধরা পড়েছে'**
  String get refundStepWeighed;

  /// No description provided for @refundStepProcessing.
  ///
  /// In bn, this message translates to:
  /// **'টাকা ফেরতের প্রক্রিয়া চলছে'**
  String get refundStepProcessing;

  /// No description provided for @refundWithin3Days.
  ///
  /// In bn, this message translates to:
  /// **'৩ কর্মদিবসের মধ্যে'**
  String get refundWithin3Days;

  /// No description provided for @refundStepArrived.
  ///
  /// In bn, this message translates to:
  /// **'টাকা ফেরত এসেছে'**
  String get refundStepArrived;

  /// No description provided for @rowRefundTo.
  ///
  /// In bn, this message translates to:
  /// **'কোথায় ফেরত যাবে'**
  String get rowRefundTo;

  /// No description provided for @refundSameMethod.
  ///
  /// In bn, this message translates to:
  /// **'যে মাধ্যমে দিয়েছিলেন'**
  String get refundSameMethod;

  /// No description provided for @refundNote.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর থেকে, যে মাধ্যমে টাকা দিয়েছিলেন সেই মাধ্যমেই ফেরত যাবে।'**
  String get refundNote;

  /// No description provided for @getHelp.
  ///
  /// In bn, this message translates to:
  /// **'সাহায্য নিন'**
  String get getHelp;

  /// No description provided for @rowWeightDiff.
  ///
  /// In bn, this message translates to:
  /// **'ওজনের পার্থক্য'**
  String get rowWeightDiff;

  /// No description provided for @rowRefundLink.
  ///
  /// In bn, this message translates to:
  /// **'রিফান্ড'**
  String get rowRefundLink;

  /// No description provided for @answerExtraBtn.
  ///
  /// In bn, this message translates to:
  /// **'বাড়তি ওজন: উত্তর দিন'**
  String get answerExtraBtn;

  /// No description provided for @startWeighing.
  ///
  /// In bn, this message translates to:
  /// **'লোড ও ওজন শুরু করুন'**
  String get startWeighing;

  /// No description provided for @nTruckBooked.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক বুক হয়েছে: {no}'**
  String nTruckBooked(String no);

  /// No description provided for @nTruckBookedBody.
  ///
  /// In bn, this message translates to:
  /// **'{name} আসছেন — আপনার OTP দেখুন'**
  String nTruckBookedBody(String name);

  /// No description provided for @nExtraRequest.
  ///
  /// In bn, this message translates to:
  /// **'বাড়তি ওজন: {no}'**
  String nExtraRequest(String no);

  /// No description provided for @nExtraRequestBody.
  ///
  /// In bn, this message translates to:
  /// **'স্কেলে {qty} বেশি — অনুমোদন দেবেন?'**
  String nExtraRequestBody(String qty);

  /// No description provided for @nExtraApproved.
  ///
  /// In bn, this message translates to:
  /// **'বাড়তি ওজন অনুমোদিত: {no}'**
  String nExtraApproved(String no);

  /// No description provided for @nExtraDeclined.
  ///
  /// In bn, this message translates to:
  /// **'শুধু অর্ডারের পরিমাণ লোড করুন: {no}'**
  String nExtraDeclined(String no);

  /// No description provided for @nWeightLess.
  ///
  /// In bn, this message translates to:
  /// **'ওজন কম, টাকা ফেরত পাবেন: {no}'**
  String nWeightLess(String no);

  /// No description provided for @nLoadedPaid.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য লোড হয়েছে, টাকা পাঠানো হয়েছে: {no}'**
  String nLoadedPaid(String no);

  /// No description provided for @traceTitle.
  ///
  /// In bn, this message translates to:
  /// **'উৎস রেকর্ড'**
  String get traceTitle;

  /// No description provided for @traceOrderTitle.
  ///
  /// In bn, this message translates to:
  /// **'{no} · {crop} {qty}'**
  String traceOrderTitle(String no, String crop, String qty);

  /// No description provided for @traceFarmers.
  ///
  /// In bn, this message translates to:
  /// **'{n} জন কৃষক'**
  String traceFarmers(String n);

  /// No description provided for @traceDelivered.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি {date}'**
  String traceDelivered(String date);

  /// No description provided for @qrLabel.
  ///
  /// In bn, this message translates to:
  /// **'QR'**
  String get qrLabel;

  /// No description provided for @traceFarmer.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক: {name} · {district}'**
  String traceFarmer(String name, String district);

  /// No description provided for @traceReady.
  ///
  /// In bn, this message translates to:
  /// **'ফসল প্রস্তুত {date} · গ্রেড {grade}'**
  String traceReady(String date, String grade);

  /// No description provided for @traceLoadWeigh.
  ///
  /// In bn, this message translates to:
  /// **'লোড ও ডিজিটাল ওজন'**
  String get traceLoadWeigh;

  /// No description provided for @traceTransport.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহন: {name}'**
  String traceTransport(String name);

  /// No description provided for @traceSelfTransport.
  ///
  /// In bn, this message translates to:
  /// **'পরিবহন: ক্রেতার নিজের গাড়ি'**
  String get traceSelfTransport;

  /// No description provided for @traceDelivery.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি: {place}'**
  String traceDelivery(String place);

  /// No description provided for @traceOtpVerified.
  ///
  /// In bn, this message translates to:
  /// **'{time} · OTP যাচাই'**
  String traceOtpVerified(String time);

  /// No description provided for @traceReceived.
  ///
  /// In bn, this message translates to:
  /// **'{time} · ক্রেতা গ্রহণ করেছেন'**
  String traceReceived(String time);

  /// No description provided for @traceHeader.
  ///
  /// In bn, this message translates to:
  /// **'গোলাঘর উৎস রেকর্ড'**
  String get traceHeader;

  /// No description provided for @traceOrderLine.
  ///
  /// In bn, this message translates to:
  /// **'{no} · {crop} {qty}'**
  String traceOrderLine(String no, String crop, String qty);

  /// No description provided for @traceFarmerLine.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক: {name}, {district} · {qty} · {grade}'**
  String traceFarmerLine(
    String name,
    String district,
    String qty,
    String grade,
  );

  /// No description provided for @pdfShort.
  ///
  /// In bn, this message translates to:
  /// **'PDF'**
  String get pdfShort;

  /// No description provided for @qrShare.
  ///
  /// In bn, this message translates to:
  /// **'QR শেয়ার'**
  String get qrShare;

  /// No description provided for @oppTitle.
  ///
  /// In bn, this message translates to:
  /// **'বাজারের সুযোগ'**
  String get oppTitle;

  /// No description provided for @oppFilterDemand.
  ///
  /// In bn, this message translates to:
  /// **'বেশি চাহিদা'**
  String get oppFilterDemand;

  /// No description provided for @oppFilterPrice.
  ///
  /// In bn, this message translates to:
  /// **'দাম বাড়ছে'**
  String get oppFilterPrice;

  /// No description provided for @oppFilterBuyer.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা খুঁজছে'**
  String get oppFilterBuyer;

  /// No description provided for @oppHighDemand.
  ///
  /// In bn, this message translates to:
  /// **'বেশি চাহিদা · {crop}'**
  String oppHighDemand(String crop);

  /// No description provided for @oppHighDemandSub.
  ///
  /// In bn, this message translates to:
  /// **'{district} · {n} জন ক্রেতা খুঁজছেন'**
  String oppHighDemandSub(String district, String n);

  /// No description provided for @oppPriceUp.
  ///
  /// In bn, this message translates to:
  /// **'দাম বাড়ছে · {crop}'**
  String oppPriceUp(String crop);

  /// No description provided for @oppPriceUpSub.
  ///
  /// In bn, this message translates to:
  /// **'আগের দামের চেয়ে {pct} · {price}/কেজি'**
  String oppPriceUpSub(String pct, String price);

  /// No description provided for @oppSell.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রি'**
  String get oppSell;

  /// No description provided for @oppBuyerSeeking.
  ///
  /// In bn, this message translates to:
  /// **'ক্রেতা খুঁজছেন · {crop} {qty}'**
  String oppBuyerSeeking(String crop, String qty);

  /// No description provided for @oppSupply.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহ'**
  String get oppSupply;

  /// No description provided for @oppUpcoming.
  ///
  /// In bn, this message translates to:
  /// **'আগামী চাহিদা · {crop} {qty}'**
  String oppUpcoming(String crop, String qty);

  /// No description provided for @oppUpcomingSub.
  ///
  /// In bn, this message translates to:
  /// **'{buyer} · {month}-এ দরকার'**
  String oppUpcomingSub(String buyer, String month);

  /// No description provided for @oppPlan.
  ///
  /// In bn, this message translates to:
  /// **'পরিকল্পনা'**
  String get oppPlan;

  /// No description provided for @oppEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এখন কোনো সুযোগ নেই — পরে আবার দেখুন'**
  String get oppEmpty;

  /// No description provided for @planTitle.
  ///
  /// In bn, this message translates to:
  /// **'চাষের পরিকল্পনা'**
  String get planTitle;

  /// No description provided for @planIntro.
  ///
  /// In bn, this message translates to:
  /// **'বীজ বোনার আগে দেখুন কোন ফসলের নিশ্চিত চাহিদা আছে'**
  String get planIntro;

  /// No description provided for @seasonRabi.
  ///
  /// In bn, this message translates to:
  /// **'রবি (নভে–ফেব্রু)'**
  String get seasonRabi;

  /// No description provided for @seasonKharif1.
  ///
  /// In bn, this message translates to:
  /// **'খরিফ-১'**
  String get seasonKharif1;

  /// No description provided for @seasonKharif2.
  ///
  /// In bn, this message translates to:
  /// **'খরিফ-২'**
  String get seasonKharif2;

  /// No description provided for @planCropLine.
  ///
  /// In bn, this message translates to:
  /// **'{crop} – {qty}'**
  String planCropLine(String crop, String qty);

  /// No description provided for @planBuyersMore.
  ///
  /// In bn, this message translates to:
  /// **'{name} +{n}'**
  String planBuyersMore(String name, String n);

  /// No description provided for @planHighDemand.
  ///
  /// In bn, this message translates to:
  /// **'চাহিদা বেশি'**
  String get planHighDemand;

  /// No description provided for @priceRangeTk.
  ///
  /// In bn, this message translates to:
  /// **'৳ {min}–{max}'**
  String priceRangeTk(String min, String max);

  /// No description provided for @planEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এই মৌসুমে এখনো কোনো চাহিদা নেই'**
  String get planEmpty;

  /// No description provided for @planWhenPaid.
  ///
  /// In bn, this message translates to:
  /// **'টাকা কখন পাবেন'**
  String get planWhenPaid;

  /// No description provided for @planWhenPaidBody.
  ///
  /// In bn, this message translates to:
  /// **'হারভেস্টের পর পণ্য গাড়িতে উঠলেই। কোনো অগ্রিম টাকা নেই।'**
  String get planWhenPaidBody;

  /// No description provided for @planCta.
  ///
  /// In bn, this message translates to:
  /// **'চুক্তি দেখুন ও অংশ নিন'**
  String get planCta;

  /// No description provided for @rescueTitle.
  ///
  /// In bn, this message translates to:
  /// **'বিকল্প ক্রেতা'**
  String get rescueTitle;

  /// No description provided for @rescueCancelled.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বাতিল (লোডের আগে)'**
  String get rescueCancelled;

  /// No description provided for @rescueCancelledBody.
  ///
  /// In bn, this message translates to:
  /// **'{buyer} {qty} {crop}-এর অর্ডার ({no}) বাতিল করেছে। আপনার কোনো টাকা কাটা হবে না।'**
  String rescueCancelledBody(String buyer, String qty, String crop, String no);

  /// No description provided for @rescueFinding.
  ///
  /// In bn, this message translates to:
  /// **'{crop}-এর জন্য কাছের ক্রেতা খুঁজে দিচ্ছি'**
  String rescueFinding(String crop);

  /// No description provided for @rescueNone.
  ///
  /// In bn, this message translates to:
  /// **'এখন এই ফসলের কোনো খোলা চাহিদা নেই'**
  String get rescueNone;

  /// No description provided for @kmShort.
  ///
  /// In bn, this message translates to:
  /// **'{n} কিমি'**
  String kmShort(String n);

  /// No description provided for @rescueOldPrice.
  ///
  /// In bn, this message translates to:
  /// **'আগের দাম ৳{price}/কেজি'**
  String rescueOldPrice(String price);

  /// No description provided for @rescueOldAndMarket.
  ///
  /// In bn, this message translates to:
  /// **'আগের দাম ৳{price}/কেজি · বাজার দর ৳{min}–{max}'**
  String rescueOldAndMarket(String price, String min, String max);

  /// No description provided for @rescueTakeBest.
  ///
  /// In bn, this message translates to:
  /// **'সেরা অফার গ্রহণ করুন'**
  String get rescueTakeBest;

  /// No description provided for @rescueRelist.
  ///
  /// In bn, this message translates to:
  /// **'নিজের দামে আবার প্রকাশ করুন'**
  String get rescueRelist;

  /// No description provided for @rowTrace.
  ///
  /// In bn, this message translates to:
  /// **'উৎস রেকর্ড'**
  String get rowTrace;

  /// No description provided for @rowRescue.
  ///
  /// In bn, this message translates to:
  /// **'বিকল্প ক্রেতা'**
  String get rowRescue;

  /// No description provided for @seeLinkShort.
  ///
  /// In bn, this message translates to:
  /// **'দেখুন'**
  String get seeLinkShort;

  /// No description provided for @bannerOppTitle.
  ///
  /// In bn, this message translates to:
  /// **'বাজারের সুযোগ'**
  String get bannerOppTitle;

  /// No description provided for @bannerOppSub.
  ///
  /// In bn, this message translates to:
  /// **'বেশি চাহিদা ও দাম বাড়ছে এমন ফসল'**
  String get bannerOppSub;

  /// No description provided for @bannerPlanTitle.
  ///
  /// In bn, this message translates to:
  /// **'চাষের পরিকল্পনা'**
  String get bannerPlanTitle;

  /// No description provided for @bannerPlanSub.
  ///
  /// In bn, this message translates to:
  /// **'বোনার আগে নিশ্চিত চাহিদা দেখুন'**
  String get bannerPlanSub;

  /// No description provided for @assignInspTitle.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শক পাঠান'**
  String get assignInspTitle;

  /// No description provided for @assignInspBody.
  ///
  /// In bn, this message translates to:
  /// **'আপনার লোক লোডের সময় মান ও ওজন যাচাই করবেন। তিনি এই নম্বর দিয়ে গোলাঘর অ্যাপে লগইন করবেন।'**
  String get assignInspBody;

  /// No description provided for @fieldInspName.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শকের নাম'**
  String get fieldInspName;

  /// No description provided for @fieldInspPhone.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শকের মোবাইল নম্বর'**
  String get fieldInspPhone;

  /// No description provided for @sendInvite.
  ///
  /// In bn, this message translates to:
  /// **'আমন্ত্রণ পাঠান'**
  String get sendInvite;

  /// No description provided for @errNameRequired.
  ///
  /// In bn, this message translates to:
  /// **'নাম লিখুন'**
  String get errNameRequired;

  /// No description provided for @errInspNotSelf.
  ///
  /// In bn, this message translates to:
  /// **'নিজের নম্বর দেওয়া যাবে না'**
  String get errInspNotSelf;

  /// No description provided for @inspInviteText.
  ///
  /// In bn, this message translates to:
  /// **'{name}, গোলাঘর অ্যাপে আপনাকে পরিদর্শক করা হয়েছে ({no} · {crop})। অ্যাপ খুলে এই নম্বর দিয়ে লগইন করুন: {phone}'**
  String inspInviteText(String name, String no, String crop, String phone);

  /// No description provided for @inspHomeTitle.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শকের কাজ'**
  String get inspHomeTitle;

  /// No description provided for @inspInvitedBy.
  ///
  /// In bn, this message translates to:
  /// **'{buyer} আপনাকে পরিদর্শক করেছেন'**
  String inspInvitedBy(String buyer);

  /// No description provided for @inspOrderLine.
  ///
  /// In bn, this message translates to:
  /// **'{no} · {crop} {qty} · {date}'**
  String inspOrderLine(String no, String crop, String qty, String date);

  /// No description provided for @inspTruckBooked.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক বুক হয়েছে · {name}'**
  String inspTruckBooked(String name);

  /// No description provided for @inspTruckBookedBody.
  ///
  /// In bn, this message translates to:
  /// **'{place} · ট্রাক পৌঁছালে মান যাচাই শুরু করুন'**
  String inspTruckBookedBody(String place);

  /// No description provided for @inspPickups.
  ///
  /// In bn, this message translates to:
  /// **'পিকআপ ({n})'**
  String inspPickups(String n);

  /// No description provided for @inspNone.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো পরিদর্শনের কাজ নেই'**
  String get inspNone;

  /// No description provided for @numberedName.
  ///
  /// In bn, this message translates to:
  /// **'{n}. {name}'**
  String numberedName(String n, String name);

  /// No description provided for @inspStart.
  ///
  /// In bn, this message translates to:
  /// **'শুরু'**
  String get inspStart;

  /// No description provided for @inspClosed.
  ///
  /// In bn, this message translates to:
  /// **'শেষ'**
  String get inspClosed;

  /// No description provided for @inspChalan.
  ///
  /// In bn, this message translates to:
  /// **'চালানের তথ্য'**
  String get inspChalan;

  /// No description provided for @inspGrade.
  ///
  /// In bn, this message translates to:
  /// **'মান'**
  String get inspGrade;

  /// No description provided for @inspGradeValue.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড {grade} (চুক্তি অনুযায়ী)'**
  String inspGradeValue(String grade);

  /// No description provided for @inspTruck.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক'**
  String get inspTruck;

  /// No description provided for @callDriver.
  ///
  /// In bn, this message translates to:
  /// **'ড্রাইভারকে কল'**
  String get callDriver;

  /// No description provided for @seeRouteMap.
  ///
  /// In bn, this message translates to:
  /// **'ম্যাপে পথ দেখুন'**
  String get seeRouteMap;

  /// No description provided for @qcTitle.
  ///
  /// In bn, this message translates to:
  /// **'মান যাচাই · {name}'**
  String qcTitle(String name);

  /// No description provided for @partialTitle.
  ///
  /// In bn, this message translates to:
  /// **'আংশিক লোড · {name}'**
  String partialTitle(String name);

  /// No description provided for @cancelLoadTitle.
  ///
  /// In bn, this message translates to:
  /// **'লোড বাতিল · {name}'**
  String cancelLoadTitle(String name);

  /// No description provided for @gradeChecklist.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড {grade} চেকলিস্ট'**
  String gradeChecklist(String grade);

  /// No description provided for @chkSize.
  ///
  /// In bn, this message translates to:
  /// **'ন্যূনতম আকার ঠিক আছে'**
  String get chkSize;

  /// No description provided for @chkNoSprout.
  ///
  /// In bn, this message translates to:
  /// **'সবুজ বা অঙ্কুর নেই'**
  String get chkNoSprout;

  /// No description provided for @chkFirm.
  ///
  /// In bn, this message translates to:
  /// **'শক্ত, নরম বা পচা নয়'**
  String get chkFirm;

  /// No description provided for @chkDamage.
  ///
  /// In bn, this message translates to:
  /// **'সর্বোচ্চ {pct}% ক্ষতিগ্রস্ত'**
  String chkDamage(String pct);

  /// No description provided for @chkPacking.
  ///
  /// In bn, this message translates to:
  /// **'প্যাকেজিং ঠিক আছে'**
  String get chkPacking;

  /// No description provided for @chkOk.
  ///
  /// In bn, this message translates to:
  /// **'ঠিক'**
  String get chkOk;

  /// No description provided for @chkProblem.
  ///
  /// In bn, this message translates to:
  /// **'সমস্যা'**
  String get chkProblem;

  /// No description provided for @rowDigitalWeight.
  ///
  /// In bn, this message translates to:
  /// **'ডিজিটাল ওজন'**
  String get rowDigitalWeight;

  /// No description provided for @goodsPhotos.
  ///
  /// In bn, this message translates to:
  /// **'পণ্যের ছবি তুলুন ({n}/{max})'**
  String goodsPhotos(String n, String max);

  /// No description provided for @rejectPhotos.
  ///
  /// In bn, this message translates to:
  /// **'বাদ দেওয়া পণ্যের ছবি তুলুন ({n}/{max})'**
  String rejectPhotos(String n, String max);

  /// No description provided for @decApprove.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদন'**
  String get decApprove;

  /// No description provided for @decApproved.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদিত'**
  String get decApproved;

  /// No description provided for @decPartial.
  ///
  /// In bn, this message translates to:
  /// **'আংশিক'**
  String get decPartial;

  /// No description provided for @decPartialTake.
  ///
  /// In bn, this message translates to:
  /// **'আংশিক (কম নিন)'**
  String get decPartialTake;

  /// No description provided for @decCancel.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get decCancel;

  /// No description provided for @qcNote.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদনের পর কৃষক OTP দিলে টাকা ছাড় হবে। এই রিপোর্ট চূড়ান্ত।'**
  String get qcNote;

  /// No description provided for @submitReport.
  ///
  /// In bn, this message translates to:
  /// **'রিপোর্ট জমা দিন'**
  String get submitReport;

  /// No description provided for @howMuchTake.
  ///
  /// In bn, this message translates to:
  /// **'কতটুকু পণ্য নেবেন?'**
  String get howMuchTake;

  /// No description provided for @rowLeftOut.
  ///
  /// In bn, this message translates to:
  /// **'বাদ যাবে'**
  String get rowLeftOut;

  /// No description provided for @howMuchGood.
  ///
  /// In bn, this message translates to:
  /// **'ভালো পণ্য কত কেজি নেবেন?'**
  String get howMuchGood;

  /// No description provided for @scaleWeight.
  ///
  /// In bn, this message translates to:
  /// **'{qty} (স্কেল থেকে)'**
  String scaleWeight(String qty);

  /// No description provided for @reasonSmall.
  ///
  /// In bn, this message translates to:
  /// **'আকার ছোট'**
  String get reasonSmall;

  /// No description provided for @reasonDamaged.
  ///
  /// In bn, this message translates to:
  /// **'নষ্ট পণ্য'**
  String get reasonDamaged;

  /// No description provided for @reasonLowGrade.
  ///
  /// In bn, this message translates to:
  /// **'গ্রেড কম'**
  String get reasonLowGrade;

  /// No description provided for @partialNote.
  ///
  /// In bn, this message translates to:
  /// **'শুধু {qty} লোড হবে। কৃষক OTP দিলে এর টাকা ছাড় হবে। বাকি ফসলের দাম ও ফি ক্রেতা ফেরত পাবেন। ট্রাক ভাড়া একই থাকবে।'**
  String partialNote(String qty);

  /// No description provided for @errAcceptKg.
  ///
  /// In bn, this message translates to:
  /// **'০ থেকে {qty}-এর কম লিখুন'**
  String errAcceptKg(String qty);

  /// No description provided for @whyCancel.
  ///
  /// In bn, this message translates to:
  /// **'কেন বাতিল করছেন?'**
  String get whyCancel;

  /// No description provided for @rowWillLoad.
  ///
  /// In bn, this message translates to:
  /// **'লোড হবে'**
  String get rowWillLoad;

  /// No description provided for @cancelLoadNote.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য লোড হবে না, কৃষক টাকা পাবেন না। ক্রেতা ফসলের দাম ও ফি ফেরত পাবেন। ট্রাক ভাড়া ক্রেতা দেবেন।'**
  String get cancelLoadNote;

  /// No description provided for @cancelLoadBtn.
  ///
  /// In bn, this message translates to:
  /// **'লোড বাতিল করুন'**
  String get cancelLoadBtn;

  /// No description provided for @cancelLoadQ.
  ///
  /// In bn, this message translates to:
  /// **'লোড বাতিল করবেন?'**
  String get cancelLoadQ;

  /// No description provided for @cancelLoadBody.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডারটি বাতিল হবে। এই রিপোর্ট আর বদলানো যাবে না।'**
  String get cancelLoadBody;

  /// No description provided for @reportSentTitle.
  ///
  /// In bn, this message translates to:
  /// **'রিপোর্ট জমা হয়েছে'**
  String get reportSentTitle;

  /// No description provided for @reportReachedBuyer.
  ///
  /// In bn, this message translates to:
  /// **'রিপোর্ট ক্রেতার কাছে পৌঁছেছে'**
  String get reportReachedBuyer;

  /// No description provided for @rowStop.
  ///
  /// In bn, this message translates to:
  /// **'স্টপ'**
  String get rowStop;

  /// No description provided for @stopLine.
  ///
  /// In bn, this message translates to:
  /// **'{i}/{n} · {name}'**
  String stopLine(String i, String n, String name);

  /// No description provided for @rowDecision.
  ///
  /// In bn, this message translates to:
  /// **'সিদ্ধান্ত'**
  String get rowDecision;

  /// No description provided for @decApproveLine.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদন · {ok}/{n} ঠিক'**
  String decApproveLine(String ok, String n);

  /// No description provided for @decPartialLine.
  ///
  /// In bn, this message translates to:
  /// **'আংশিক · {qty} নেওয়া'**
  String decPartialLine(String qty);

  /// No description provided for @decCancelLine.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল · {reason}'**
  String decCancelLine(String reason);

  /// No description provided for @rowWeight.
  ///
  /// In bn, this message translates to:
  /// **'ওজন'**
  String get rowWeight;

  /// No description provided for @weightLeftOut.
  ///
  /// In bn, this message translates to:
  /// **'{w} ({left} বাদ)'**
  String weightLeftOut(String w, String left);

  /// No description provided for @weightNoneTaken.
  ///
  /// In bn, this message translates to:
  /// **'{w} (কিছুই নেওয়া হয়নি)'**
  String weightNoneTaken(String w);

  /// No description provided for @rowTime.
  ///
  /// In bn, this message translates to:
  /// **'সময়'**
  String get rowTime;

  /// No description provided for @whatNext.
  ///
  /// In bn, this message translates to:
  /// **'এরপর কী হবে'**
  String get whatNext;

  /// No description provided for @nextApprove.
  ///
  /// In bn, this message translates to:
  /// **'ড্রাইভার কৃষকের OTP নিলে পণ্য গাড়িতে উঠবে। এই রিপোর্ট আর বদলানো যাবে না।'**
  String get nextApprove;

  /// No description provided for @nextPartial.
  ///
  /// In bn, this message translates to:
  /// **'ড্রাইভার শুধু {qty} তুলবেন। এই রিপোর্ট আর বদলানো যাবে না।'**
  String nextPartial(String qty);

  /// No description provided for @nextCancel.
  ///
  /// In bn, this message translates to:
  /// **'এই স্টপে কোনো পণ্য উঠবে না। এই রিপোর্ট আর বদলানো যাবে না।'**
  String get nextCancel;

  /// No description provided for @nextPickups.
  ///
  /// In bn, this message translates to:
  /// **'পরের পিকআপ দেখুন'**
  String get nextPickups;

  /// No description provided for @inspReportTitle.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শন রিপোর্ট'**
  String get inspReportTitle;

  /// No description provided for @loadRecordTitle.
  ///
  /// In bn, this message translates to:
  /// **'লোডের রেকর্ড'**
  String get loadRecordTitle;

  /// No description provided for @loadDoneBadge.
  ///
  /// In bn, this message translates to:
  /// **'লোড হয়েছে'**
  String get loadDoneBadge;

  /// No description provided for @rowInspector.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শক'**
  String get rowInspector;

  /// No description provided for @inspYours.
  ///
  /// In bn, this message translates to:
  /// **'{name} (আপনার)'**
  String inspYours(String name);

  /// No description provided for @inspNotSent.
  ///
  /// In bn, this message translates to:
  /// **'পাঠাননি'**
  String get inspNotSent;

  /// No description provided for @rowTimePlace.
  ///
  /// In bn, this message translates to:
  /// **'সময় ও স্থান'**
  String get rowTimePlace;

  /// No description provided for @rowWeighedBy.
  ///
  /// In bn, this message translates to:
  /// **'ওজন নিয়েছেন'**
  String get rowWeighedBy;

  /// No description provided for @weighedByDriver.
  ///
  /// In bn, this message translates to:
  /// **'ড্রাইভার {name}'**
  String weighedByDriver(String name);

  /// No description provided for @weighedBySelf.
  ///
  /// In bn, this message translates to:
  /// **'আপনি (নিজের গাড়ি)'**
  String get weighedBySelf;

  /// No description provided for @rowReceivedFarmer.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক পেয়েছেন'**
  String get rowReceivedFarmer;

  /// No description provided for @rowChecklist.
  ///
  /// In bn, this message translates to:
  /// **'চেকলিস্ট'**
  String get rowChecklist;

  /// No description provided for @okOutOf.
  ///
  /// In bn, this message translates to:
  /// **'{ok}/{n} ঠিক'**
  String okOutOf(String ok, String n);

  /// No description provided for @rowTaken.
  ///
  /// In bn, this message translates to:
  /// **'নেওয়া হয়েছে'**
  String get rowTaken;

  /// No description provided for @leftOutWhy.
  ///
  /// In bn, this message translates to:
  /// **'{qty} ({reason})'**
  String leftOutWhy(String qty, String reason);

  /// No description provided for @rowCropValueBack.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের দাম ফেরত'**
  String get rowCropValueBack;

  /// No description provided for @reasonNotMet.
  ///
  /// In bn, this message translates to:
  /// **'মান মেলেনি ({reason})'**
  String reasonNotMet(String reason);

  /// No description provided for @yourResponsibility.
  ///
  /// In bn, this message translates to:
  /// **'মান ও পরিমাণের দায় আপনার'**
  String get yourResponsibility;

  /// No description provided for @yourResponsibilityBody.
  ///
  /// In bn, this message translates to:
  /// **'আপনি পরিদর্শক পাঠাননি। ড্রাইভার শুধু ওজন ও ছবি নিয়েছেন। লোডের পর মান নিয়ে অভিযোগ করা যাবে না।'**
  String get yourResponsibilityBody;

  /// No description provided for @yourResponsibilitySelf.
  ///
  /// In bn, this message translates to:
  /// **'আপনি নিজে ওজন ও ছবি নিয়ে লোড নিশ্চিত করেছেন। লোডের পর মান বা ওজন নিয়ে অভিযোগ করা যাবে না।'**
  String get yourResponsibilitySelf;

  /// No description provided for @reportIsProof.
  ///
  /// In bn, this message translates to:
  /// **'এই রিপোর্টই প্রমাণ'**
  String get reportIsProof;

  /// No description provided for @reportIsProofBody.
  ///
  /// In bn, this message translates to:
  /// **'লোডের সময় আপনার পরিদর্শক মান অনুমোদন করেছেন। পরে আপত্তি হলে এই রিপোর্ট দেখা হবে; কৃষকের টাকা আটকানো যাবে না।'**
  String get reportIsProofBody;

  /// No description provided for @fareSame.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক ভাড়া একই থাকবে'**
  String get fareSame;

  /// No description provided for @fareSameBody.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক আপনি বুক করেছেন, তাই ভাড়া {fare} আপনি দেবেন। ফেরতের টাকা ৩ কর্মদিবসের মধ্যে একই মাধ্যমে যাবে।'**
  String fareSameBody(String fare);

  /// No description provided for @farePayYou.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক ভাড়া আপনি দেবেন'**
  String get farePayYou;

  /// No description provided for @farePayYouBody.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাক আপনি বুক করেছেন, তাই ভাড়া {fare} ফেরত হবে না।'**
  String farePayYouBody(String fare);

  /// No description provided for @rowInspectorAssign.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শক'**
  String get rowInspectorAssign;

  /// No description provided for @inspSend.
  ///
  /// In bn, this message translates to:
  /// **'পাঠান'**
  String get inspSend;

  /// No description provided for @rowInspReport.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শন রিপোর্ট'**
  String get rowInspReport;

  /// No description provided for @rowLoadRecord.
  ///
  /// In bn, this message translates to:
  /// **'লোডের রেকর্ড'**
  String get rowLoadRecord;

  /// No description provided for @inspPresent.
  ///
  /// In bn, this message translates to:
  /// **'{name} (ক্রেতার)'**
  String inspPresent(String name);

  /// No description provided for @rowInspDecision.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শকের সিদ্ধান্ত'**
  String get rowInspDecision;

  /// No description provided for @inspWaitNote.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শকের সিদ্ধান্তের অপেক্ষা — রিপোর্টের পর লোড করুন'**
  String get inspWaitNote;

  /// No description provided for @inspPartialNote.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শক শুধু {qty} নিতে বলেছেন'**
  String inspPartialNote(String qty);

  /// No description provided for @rowInspectorWork.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শকের কাজ'**
  String get rowInspectorWork;

  /// No description provided for @nInspectionDone.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শন রিপোর্ট: {no}'**
  String nInspectionDone(String no);

  /// No description provided for @rowInspReason.
  ///
  /// In bn, this message translates to:
  /// **'কারণ'**
  String get rowInspReason;

  /// No description provided for @errInspPhoto.
  ///
  /// In bn, this message translates to:
  /// **'অন্তত একটি ছবি তুলুন'**
  String get errInspPhoto;

  /// No description provided for @rowLeftOutPast.
  ///
  /// In bn, this message translates to:
  /// **'বাদ গেছে'**
  String get rowLeftOutPast;

  /// No description provided for @rowLeftKm.
  ///
  /// In bn, this message translates to:
  /// **'বাকি দূরত্ব'**
  String get rowLeftKm;

  /// No description provided for @rowTruckSeen.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাকের অবস্থান'**
  String get rowTruckSeen;

  /// No description provided for @liveMinAgo.
  ///
  /// In bn, this message translates to:
  /// **'{n} মিনিট আগে'**
  String liveMinAgo(String n);

  /// No description provided for @liveJustNow.
  ///
  /// In bn, this message translates to:
  /// **'এইমাত্র'**
  String get liveJustNow;

  /// No description provided for @liveOff.
  ///
  /// In bn, this message translates to:
  /// **'চালকের অ্যাপ খোলা থাকলে দেখাবে'**
  String get liveOff;

  /// No description provided for @voiceMessage.
  ///
  /// In bn, this message translates to:
  /// **'ভয়েস বার্তা'**
  String get voiceMessage;

  /// No description provided for @voiceMessageLen.
  ///
  /// In bn, this message translates to:
  /// **'ভয়েস বার্তা · {len}'**
  String voiceMessageLen(String len);

  /// No description provided for @voiceRecording.
  ///
  /// In bn, this message translates to:
  /// **'ভয়েস রেকর্ড হচ্ছে... {len}'**
  String voiceRecording(String len);

  /// No description provided for @voiceSend.
  ///
  /// In bn, this message translates to:
  /// **'পাঠান'**
  String get voiceSend;

  /// No description provided for @voiceSendSub.
  ///
  /// In bn, this message translates to:
  /// **'রেকর্ড করা বার্তা পাঠান'**
  String get voiceSendSub;

  /// No description provided for @voiceCancel.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get voiceCancel;

  /// No description provided for @voiceCancelSub.
  ///
  /// In bn, this message translates to:
  /// **'রেকর্ড মুছে ফেলুন'**
  String get voiceCancelSub;

  /// No description provided for @micDenied.
  ///
  /// In bn, this message translates to:
  /// **'মাইক্রোফোনের অনুমতি দিন (সেটিংস → অ্যাপ → গোলাঘর)'**
  String get micDenied;

  /// No description provided for @voiceSearchListening.
  ///
  /// In bn, this message translates to:
  /// **'শুনছি... ফসল বা এলাকার নাম বলুন'**
  String get voiceSearchListening;

  /// No description provided for @voiceSearchStop.
  ///
  /// In bn, this message translates to:
  /// **'থামান'**
  String get voiceSearchStop;

  /// No description provided for @voiceSearchStopSub.
  ///
  /// In bn, this message translates to:
  /// **'বলা শেষ হলে চাপুন'**
  String get voiceSearchStopSub;

  /// No description provided for @voiceSearchExample.
  ///
  /// In bn, this message translates to:
  /// **'উদাহরণ'**
  String get voiceSearchExample;

  /// No description provided for @voiceSearchExampleSub.
  ///
  /// In bn, this message translates to:
  /// **'“টমেটো”, “আলু নেত্রকোনা”'**
  String get voiceSearchExampleSub;

  /// No description provided for @voiceSearchUnavailable.
  ///
  /// In bn, this message translates to:
  /// **'এই ফোনে ভয়েস সার্চ চালু নেই'**
  String get voiceSearchUnavailable;

  /// No description provided for @pdfMaking.
  ///
  /// In bn, this message translates to:
  /// **'PDF তৈরি হচ্ছে...'**
  String get pdfMaking;

  /// No description provided for @locAskTitle.
  ///
  /// In bn, this message translates to:
  /// **'ট্রাকের অবস্থান জানাতে অনুমতি দিন'**
  String get locAskTitle;

  /// No description provided for @locAskBody.
  ///
  /// In bn, this message translates to:
  /// **'ট্রিপ চলার সময় ক্রেতা ও কৃষক ম্যাপে আপনার ট্রাক দেখতে পাবেন। পরের বক্সে “While using the app” চাপুন।'**
  String get locAskBody;

  /// No description provided for @locAskLater.
  ///
  /// In bn, this message translates to:
  /// **'পরে'**
  String get locAskLater;

  /// No description provided for @locAskAllow.
  ///
  /// In bn, this message translates to:
  /// **'অনুমতি দিন'**
  String get locAskAllow;

  /// No description provided for @stdTitle.
  ///
  /// In bn, this message translates to:
  /// **'মান নির্ধারণ'**
  String get stdTitle;

  /// No description provided for @stdHeading.
  ///
  /// In bn, this message translates to:
  /// **'{crop} · গ্রেড {grade}'**
  String stdHeading(String crop, String grade);

  /// No description provided for @stdRowSize.
  ///
  /// In bn, this message translates to:
  /// **'ন্যূনতম আকার'**
  String get stdRowSize;

  /// No description provided for @stdRowColor.
  ///
  /// In bn, this message translates to:
  /// **'রং'**
  String get stdRowColor;

  /// No description provided for @stdRowRipe.
  ///
  /// In bn, this message translates to:
  /// **'পাকা'**
  String get stdRowRipe;

  /// No description provided for @stdRowDamage.
  ///
  /// In bn, this message translates to:
  /// **'সর্বোচ্চ ক্ষতিগ্রস্ত'**
  String get stdRowDamage;

  /// No description provided for @stdRowPack.
  ///
  /// In bn, this message translates to:
  /// **'প্যাকেজিং'**
  String get stdRowPack;

  /// No description provided for @stdWhenTitle.
  ///
  /// In bn, this message translates to:
  /// **'কখন যাচাই হবে'**
  String get stdWhenTitle;

  /// No description provided for @stdWhenBody.
  ///
  /// In bn, this message translates to:
  /// **'শুধু লোডের সময় (আপনার পরিদর্শকের চেকলিস্ট)। ডেলিভারির পর এই মান দিয়ে টাকা ফেরত চাওয়া যাবে না।'**
  String get stdWhenBody;

  /// No description provided for @stdUse.
  ///
  /// In bn, this message translates to:
  /// **'এই মান ব্যবহার করুন'**
  String get stdUse;

  /// No description provided for @stdCheckLine.
  ///
  /// In bn, this message translates to:
  /// **'{label}: {value}'**
  String stdCheckLine(String label, String value);

  /// No description provided for @stdSizeAcross.
  ///
  /// In bn, this message translates to:
  /// **'{n} সেমি ব্যাস'**
  String stdSizeAcross(String n);

  /// No description provided for @stdSizeLength.
  ///
  /// In bn, this message translates to:
  /// **'{n} সেমি লম্বা'**
  String stdSizeLength(String n);

  /// No description provided for @stdSizeGrams.
  ///
  /// In bn, this message translates to:
  /// **'প্রতিটি {n} গ্রাম'**
  String stdSizeGrams(String n);

  /// No description provided for @stdSizeGrain.
  ///
  /// In bn, this message translates to:
  /// **'পুষ্ট দানা, চিটা ≤{n}%'**
  String stdSizeGrain(String n);

  /// No description provided for @stdSizeEven.
  ///
  /// In bn, this message translates to:
  /// **'সমান আকার'**
  String get stdSizeEven;

  /// No description provided for @stdDamagePct.
  ///
  /// In bn, this message translates to:
  /// **'{n}%'**
  String stdDamagePct(String n);

  /// No description provided for @stdColorRed.
  ///
  /// In bn, this message translates to:
  /// **'{n}% লাল'**
  String stdColorRed(String n);

  /// No description provided for @stdColorPotato.
  ///
  /// In bn, this message translates to:
  /// **'হালকা বাদামি, সবুজ দাগ নেই'**
  String get stdColorPotato;

  /// No description provided for @stdColorPaddy.
  ///
  /// In bn, this message translates to:
  /// **'সোনালি'**
  String get stdColorPaddy;

  /// No description provided for @stdColorEggplant.
  ///
  /// In bn, this message translates to:
  /// **'উজ্জ্বল বেগুনি, চকচকে'**
  String get stdColorEggplant;

  /// No description provided for @stdColorOnion.
  ///
  /// In bn, this message translates to:
  /// **'লালচে, শুকনো খোসা'**
  String get stdColorOnion;

  /// No description provided for @stdColorChili.
  ///
  /// In bn, this message translates to:
  /// **'উজ্জ্বল সবুজ'**
  String get stdColorChili;

  /// No description provided for @stdColorMango.
  ///
  /// In bn, this message translates to:
  /// **'পরিপক্ব সবুজ থেকে হলুদ'**
  String get stdColorMango;

  /// No description provided for @stdColorNatural.
  ///
  /// In bn, this message translates to:
  /// **'স্বাভাবিক রং'**
  String get stdColorNatural;

  /// No description provided for @stdRipeTomato.
  ///
  /// In bn, this message translates to:
  /// **'আধা-পাকা থেকে পাকা'**
  String get stdRipeTomato;

  /// No description provided for @stdRipePotato.
  ///
  /// In bn, this message translates to:
  /// **'পরিপক্ব, খোসা শক্ত'**
  String get stdRipePotato;

  /// No description provided for @stdRipePaddy.
  ///
  /// In bn, this message translates to:
  /// **'পুরো পাকা, আর্দ্রতা ≤{n}%'**
  String stdRipePaddy(String n);

  /// No description provided for @stdRipeEggplant.
  ///
  /// In bn, this message translates to:
  /// **'কচি, বীজ নরম'**
  String get stdRipeEggplant;

  /// No description provided for @stdRipeOnion.
  ///
  /// In bn, this message translates to:
  /// **'পুরো শুকানো, অঙ্কুর নেই'**
  String get stdRipeOnion;

  /// No description provided for @stdRipeChili.
  ///
  /// In bn, this message translates to:
  /// **'তাজা ও শক্ত'**
  String get stdRipeChili;

  /// No description provided for @stdRipeMango.
  ///
  /// In bn, this message translates to:
  /// **'পরিপক্ব, শক্ত'**
  String get stdRipeMango;

  /// No description provided for @stdRipeMarket.
  ///
  /// In bn, this message translates to:
  /// **'বাজারজাত উপযোগী'**
  String get stdRipeMarket;

  /// No description provided for @stdPackCrate.
  ///
  /// In bn, this message translates to:
  /// **'{n} কেজির ক্রেট'**
  String stdPackCrate(String n);

  /// No description provided for @stdPackSack.
  ///
  /// In bn, this message translates to:
  /// **'{n} কেজির বস্তা'**
  String stdPackSack(String n);

  /// No description provided for @stdPackNet.
  ///
  /// In bn, this message translates to:
  /// **'{n} কেজির জালি বস্তা'**
  String stdPackNet(String n);

  /// No description provided for @stdPackBag.
  ///
  /// In bn, this message translates to:
  /// **'{n} কেজির ব্যাগ'**
  String stdPackBag(String n);

  /// No description provided for @stdPackClean.
  ///
  /// In bn, this message translates to:
  /// **'পরিষ্কার বস্তা বা ক্রেট'**
  String get stdPackClean;

  /// No description provided for @tpProfileTitle.
  ///
  /// In bn, this message translates to:
  /// **'ট্রান্সপোর্টারের প্রোফাইল'**
  String get tpProfileTitle;

  /// No description provided for @tpVerifiedDriver.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত চালক'**
  String get tpVerifiedDriver;

  /// No description provided for @tpDriver.
  ///
  /// In bn, this message translates to:
  /// **'চালক'**
  String get tpDriver;

  /// No description provided for @tpSince.
  ///
  /// In bn, this message translates to:
  /// **'{date} থেকে গোলাঘরে'**
  String tpSince(String date);

  /// No description provided for @tpTrips.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন ট্রিপ'**
  String get tpTrips;

  /// No description provided for @tpOnTime.
  ///
  /// In bn, this message translates to:
  /// **'সময়মতো'**
  String get tpOnTime;

  /// No description provided for @tpCancelRate.
  ///
  /// In bn, this message translates to:
  /// **'বাতিলের হার'**
  String get tpCancelRate;

  /// No description provided for @tpDamage.
  ///
  /// In bn, this message translates to:
  /// **'ক্ষতির অভিযোগ'**
  String get tpDamage;

  /// No description provided for @tpTruckLine.
  ///
  /// In bn, this message translates to:
  /// **'{type} · {cap} · {status}'**
  String tpTruckLine(String type, String cap, String status);

  /// No description provided for @tpFitness.
  ///
  /// In bn, this message translates to:
  /// **'ফিটনেস ও লাইসেন্স'**
  String get tpFitness;

  /// No description provided for @tpValid.
  ///
  /// In bn, this message translates to:
  /// **'বৈধ'**
  String get tpValid;

  /// No description provided for @tpMainRoute.
  ///
  /// In bn, this message translates to:
  /// **'প্রধান রুট'**
  String get tpMainRoute;

  /// No description provided for @tpRoute.
  ///
  /// In bn, this message translates to:
  /// **'{from} – {to}'**
  String tpRoute(String from, String to);

  /// No description provided for @tpChoose.
  ///
  /// In bn, this message translates to:
  /// **'এই ট্রান্সপোর্টার বাছুন'**
  String get tpChoose;

  /// No description provided for @pctText.
  ///
  /// In bn, this message translates to:
  /// **'{n}%'**
  String pctText(String n);

  /// No description provided for @supTitle.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহকারী'**
  String get supTitle;

  /// No description provided for @supSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক বা এলাকা খুঁজুন'**
  String get supSearchHint;

  /// No description provided for @supAll.
  ///
  /// In bn, this message translates to:
  /// **'সব'**
  String get supAll;

  /// No description provided for @supFav.
  ///
  /// In bn, this message translates to:
  /// **'পছন্দের'**
  String get supFav;

  /// No description provided for @supNew.
  ///
  /// In bn, this message translates to:
  /// **'নতুন'**
  String get supNew;

  /// No description provided for @supFavTag.
  ///
  /// In bn, this message translates to:
  /// **'পছন্দের'**
  String get supFavTag;

  /// No description provided for @supLine.
  ///
  /// In bn, this message translates to:
  /// **'{district} · {rating} · {n} লেনদেন'**
  String supLine(String district, String rating, String n);

  /// No description provided for @supEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো সরবরাহকারী নেই — বাজার থেকে অর্ডার করুন'**
  String get supEmpty;

  /// No description provided for @supProfileTitle.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহকারীর প্রোফাইল'**
  String get supProfileTitle;

  /// No description provided for @supStatusLine.
  ///
  /// In bn, this message translates to:
  /// **'{status} · {district}'**
  String supStatusLine(String status, String district);

  /// No description provided for @supQuality.
  ///
  /// In bn, this message translates to:
  /// **'মানের স্কোর'**
  String get supQuality;

  /// No description provided for @supTotal.
  ///
  /// In bn, this message translates to:
  /// **'মোট সরবরাহ'**
  String get supTotal;

  /// No description provided for @supPerf.
  ///
  /// In bn, this message translates to:
  /// **'পারফরম্যান্স ({n} মাস)'**
  String supPerf(String n);

  /// No description provided for @supCommitted.
  ///
  /// In bn, this message translates to:
  /// **'প্রতিশ্রুত বনাম সরবরাহকৃত'**
  String get supCommitted;

  /// No description provided for @supAcceptance.
  ///
  /// In bn, this message translates to:
  /// **'মান গ্রহণযোগ্যতা'**
  String get supAcceptance;

  /// No description provided for @supAddFav.
  ///
  /// In bn, this message translates to:
  /// **'পছন্দের তালিকায়'**
  String get supAddFav;

  /// No description provided for @supRemoveFav.
  ///
  /// In bn, this message translates to:
  /// **'পছন্দ থেকে সরান'**
  String get supRemoveFav;

  /// No description provided for @toastFavAdded.
  ///
  /// In bn, this message translates to:
  /// **'পছন্দের তালিকায় যোগ হয়েছে'**
  String get toastFavAdded;

  /// No description provided for @toastFavRemoved.
  ///
  /// In bn, this message translates to:
  /// **'পছন্দের তালিকা থেকে সরানো হয়েছে'**
  String get toastFavRemoved;

  /// No description provided for @toastUndo.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get toastUndo;

  /// No description provided for @procTitle.
  ///
  /// In bn, this message translates to:
  /// **'সংগ্রহ ড্যাশবোর্ড'**
  String get procTitle;

  /// No description provided for @procOpenDemands.
  ///
  /// In bn, this message translates to:
  /// **'চলমান চাহিদা'**
  String get procOpenDemands;

  /// No description provided for @procCommitted.
  ///
  /// In bn, this message translates to:
  /// **'মোট প্রতিশ্রুত'**
  String get procCommitted;

  /// No description provided for @procFarmers.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক যুক্ত'**
  String get procFarmers;

  /// No description provided for @procSafePay.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেন'**
  String get procSafePay;

  /// No description provided for @procPeople.
  ///
  /// In bn, this message translates to:
  /// **'{n} জন'**
  String procPeople(String n);

  /// No description provided for @procOngoing.
  ///
  /// In bn, this message translates to:
  /// **'চলমান সংগ্রহ'**
  String get procOngoing;

  /// No description provided for @procLine.
  ///
  /// In bn, this message translates to:
  /// **'{crop} – {qty}'**
  String procLine(String crop, String qty);

  /// No description provided for @procNone.
  ///
  /// In bn, this message translates to:
  /// **'কোনো চলমান চাহিদা নেই'**
  String get procNone;

  /// No description provided for @procAnalytics.
  ///
  /// In bn, this message translates to:
  /// **'ক্রয় বিশ্লেষণ'**
  String get procAnalytics;

  /// No description provided for @procAnalyticsSub.
  ///
  /// In bn, this message translates to:
  /// **'খরচ, দামের প্রবণতা ও সরবরাহকারীর পারফরম্যান্স'**
  String get procAnalyticsSub;

  /// No description provided for @anMonth.
  ///
  /// In bn, this message translates to:
  /// **'এ মাস'**
  String get anMonth;

  /// No description provided for @an3Months.
  ///
  /// In bn, this message translates to:
  /// **'৩ মাস'**
  String get an3Months;

  /// No description provided for @anYear.
  ///
  /// In bn, this message translates to:
  /// **'এ বছর'**
  String get anYear;

  /// No description provided for @anSpend.
  ///
  /// In bn, this message translates to:
  /// **'মোট খরচ'**
  String get anSpend;

  /// No description provided for @anAvgPrice.
  ///
  /// In bn, this message translates to:
  /// **'গড় দাম ({crop})'**
  String anAvgPrice(String crop);

  /// No description provided for @anSuppliers.
  ///
  /// In bn, this message translates to:
  /// **'সরবরাহকারীর পারফরম্যান্স'**
  String get anSuppliers;

  /// No description provided for @anDeliveredLeft.
  ///
  /// In bn, this message translates to:
  /// **'ডেলিভারি / বাকি'**
  String get anDeliveredLeft;

  /// No description provided for @anWithInspector.
  ///
  /// In bn, this message translates to:
  /// **'পরিদর্শকসহ অর্ডার'**
  String get anWithInspector;

  /// No description provided for @anSlash.
  ///
  /// In bn, this message translates to:
  /// **'{a} / {b}'**
  String anSlash(String a, String b);

  /// No description provided for @anNoData.
  ///
  /// In bn, this message translates to:
  /// **'এই সময়ে কোনো অর্ডার নেই'**
  String get anNoData;

  /// No description provided for @takaLakh.
  ///
  /// In bn, this message translates to:
  /// **'৳ {n} লাখ'**
  String takaLakh(String n);
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
