import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/main_drawer.dart';

class AppScreenFrame extends StatelessWidget {
  const AppScreenFrame({
    super.key,
    required this.screenBody,
  });
  final Widget screenBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
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
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: screenBody,
      ),
    );
  }
}
