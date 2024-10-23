import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/products/controllers/product_drawer_provider.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/features/products/controllers/product_filter_data_provider.dart';
import 'package:tablets/src/common/values/gaps.dart' as gaps;
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/list_filters.dart' as filters;
import 'package:tablets/src/features/products/controllers/product_filter_controller_provider.dart';

class ProductSearchForm extends ConsumerWidget {
  const ProductSearchForm({super.key});

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
            filterCriteria: filters.FilterCriteria.equals.name,
            dataType: filters.DataTypes.int.name,
            name: 'code',
            displayedTitle: S.of(context).product_code,
          ),
          gaps.VerticalGap.formFieldToField,
          GeneralSearchField(
            filterCriteria: filters.FilterCriteria.contains.name,
            dataType: filters.DataTypes.string.name,
            name: 'name',
            displayedTitle: S.of(context).product_name,
          ),
          gaps.VerticalGap.formFieldToField,
          GeneralSearchField(
            filterCriteria: filters.FilterCriteria.contains.name,
            dataType: filters.DataTypes.string.name,
            name: 'category',
            displayedTitle: S.of(context).product_category,
          ),
          gaps.VerticalGap.sideDrawerfieldsToButtons,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  /// if filter is already on, we turn it off to make all list available for search
                  /// note that list filtering is only activated if filterSwitch changed status (on/off)
                  if (ref.read(productFilterSwitchProvider)) {
                    ref.read(productFilterSwitchProvider.notifier).update((state) => state = false);
                  }
                  ref.read(productFilterSwitchProvider.notifier).update((state) => state = true);
                },
                icon: const ApproveIcon(),
              ),
              IconButton(
                onPressed: () {
                  ref.read(productFilterSwitchProvider.notifier).update((state) => state = false);
                  ref.read(productFiltersProvider.notifier).reset();
                  ref.read(productsDrawerControllerProvider).drawerController.close();
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
    final productFilters = ref.watch(productFiltersProvider);
    dynamic initialValue = productFilters[name]?['value'];
    if (initialValue != null) {
      initialValue = initialValue is String ? initialValue : initialValue.toString();
    }
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: utils.formFieldDecoration(label: displayedTitle),
      onChanged: (value) => ref
          .read(productFiltersProvider.notifier)
          .update(key: name, value: value, dataType: dataType, filterCriteria: filterCriteria),
    );
  }
}
