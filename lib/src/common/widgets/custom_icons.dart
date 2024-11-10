import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/gaps.dart';

class ApproveIcon extends StatelessWidget {
  const ApproveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(Icons.check, color: Colors.green),
      VerticalGap.s,
      Text(S.of(context).approve)
    ]);
  }
}

class SaveIcon extends StatelessWidget {
  const SaveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(Icons.check, color: Colors.green),
      VerticalGap.s,
      Text(S.of(context).save)
    ]);
  }
}

class CancelIcon extends StatelessWidget {
  const CancelIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(
        Icons.close,
        color: Colors.red,
      ),
      VerticalGap.s,
      Text(S.of(context).cancel),
    ]);
  }
}

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.delete, color: Colors.blueAccent),
        VerticalGap.s,
        Text(S.of(context).delete),
      ],
    );
  }
}

class AddIcon extends StatelessWidget {
  const AddIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.add, color: Colors.white),
        VerticalGap.s,
        Text(S.of(context).add),
      ],
    );
  }
}

class SearchIcon extends StatelessWidget {
  const SearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.search, color: Colors.red),
        VerticalGap.s,
        Text(S.of(context).search),
      ],
    );
  }
}

class ReportsIcon extends StatelessWidget {
  const ReportsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.report, color: Colors.red),
        VerticalGap.s,
        Text(S.of(context).reports),
      ],
    );
  }
}

class AddImageIcon extends StatelessWidget {
  const AddImageIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.image),
        VerticalGap.s,
        Text(S.of(context).add),
      ],
    );
  }
}

class PrintIcon extends StatelessWidget {
  const PrintIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image.asset(
        //   'assets/icons/buttons/print.png',
        //   width: 25,
        //   height: 22,
        // ),
        const Icon(Icons.print),
        VerticalGap.s,
        Text(S.of(context).print),
      ],
    );
  }
}

class ShareIcon extends StatelessWidget {
  const ShareIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.share,
          color: Colors.blue,
        ),
        VerticalGap.s,
        Text(S.of(context).share),
      ],
    );
  }
}

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
    return const Icon(Icons.logout);
  }
}
