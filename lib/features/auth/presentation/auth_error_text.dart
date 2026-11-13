import '../../../l10n/app_localizations.dart';
import '../data/auth_repository.dart';

String authErrorText(AppLocalizations l, AuthErrorCode code) => switch (code) {
      AuthErrorCode.invalidPhone => l.loginInvalidPhone,
      AuthErrorCode.invalidCode => l.otpWrong,
      AuthErrorCode.tooManyRequests => l.errorTooManyRequests,
      AuthErrorCode.network => l.errorNetwork,
      AuthErrorCode.unknown => l.errorGeneric,
    };
