import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/features/settings/model/settings.dart';
import 'package:tablets/src/features/settings/repository/settings_repository_provider.dart';

class SettingsParameters extends ConsumerWidget {
  const SettingsParameters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsStream = ref.watch(settingsStreamProvider);
    return AsyncValueWidget<List<Map<String, dynamic>>>(
        value: settingsStream,
        data: (settingsList) {
          final settings = Settings.fromMap(settingsList[0]);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).transaction_payment_type),
                    HorizontalGap.xl,
                    InkWell(
                      child: Text(translateDbString(context, settings.paymentType)),
                      onTap: () {},
                    )
                  ],
                ),
                VerticalGap.xl,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).transaction_currency),
                    HorizontalGap.l,
                    InkWell(
                      child: Text(translateDbString(context, settings.currency)),
                      onTap: () {},
                    )
                  ],
                ),
                VerticalGap.xl,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).include_total_as_text),
                    HorizontalGap.l,
                    InkWell(
                      child: Text(
                          translateDbString(context, settings.writeTotalAmountAsText.toString())),
                      onTap: () {},
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
