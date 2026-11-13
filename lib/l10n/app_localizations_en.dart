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
}
