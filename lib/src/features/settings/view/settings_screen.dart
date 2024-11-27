import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/user_messages.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/features/settings/controllers/settings_form_data_notifier.dart';
import 'package:tablets/src/features/settings/model/settings.dart';
import 'package:tablets/src/features/settings/repository/settings_repository_provider.dart';
import 'package:tablets/src/features/settings/view/settings_keys.dart';

final paymentValues = [PaymentType.credit.name, PaymentType.cash.name];
final currencyValues = [Currency.dinar.name, Currency.dollar.name];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsFormDataProvider);
    final settingDataNotifier = ref.read(settingsFormDataProvider.notifier);
    if (settingDataNotifier.data.isEmpty) {
      return const HomeScreen();
    }
    return const AppScreenFrame(SettingsParameters());
  }
}

class SettingsParameters extends ConsumerWidget {
  const SettingsParameters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(settingsRepositoryProvider);
    final settingDataNotifier = ref.read(settingsFormDataProvider.notifier);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
            child: const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FirstColumn(),
                VerticalDivider(),
                SecondColumn(),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // button only saves changes to Db, in case user didn't save, then his changes
              // will be only available in the current settings
              IconButton(
                onPressed: () async {
                  final settingsData = settingDataNotifier.data;
                  final isSuccess = await repository.updateItem(Settings.fromMap(settingsData));
                  if (isSuccess && context.mounted) {
                    success(context, S.of(context).db_success_updaging_doc);
                  }
                },
                icon: const SaveIcon(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FirstColumn extends ConsumerWidget {
  const FirstColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SwitchButton(S.of(context).hide_amount_as_text, hideTransactionAmountAsTextKey),
        VerticalGap.xl,
        SwitchButton(S.of(context).hide_totals_row, hideMainScreenColumnTotalsKey),
        VerticalGap.xl,
        SwitchButton(S.of(context).hide_product_buying_price, hideProductBuyingPriceKey),
        VerticalGap.xl,
        SwitchButton(S.of(context).hide_customer_profit, hideCustomerProfitKey),
        VerticalGap.xl,
        SwitchButton(S.of(context).hide_product_profit, hideProductProfitKey),
        VerticalGap.xl,
        SwitchButton(S.of(context).hide_salesman_profit, hideSalesmanProfitKey),
      ],
    );
  }
}

class SecondColumn extends ConsumerWidget {
  const SecondColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        RadioButtons(S.of(context).transaction_payment_type, settingsPaymentTypeKey, paymentValues),
        RadioButtons(S.of(context).transaction_currency, settingsCurrencyKey, currencyValues),
      ],
    );
  }
}

class SettingLabel extends ConsumerWidget {
  const SettingLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      width: 210,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class SliderButton extends ConsumerWidget {
  const SliderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SfSlider(
      min: 0.0,
      max: 5.0,
      value: 3,
      interval: 1,
      // showTicks: true,
      showLabels: true,
      enableTooltip: true,
      // minorTicksPerInterval: 1,
      onChanged: (dynamic value) {
        tempPrint(value.round());
      },
    );
  }
}

class RadioButtons extends ConsumerWidget {
  const RadioButtons(this.label, this.propertyName, this.values, {super.key});
  final List<String> values;
  final String label;
  final String propertyName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDataNotifier = ref.read(settingsFormDataProvider.notifier);
    final currentValue = settingsDataNotifier.getProperty(propertyName);
    ref.watch(settingsFormDataProvider);
    return Row(
      children: [
        SettingLabel(label),
        ...values.map(
          (buttonValue) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(translateDbTextToScreenText(context, buttonValue)),
                  VerticalGap.s,
                  Radio(
                    value: buttonValue,
                    groupValue: currentValue,
                    onChanged: (value) {
                      settingsDataNotifier.updateProperties({propertyName: value});
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class SwitchButton extends ConsumerWidget {
  const SwitchButton(this.label, this.propertyName, {super.key});
  final String label;
  final String propertyName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDataNotifier = ref.read(settingsFormDataProvider.notifier);
    final currentValue = settingsDataNotifier.getProperty(propertyName);
    ref.watch(settingsFormDataProvider);
    return Row(
      children: [
        SettingLabel(label),
        HorizontalGap.xl,
        Switch(
          value: currentValue,
          onChanged: (value) {
            settingsDataNotifier.updateProperties({propertyName: value});
          },
        ),
      ],
    );
  }
}
