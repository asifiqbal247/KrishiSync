import 'package:flutter/gestures.dart';
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
import '../../../shared/widgets/ks_hero.dart';
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
  late final _termsTap = TapGestureRecognizer()
    ..onTap = () => context.push(Routes.terms);

  /// Figma hero photo height (the heading starts below it).
  static const _heroH = 352.0;

  @override
  void initState() {
    super.initState();
    // An error from an earlier sign-in (e.g. a slow one before logout)
    // must not show on a fresh login screen.
    Future.microtask(() => ref.read(phoneAuthProvider.notifier).clearError());
  }

  @override
  void dispose() {
    _phone.dispose();
    _termsTap.dispose();
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
    final error =
        _fieldError ?? (st.error == null ? null : authErrorText(l, st.error!));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: KsAppBar(
        title: l.loginTitle,
        onImage: true,
        // Login is reached by redirect (no history): back = onboarding again.
        onBack: () => ref.read(onboardingDoneProvider.notifier).reset(),
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  KsHeroPhoto(
                    figmaHeight: _heroH,
                    image: Image.asset(AppImages.handshake, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      KsHeroPhoto.gap,
                      AppSpacing.screen,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.loginHeading,
                          style: AppTypography.headingBold22.normal,
                        ),
                        const SizedBox(height: AppSpacing.block),
                        Text(
                          l.loginSub,
                          style: AppTypography.bodyMedium.normal.withColor(
                            AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.block),
                        KsTextField(
                          label: l.loginPhoneLabel,
                          hint: l.loginPhoneHint,
                          controller: _phone,
                          prefixText: l.loginCountryCode,
                          prefixColor: AppColors.textSuccess,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          maxLength: 14,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9০-৯+\s-]'),
                            ),
                          ],
                          errorText: error,
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(
                          height:
                              AppSpacing.block +
                              AppSpacing.xs +
                              AppSpacing.block,
                        ),
                        Text.rich(
                          TextSpan(
                            style: AppTypography.caption.normal.withColor(
                              AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(text: l.loginTermsPre),
                              TextSpan(
                                text: l.loginTermsLink,
                                style: const TextStyle(
                                  color: AppColors.textBrand,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.textBrand,
                                ),
                                recognizer: _termsTap,
                              ),
                              TextSpan(text: l.loginTermsPost),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.block),
                        KsButton(
                          label: l.loginSendCode,
                          loading: st.sending,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const KsHeroShade(),
        ],
      ),
    );
  }
}
