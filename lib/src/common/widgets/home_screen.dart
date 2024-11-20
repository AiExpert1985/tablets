import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(HomeScreenGreeting());
  }
}

/// I use this widget for two reasons
/// for home screen when app starts
/// for cases when refreshing page, since we need user to press a button in the side bar
/// to load data from DB to dbCache, so after a refresh we display this widget, which forces
/// user to go the sidebar and press a button to continue working
class HomeScreenGreeting extends ConsumerWidget {
  const HomeScreenGreeting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // margin: const EdgeInsets.all(10),
            width: double.infinity,
            height: 200, // here I used width intentionally
            child: Image.asset('assets/images/logo.png', fit: BoxFit.scaleDown),
          ),
          Text(
            S.of(context).greeting,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
