import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/user_messages.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
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
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
        width: 1300,
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
        VerticalGap.xl,
        SwitchButton(S.of(context).show_barcode_when_printing, hideCompanyUrlBarCodeKey),
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
        VerticalGap.xl,
        RadioButtons(S.of(context).settings_currency, settingsCurrencyKey, currencyValues),
        VerticalGap.xl,
        SliderButton(
            S.of(context).max_debt_duration_allowed, settingsMaxDebtDurationKey, 0, 60, 30),
        VerticalGap.xl,
        SliderButton(S.of(context).num_printed_invoices, printedCustomerInvoicesKey, 0, 10, 5),
        VerticalGap.xl,
        SliderButton(S.of(context).num_printed_receipts, printedCustomerReceiptsKey, 0, 10, 5),
        VerticalGap.xxl,
        SettingsInputField(
            S.of(context).max_debt_amount_allowed, settingsMaxDebtAmountKey, FieldDataType.num.name)
      ],
    );
  }
}

class SettingLabel extends ConsumerWidget {
  const SettingLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 210,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class SliderButton extends ConsumerWidget {
  const SliderButton(this.label, this.propertyName, this.minNumber, this.maxNumber, this.intervals,
      {super.key});

  final String label;
  final String propertyName;
  final double minNumber;
  final double maxNumber;
  final double intervals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDataNotifier = ref.read(settingsFormDataProvider.notifier);
    final currentValue = settingsDataNotifier.getProperty(propertyName);
    ref.watch(settingsFormDataProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SettingLabel(label),
        HorizontalGap.l,
        SfSlider(
          min: minNumber,
          max: maxNumber,
          value: currentValue,
          interval: intervals,
          // showTicks: true,
          showLabels: true,
          enableTooltip: true,
          // minorTicksPerInterval: 1,
          onChanged: (dynamic value) {
            settingsDataNotifier.updateProperties({propertyName: value.round()});
          },
        ),
      ],
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

class SettingsInputField extends ConsumerWidget {
  const SettingsInputField(this.label, this.propertyName, this.dataType, {super.key});
  final String label;
  final String propertyName;
  final String dataType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDataNotifier = ref.read(settingsFormDataProvider.notifier);
    dynamic currentValue = settingsDataNotifier.getProperty(propertyName);
    if (dataType == FieldDataType.num.name) {
      currentValue = currentValue.toString();
    }
    ref.watch(settingsFormDataProvider);
    return Row(
      children: [
        SettingLabel(label),
        HorizontalGap.xl,
        SizedBox(
          width: 200,
          child: TextField(
            textAlign: TextAlign.center,
            onChanged: (value) {
              dynamic newValue;
              if (dataType == FieldDataType.num.name) {
                try {
                  newValue = double.parse(value);
                } catch (e) {
                  errorPrint('value is not a number');
                }
              } else {
                newValue = value;
              }
              settingsDataNotifier.updateProperties({propertyName: newValue});
            },
            decoration: formFieldDecoration(),
            controller: TextEditingController(text: currentValue),
          ),
        )
      ],
    );
  }
}
