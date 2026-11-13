import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import 'auth_error_text.dart';
import 'phone_auth_controller.dart';

/// 06 Sign Up / Login (Figma 292:309).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  String? _fieldError;

  static const _imageHeight = 260.0;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final local = BdPhone.normalizeLocal(_phone.text);
    if (local == null) {
      setState(() => _fieldError = l.loginInvalidPhone);
      return;
    }
    setState(() => _fieldError = null);
    FocusScope.of(context).unfocus();
    final sent = await ref.read(phoneAuthProvider.notifier).sendCode(local);
    if (sent && mounted) context.push(Routes.otp);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final st = ref.watch(phoneAuthProvider);
    final error = _fieldError ??
        (st.error == null ? null : authErrorText(l, st.error!));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: l.loginTitle,
        // Login is reached by redirect (no history): back = onboarding again.
        onBack: () => ref.read(onboardingDoneProvider.notifier).reset(),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
              AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: Image.asset(AppImages.handshake,
                    height: _imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover),
              ),
              const SizedBox(height: AppSpacing.block),
              Text(l.loginHeading, style: AppTypography.headingBold22.normal),
              const SizedBox(height: AppSpacing.block),
              Text(l.loginSub,
                  style: AppTypography.bodyMedium.normal
                      .withColor(AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.block),
              KsTextField(
                label: l.loginPhoneLabel,
                hint: l.loginPhoneHint,
                controller: _phone,
                suffixText: l.loginCountryCode,
                suffixColor: AppColors.textSuccess,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                maxLength: 14,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯+\s-]')),
                ],
                errorText: error,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(
                  height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
              Text(l.loginTerms,
                  style: AppTypography.caption.normal
                      .withColor(AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.block),
              KsButton(
                label: l.loginSendCode,
                loading: st.sending,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
