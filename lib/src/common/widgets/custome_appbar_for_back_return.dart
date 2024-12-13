import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';

PreferredSizeWidget buildArabicAppBar(
    BuildContext context, final void Function() backOnTapFn, final void Function() homeOnTapFn) {
  return AppBar(
    leadingWidth: 140,
    automaticallyImplyLeading: false,
    leading: Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(onPressed: homeOnTapFn, icon: const HomeReturnIcon()),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          onTap: backOnTapFn,
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).back,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                HorizontalGap.m,
                const Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
