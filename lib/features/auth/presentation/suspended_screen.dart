import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../chat/presentation/chat_screens.dart' show helplineNumber;
import '../data/auth_repository.dart';

/// Shown instead of the whole app while an admin has suspended the
/// account (Firestore rules block every write anyway). Only the helpline
/// call and logout work; chat needs an active account.
class SuspendedScreen extends ConsumerWidget {
  const SuspendedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: SafeArea(
          child: KsSuspendedState(
            onCall: () => launchUrl(Uri(scheme: 'tel', path: helplineNumber)),
            onLogout: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ),
      ),
    );
  }
}
