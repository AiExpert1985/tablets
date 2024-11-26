import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/user_messages.dart';
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
          const Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FirstColumn(),
              VerticalDivider(),
              SecondColumn(),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
        Row(
          children: [
            RowLabel(S.of(context).hide_customer_profit),
            SwitchButton(hideCustomerProfitKey),
          ],
        ),
        VerticalGap.xl,
        Row(
          children: [
            RowLabel(S.of(context).hide_totals_row),
            SwitchButton(hideMainScreenColumnTotalsKey),
          ],
        ),
      ],
    );
  }
}

class SecondColumn extends ConsumerWidget {
  const SecondColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [Text('hi')],
    );
  }
}

class RowLabel extends ConsumerWidget {
  const RowLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: 200,
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
  const RadioButtons(this.numButtons, {super.key});
  final int numButtons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ...List.generate(numButtons, (index) {
          return Radio(
            value: index + 1,
            groupValue: 1,
            onChanged: (value) {},
          );
        }),
      ],
    );
  }
}

class SwitchButton extends ConsumerWidget {
  const SwitchButton(this.property, {super.key});
  final String property;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDataNotifier = ref.read(settingsFormDataProvider.notifier);
    final currentValue = settingsDataNotifier.getProperty(property);
    ref.watch(settingsFormDataProvider);
    return Switch(
      value: currentValue,
      onChanged: (value) {
        settingsDataNotifier.updateProperties({property: value});
      },
    );
  }
}
