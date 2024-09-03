import 'package:flutter/material.dart';

class LocaleAwareLogoutIcon extends StatelessWidget {
  const LocaleAwareLogoutIcon({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    // for arabic, we flip the direction
    if (currentLocale.languageCode == 'ar') {
      // for arabic,
      return Transform.flip(
        flipX: true,
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      );
    }
    return const Icon(
      Icons.logout,
      color: Colors.white,
    );
  }
}
