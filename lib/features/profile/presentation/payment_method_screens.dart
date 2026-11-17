import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_option_card.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/phone_auth_controller.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);
const _gapBeforeCta = AppSpacing.block + AppSpacing.xs + AppSpacing.block;

String payoutTypeLabel(AppLocalizations l, String t) => switch (t) {
  'nagad' => l.pmNagad,
  'rocket' => l.pmRocket,
  'bank' => l.pmBank,
  _ => l.pmBkash,
};

/// One-line summary for profile/payments rows: "বিকাশ · 01712-XXXXXX".
String payoutLine(AppLocalizations l, PayoutMethod m) => l.pmWalletLine(
  m.isBank ? (m.bank ?? l.pmBank) : payoutTypeLabel(l, m.type),
  m.masked,
);

/// Common banks in Bangladesh (bank account form 201).
const _banks = [
  'Sonali Bank',
  'Janata Bank',
  'Agrani Bank',
  'Rupali Bank',
  'Bangladesh Krishi Bank',
  'Dutch-Bangla Bank',
  'BRAC Bank',
  'Islami Bank Bangladesh',
  'City Bank',
  'Eastern Bank',
  'Pubali Bank',
  'Prime Bank',
  'Mutual Trust Bank',
  'Bank Asia',
  'Dhaka Bank',
];

Widget _wallet() => Container(
  color: AppColors.bgSubtle,
  padding: const EdgeInsets.all(AppSpacing.md),
  child: Image.asset(AppUi.glyphWallet),
);

/// 197 Payment Methods (Figma 292:3520).
class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    if (me == null) return const Scaffold(body: KsSkeletonList());
    final methods = me.payoutMethods;
    final def = me.defaultPayout;

    Future<void> makeDefault(PayoutMethod m) async {
      await ref.read(userRepositoryProvider).savePayoutMethods(me.uid, [
        for (final x in methods) x.copyWith(isDefault: identical(x, m)),
      ]);
    }

    // Remove (confirm). Removing the default asks for a new default.
    Future<void> remove(PayoutMethod m) async {
      final ok = await showKsConfirm(
        context,
        title: l.pmRemoveTitle,
        body: l.pmRemoveBody(payoutLine(l, m)),
        noLabel: l.commonNo,
        yesLabel: l.pmRemove,
      );
      if (!ok || !context.mounted) return;
      final rest = [
        for (final x in methods)
          if (!identical(x, m)) x,
      ];
      PayoutMethod? next;
      if (identical(m, def) && rest.isNotEmpty) {
        next = rest.length == 1
            ? rest.first
            : await _chooseDefault(context, l, rest);
        if (next == null) return; // sheet closed: nothing removed
      }
      try {
        await ref.read(userRepositoryProvider).savePayoutMethods(me.uid, [
          for (final x in rest)
            next == null ? x : x.copyWith(isDefault: identical(x, next)),
        ]);
        if (context.mounted) KsToast.show(context, l.pmRemoved);
      } catch (_) {
        if (context.mounted) KsToast.show(context, l.errorGeneric);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.pmTitle),
      body: ListView(
        padding: _pad,
        children: [
          Text(
            l.pmIntro,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          if (methods.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              l.pmNone,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.normal.withColor(
                AppColors.textSecondary,
              ),
            ),
          ],
          for (final m in methods) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: _wallet(),
              highlighted: identical(m, def),
              title: payoutLine(l, m),
              subtitle: m.isBank
                  ? l.placeDate(
                      m.accountName,
                      l.pmBankSub(m.bank ?? '', m.branch ?? ''),
                    )
                  : l.placeDate(
                      l.pmNameMatched(m.accountName),
                      l.pmVerifiedShort,
                    ),
              trailingText: identical(m, def) ? l.pmDefault : l.pmMakeDefault,
              onTap: identical(m, def) ? null : () => makeDefault(m),
              showChevron: false,
              trailing: Semantics(
                button: true,
                label: l.pmRemove,
                child: InkResponse(
                  onTap: () => remove(m),
                  child: const AppIcon(
                    AppIcons.close,
                    size: AppSizes.iconSm,
                    color: AppColors.iconError,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsButton.secondary(
            label: l.pmAdd,
            onPressed: () => context.push(Routes.addPayout),
          ),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
            title: l.pmSafetyTitle,
            body: l.pmSafetyBody,
            warning: true,
          ),
        ],
      ),
    );
  }
}

