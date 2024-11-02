import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/list_filters.dart' as filters;
import 'package:tablets/src/features/customers/controllers/customer_drawer_provider.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_controller_.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_data_provider.dart';

class CustomerSearchForm extends ConsumerWidget {
  const CustomerSearchForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GeneralSearchField(
            filterCriteria: filters.FilterCriteria.contains.name,
            dataType: filters.DataTypes.string.name,
            name: 'name',
            displayedTitle: S.of(context).customer_name,
          ),
          VerticalGap.l,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  /// if filter is already on, we turn it off to make all list available for search
                  /// note that list filtering is only activated if filterSwitch changed status (on/off)
                  if (ref.read(customerFilterSwitchProvider)) {
                    ref
                        .read(customerFilterSwitchProvider.notifier)
                        .update((state) => state = false);
                  }
                  ref.read(customerFilterSwitchProvider.notifier).update((state) => state = true);
                },
                icon: const ApproveIcon(),
              ),
              IconButton(
                onPressed: () {
                  ref.read(customerFilterSwitchProvider.notifier).update((state) => state = false);
                  ref.read(customerFiltersProvider.notifier).reset();
                  ref.read(customerDrawerControllerProvider).drawerController.close();
                },
                icon: const CancelIcon(),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class GeneralSearchField extends ConsumerWidget {
  const GeneralSearchField({
    required this.dataType,
    required this.name,
    required this.displayedTitle,
    required this.filterCriteria,
    super.key,
  });

  final String dataType;
  final String name;
  final String displayedTitle;
  final String filterCriteria;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerFilters = ref.watch(customerFiltersProvider);
    dynamic initialValue = customerFilters[name]?['value'];
    if (initialValue != null) {
      initialValue = initialValue is String ? initialValue : initialValue.toString();
    }
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: utils.formFieldDecoration(label: displayedTitle),
      onChanged: (value) => ref
          .read(customerFiltersProvider.notifier)
          .update(key: name, value: value, dataType: dataType, filterCriteria: filterCriteria),
    );
  }
}
