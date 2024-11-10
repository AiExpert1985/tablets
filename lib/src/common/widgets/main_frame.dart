import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/page_title_provider.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/main_drawer.dart';

class AppScreenFrame extends ConsumerWidget {
  const AppScreenFrame({
    super.key,
    required this.screenBody,
  });
  final Widget screenBody;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageTitle = ref.watch(pageTitleProvider);
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: _buildPageTitle(context, pageTitle),
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
      drawer: buildMainDrawer(context, pageTitleNotifier),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: screenBody,
      ),
    );
  }
}

Widget _buildPageTitle(BuildContext context, String pageTitle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center, // Center the title
    children: [
      Expanded(
        child: Container(
          alignment: Alignment.center, // Center the title text
          child: Text(
            pageTitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
