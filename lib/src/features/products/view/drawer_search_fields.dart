import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/utils/field_box_decoration.dart';
import 'package:tablets/src/common_widgets/icons/custom_icons.dart';
import 'package:tablets/src/constants/constants.dart';
import 'package:tablets/src/features/products/controller/product_list_filter_controller.dart';

enum FieldDataTypes { int, double, string }

class ProductSearchForm extends ConsumerWidget {
  const ProductSearchForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productListFilterNotifierProvider);
    final productsFilter = ref.read(productListFilterNotifierProvider.notifier);
    return FormBuilder(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GeneralSearchField(
              dataType: FieldDataTypes.int.name,
              name: 'code',
              displayedTitle: S.of(context).product_code,
            ),
            FormGap.vertical,
            GeneralSearchField(
              dataType: FieldDataTypes.string.name,
              name: 'name',
              displayedTitle: S.of(context).product_name,
            ),
            FormGap.vertical,
            GeneralSearchField(
              dataType: FieldDataTypes.double.name,
              name: 'salesmanComission',
              displayedTitle: S.of(context).product_salesman_comission,
            ),
            FormGap.vertical,
            GeneralSearchField(
              dataType: FieldDataTypes.string.name,
              name: 'category',
              displayedTitle: S.of(context).product_category,
            ),
            FormGap.vertical,
            FormGap.vertical,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: productsFilter.applyFilters,
                  icon: const ApproveIcon(),
                ),
                IconButton(
                  onPressed: productsFilter.clearFilters,
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
    super.key,
  });

  final String dataType;
  final String name;
  final String displayedTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productSearch = ref.watch(productListFilterNotifierProvider.notifier);
    dynamic initialValue = productSearch.getState.searchFieldValues[name];
    if (initialValue != null) {
      initialValue = initialValue is String ? initialValue : initialValue.toString();
    }
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: formFieldDecoration(displayedTitle),
      onChanged: (value) => productSearch.updateValue(key: name, value: value, dataType: dataType),
    );
  }
}