/// 198 Add Payment Method (Figma 292:3531).
class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPmState();
}

class _AddPmState extends State<AddPaymentMethodScreen> {
  String _type = 'bkash';
  static const _img = 36.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final options = [
      ('bkash', l.pmBkash, l.pmWalletInstant),
      ('nagad', l.pmNagad, l.pmWalletInstant),
      ('rocket', l.pmRocket, l.pmWallet),
      ('bank', l.pmBank, l.pmBankSlow),
    ];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.pmAddTitle),
      body: ListView(
        padding: _pad,
        children: [
          Text(l.pmWhich, style: AppTypography.bodyMediumStrong.normal),
          for (final (t, title, sub) in options) ...[
            const SizedBox(height: AppSpacing.block),
            KsOptionCard(
              image: const AssetImage(AppUi.glyphWallet),
              imageSize: _img,
              title: title,
              subtitle: sub,
              selected: _type == t,
              onTap: () => setState(() => _type = t),
            ),
          ],
          const SizedBox(height: _gapBeforeCta),
          KsButton(
            label: l.sellNext,
            onPressed: () => context.pushReplacement(
              _type == 'bank' ? Routes.addBank : Routes.addWallet(_type),
            ),
          ),
        ],
      ),
    );
  }
}

/// 199 Add Mobile Wallet (Figma 292:3562) → 200 Verify (292:3573).
class AddWalletScreen extends ConsumerStatefulWidget {
  const AddWalletScreen({super.key, required this.type});
  final String type;

  @override
  ConsumerState<AddWalletScreen> createState() => _AddWalletState();
}

class _AddWalletState extends ConsumerState<AddWalletScreen> {
  final _num = TextEditingController();
  String? _err;
  bool _verify = false;
  bool _default = true;
  bool _busy = false;

  @override
  void dispose() {
    _num.dispose();
    super.dispose();
  }

  Future<void> _save(AppUser me) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final number = BdPhone.normalizeLocal(_num.text) ?? _num.text.trim();
      final next = PayoutMethod(
        type: widget.type,
        number: number,
        accountName: me.name,
        isDefault: _default || me.payoutMethods.isEmpty,
      );
      await ref.read(userRepositoryProvider).savePayoutMethods(me.uid, [
        for (final m in me.payoutMethods)
          if (m.number != number)
            next.isDefault ? m.copyWith(isDefault: false) : m,
        next,
      ]);
      if (!mounted) return;
      KsToast.show(context, l.pmSaved);
      context.pop();
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final type = payoutTypeLabel(l, widget.type);
    if (me == null) return const Scaffold(body: KsSkeletonList());

