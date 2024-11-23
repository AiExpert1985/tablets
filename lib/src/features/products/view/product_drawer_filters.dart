import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/screen_data_filters.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/products/controllers/product_drawer_provider.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/features/products/controllers/product_filter_controller.dart';
import 'package:tablets/src/features/products/controllers/product_screen_controller.dart';
import 'package:tablets/src/features/products/controllers/product_screen_data_notifier.dart';

class ProductSearchForm extends ConsumerWidget {
  const ProductSearchForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterController = ref.read(productFilterController);
    final screenDataController = ref.read(productScreenControllerProvider);
    final screenDataNotifier = ref.read(productScreenDataNotifier.notifier);
    return FormBuilder(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FormInputField(
            initialValue: filterController.getFilterValue('code'),
            onChangedFn: (value) {
              filterController.updateFilters(
                FilterDataTypes.num,
                'code',
                FilterCriteria.equals,
                value,
              );
            },
            dataType: FieldDataType.num,
            name: 'code',
            label: S.of(context).product_code,
          ),
          VerticalGap.m,
          // GeneralSearchField(
          //   filterCriteria: filters.FilterCriteria.contains.name,
          //   dataType: filters.DataTypes.string.name,
          //   name: 'name',
          //   displayedTitle: S.of(context).product_name,
          // ),
          // VerticalGap.m,
          // GeneralSearchField(
          //   filterCriteria: filters.FilterCriteria.contains.name,
          //   dataType: filters.DataTypes.string.name,
          //   name: 'category',
          //   displayedTitle: S.of(context).product_category,
          // ),
          VerticalGap.l,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  final screenData = screenDataNotifier.data as List<Map<String, dynamic>>;
                  final filteredScreenData = filterController.applyListFilter(screenData);
                  screenDataNotifier.set(filteredScreenData);
                },
                icon: const ApproveIcon(),
              ),
              IconButton(
                onPressed: () {
                  screenDataController.setAllProductsScreenData(context);
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
