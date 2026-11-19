import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import 'auth_error_text.dart';
import 'phone_auth_controller.dart';

/// 07 OTP Verification (Figma 292:323).
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _len = 6;
  static const _resendSeconds = 45;
  static const _boxW = 44.0;
  static const _boxH = 52.0;

  final _code = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _left = _resendSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _code.addListener(() => setState(() {}));
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _left = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) t.cancel();
      setState(() => _left = (_left - 1).clamp(0, _resendSeconds));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _resend() async {
    final phone = ref.read(phoneAuthProvider).localPhone;
    if (phone == null) return;
    _code.clear();
    final ok = await ref
        .read(phoneAuthProvider.notifier)
        .sendCode(phone, resend: true);
    if (ok) _startTimer();
  }

  void _verify() {
    if (_code.text.length != _len) return;
    FocusScope.of(context).unfocus();
    ref.read(phoneAuthProvider.notifier).verify(_code.text);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final st = ref.watch(phoneAuthProvider);
    final phone = st.localPhone == null
        ? ''
        : BdPhone.pretty(st.localPhone!);
    final text = _code.text;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.otpTitle),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
              AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.otpHeading, style: AppTypography.headingBold22.normal),
              const SizedBox(height: AppSpacing.block),
              Text(l.otpSub(phone),
                  style: AppTypography.bodyMedium.normal
                      .withColor(AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.block),
              // Six digit boxes on top of one hidden text field.
              GestureDetector(
                onTap: () => _focus.requestFocus(),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0,
                      child: SizedBox(
                        height: _boxH,
                        child: TextField(
                          controller: _code,
                          focusNode: _focus,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          maxLength: _len,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9০-৯]')),
                          ],
                          onChanged: (v) {
                            // Typing again removes the red "wrong code".
                            ref.read(phoneAuthProvider.notifier).clearError();
                            if (v.length == _len) _verify();
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _len; i++) ...[
                          if (i > 0) const SizedBox(width: AppSpacing.sm),
                          _DigitBox(
                            width: _boxW,
                            height: _boxH,
                            digit: i < text.length
                                ? Fmt.digits(context, text[i])
                                : null,
                            error: st.error != null,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (st.error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(authErrorText(l, st.error!),
                    style:
                        AppTypography.caption.withColor(AppColors.textError)),
              ],
              const SizedBox(height: AppSpacing.block),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.otpNoCode,
                      style: AppTypography.bodyMediumStrong.normal),
                  _left > 0
                      ? Text(l.otpResendIn(Fmt.timer(context, _left)),
                          style: AppTypography.bodyMediumEmphasis.normal
                              .withColor(AppColors.textSecondary))
                      : GestureDetector(
                          onTap: st.sending ? null : _resend,
                          child: Text(l.otpResend,
                              style: AppTypography.bodyMediumEmphasis.normal
                                  .withColor(AppColors.textBrand)),
                        ),
                ],
              ),
              const SizedBox(
                  height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
              KsButton(
                label: l.otpVerify,
                loading: st.verifying,
                onPressed: text.length == _len ? _verify : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DigitBox extends StatelessWidget {
  const _DigitBox({
    required this.width,
    required this.height,
    required this.digit,
    required this.error,
  });

  final double width;
  final double height;
  final String? digit;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final filled = digit != null;
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: error
              ? AppColors.borderError
              : filled
                  ? AppColors.borderBrand
                  : AppColors.borderDefault,
        ),
      ),
      child: Text(digit ?? '', style: AppTypography.headingBold20.normal),
    );
  }
}
