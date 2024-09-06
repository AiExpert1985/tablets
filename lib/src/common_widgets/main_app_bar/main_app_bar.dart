import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/various/locale_aware_logout_icon.dart';

class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(
        S.of(context).greeting,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => FirebaseAuth.instance.signOut(), //signout(ref),
          icon: const LocaleAwareLogoutIcon(),
          label: Text(
            S.of(context).logout,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
