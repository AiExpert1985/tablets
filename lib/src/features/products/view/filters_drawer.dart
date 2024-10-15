import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/products/controllers/drawer_provider.dart';
import 'package:tablets/src/common_widgets/custom_icons.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/controllers/filter_controller_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

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
              filterCriteria: FilterCriteria.equals.name,
              dataType: DataTypes.int.name,
              name: 'code',
              displayedTitle: S.of(context).product_code,
            ),
            constants.VerticalGap.formFieldToField,
            GeneralSearchField(
              filterCriteria: FilterCriteria.contains.name,
              dataType: DataTypes.string.name,
              name: 'name',
              displayedTitle: S.of(context).product_name,
            ),
            constants.VerticalGap.formFieldToField,
            GeneralSearchField(
              filterCriteria: FilterCriteria.contains.name,
              dataType: DataTypes.string.name,
              name: 'category',
              displayedTitle: S.of(context).product_category,
            ),
            constants.VerticalGap.formFieldToField,
            constants.VerticalGap.formFieldToField,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: ref.read(productFilterControllerProvider.notifier).applyFilters,
                  icon: const ApproveIcon(),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(productFilterControllerProvider.notifier).reset();
                    ref.read(productsDrawerControllerProvider).drawerController.close();
                  },
                  icon: const CancelIcon(),
                ),
              ],
            )
          ]),
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
    final filterState = ref.watch(productFilterControllerProvider);
    dynamic initialValue = filterState.searchFieldValues[name];

    if (initialValue != null) {
      initialValue = initialValue is String ? initialValue : initialValue.toString();
    }
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: utils.formFieldDecoration(label: displayedTitle),
      onChanged: (value) => ref.read(productFilterControllerProvider.notifier).updateFieldValue(
          key: name, value: value, dataType: dataType, filterCriteria: filterCriteria),
    );
  }
}
