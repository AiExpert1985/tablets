import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/locale_aware_logout_icon.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/add_user_popup.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/users_list.dart';
import 'package:tablets/src/features/authentication/repository/auth_repository.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  void signout(WidgetRef ref) {
    try {
      ref.read(authRepositoryProvider).signout;
    } on FirebaseException catch (e) {
      debugPrint('User Creation Error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).greeting,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => signout(ref),
            icon: const LocaleAwareLogoutIcon(),
            label: Text(
              S.of(context).logout,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => const AddUserPopup(),
        ),
        child: const Icon(Icons.add),
      ),
      body: const UsersList(),
    );
  }
}
