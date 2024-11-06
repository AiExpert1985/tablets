import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/regions/controllers/region_drawer_provider.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/list_filters.dart' as filters;
import 'package:tablets/src/features/regions/controllers/region_filter_data_provider.dart';
import 'package:tablets/src/features/regions/controllers/region_filter_controller_.dart';

class RegionSearchForm extends ConsumerWidget {
  const RegionSearchForm({super.key});

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
            displayedTitle: S.of(context).product_name,
          ),
          VerticalGap.l,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  /// if filter is already on, we turn it off to make all list available for search
                  /// note that list filtering is only activated if filterSwitch changed status (on/off)
                  if (ref.read(regionFilterSwitchProvider)) {
                    ref.read(regionFilterSwitchProvider.notifier).update((state) => state = false);
                  }
                  ref.read(regionFilterSwitchProvider.notifier).update((state) => state = true);
                },
                icon: const ApproveIcon(),
              ),
              IconButton(
                onPressed: () {
                  ref.read(regionFilterSwitchProvider.notifier).update((state) => state = false);
                  ref.read(regionFiltersProvider.notifier).reset();
                  ref.read(regionDrawerControllerProvider).drawerController.close();
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
    final regionFilters = ref.watch(regionFiltersProvider);
    dynamic initialValue = regionFilters[name]?['value'];
    if (initialValue != null) {
      initialValue = initialValue is String ? initialValue : initialValue.toString();
    }
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: utils.formFieldDecoration(label: displayedTitle),
      onChanged: (value) => ref
          .read(regionFiltersProvider.notifier)
          .update(key: name, value: value, dataType: dataType, filterCriteria: filterCriteria),
    );
  }
}