    if (_verify) {
      // 200: no wallet API in v1 (payment is a placeholder), so the check is
      // the name match with the profile.
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(
          title: l.pmVerifyTitle,
          onBack: () => setState(() => _verify = false),
        ),
        body: ListView(
          padding: _pad,
          children: [
            Text(
              l.pmVerifyIntro(Fmt.digits(context, _num.text.trim())),
              style: AppTypography.bodySmall.normal.withColor(
                AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.block),
            KsOptionCard(
              image: const AssetImage(AppUi.glyphWallet),
              imageSize: 36,
              title: l.pmNameMatched(me.name),
              subtitle: l.pmVerifySub(type),
              selected: true,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.block),
            InkWell(
              onTap: () => setState(() => _default = !_default),
              child: Row(
                children: [
                  Checkbox(
                    value: _default,
                    activeColor: AppColors.bgBrand,
                    onChanged: (v) => setState(() => _default = v ?? true),
                  ),
                  Expanded(
                    child: Text(
                      l.pmSetDefault,
                      style: AppTypography.bodySmallEmphasis.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: _gapBeforeCta),
            KsButton(
              label: l.pmSave,
              loading: _busy,
              onPressed: () => _save(me),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.pmNumberTitle(type)),
      body: ListView(
        padding: _pad,
        children: [
          KsTextField(
            label: l.pmNumberTitle(type),
            hint: l.loginPhoneHint,
            controller: _num,
            keyboardType: TextInputType.phone,
            maxLength: 14,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯+\s-]')),
            ],
            errorText: _err,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.pmOwnNumber,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(title: l.pmWhyTitle, body: l.pmWhyBody, warning: true),
          const SizedBox(height: _gapBeforeCta),
          KsButton(
            label: l.pmSendCode,
            onPressed: () {
              if (BdPhone.normalizeLocal(_num.text) == null) {
                setState(() => _err = l.loginInvalidPhone);
                return;
              }
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _err = null;
                _verify = true;
              });
            },
          ),
        ],
      ),
    );
  }
}

/// 201 Add Bank Account (Figma 292:3601).
class AddBankScreen extends ConsumerStatefulWidget {
  const AddBankScreen({super.key});

  @override
  ConsumerState<AddBankScreen> createState() => _AddBankState();
}

class _AddBankState extends ConsumerState<AddBankScreen> {
  String? _bank;
  final _branch = TextEditingController();
  final _name = TextEditingController();
  final _acc = TextEditingController();
  final Map<String, String?> _err = {};
  bool _busy = false;

  @override
  void dispose() {
    _branch.dispose();
    _name.dispose();
    _acc.dispose();
    super.dispose();
  }

  Future<void> _save(AppUser me) async {
    final l = AppLocalizations.of(context);
    final acc = Fmt.latinDigits(_acc.text.trim());
    setState(() {
      _err
        ..clear()
        ..['bank'] = _bank == null ? l.commonRequired : null
        ..['branch'] = _branch.text.trim().isEmpty ? l.commonRequired : null
        ..['name'] =
            _name.text.trim().toLowerCase() != me.name.trim().toLowerCase()
            ? l.pmErrName
            : null
        ..['acc'] = RegExp(r'^\d{13,17}$').hasMatch(acc) ? null : l.pmErrAccNo;
    });
    if (_err.values.any((e) => e != null)) return;
    setState(() => _busy = true);
    try {
      final next = PayoutMethod(
        type: 'bank',
        number: acc,
        accountName: _name.text.trim(),
        bank: _bank,
        branch: _branch.text.trim(),
        isDefault: me.payoutMethods.isEmpty,
      );
      await ref.read(userRepositoryProvider).savePayoutMethods(me.uid, [
        for (final m in me.payoutMethods)
          if (m.number != acc) m,
        next,
      ]);
      if (!mounted) return;
      KsToast.show(context, l.pmSaved);
      context.pop();
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    if (me == null) return const Scaffold(body: KsSkeletonList());
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.pmBankTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsSelectField(
            label: l.pmBankName,
            placeholder: l.selectHint,
            value: _bank,
            errorText: _err['bank'],
            onTap: () async {
              final b = await showKsOptionsSheet<String>(
                context,
                title: l.pmBankName,
                searchHint: l.commonSearch,
                options: [for (final b in _banks) (b, b)],
              );
              if (b != null) setState(() => _bank = b);
            },
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.pmBranch,
            controller: _branch,
            errorText: _err['branch'],
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.pmAccName,
            hint: l.pmAccNameHint,
            controller: _name,
            errorText: _err['name'],
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.pmAccNo,
            hint: l.pmAccNoHint,
            controller: _acc,
            keyboardType: TextInputType.number,
            maxLength: 17,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯]')),
            ],
            errorText: _err['acc'],
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.pmBankNote,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: _gapBeforeCta),
          KsButton(
            label: l.pmStartVerify,
            loading: _busy,
            onPressed: () => _save(me),
          ),
        ],
      ),
    );
  }
}

/// Sheet: pick the new default after removing the default method.
Future<PayoutMethod?> _chooseDefault(
  BuildContext context,
  AppLocalizations l,
  List<PayoutMethod> options,
) => showModalBottomSheet<PayoutMethod>(
  context: context,
  builder: (ctx) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.screen),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.pmChooseDefault, style: AppTypography.headingBold20.normal),
          for (final m in options) ...[
            const SizedBox(height: AppSpacing.md),
            KsListItem(
              thumb: _wallet(),
              title: payoutLine(l, m),
              subtitle: m.accountName,
              onTap: () => Navigator.pop(ctx, m),
            ),
          ],
        ],
      ),
    ),
  ),
);
