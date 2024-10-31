import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart' as gaps;
import 'package:tablets/src/features/products/controllers/product_form_controller.dart';

class ProductFormFields extends ConsumerWidget {
  const ProductFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.watch(productFormDataProvider.notifier);
    final repository = ref.read(categoryRepositoryProvider);
    return Column(
      children: [
        Row(
          children: [
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'code',
              label: S.of(context).product_code,
              initialValue: formDataNotifier.getProperty(property: 'code'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'code': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              dataType: FieldDataTypes.string,
              name: 'name',
              label: S.of(context).product_name,
              initialValue: formDataNotifier.getProperty(property: 'name'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'name': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownWithSearchFormField(
              label: S.of(context).category_selection,
              initialValue: formDataNotifier.getProperty(property: 'category'),
              dbRepository: repository,
              onChangedFn: (item) {
                formDataNotifier.updateProperties({'salesman': item['name']});
              },
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'sellRetailPrice',
              label: S.of(context).product_sell_retail_price,
              initialValue: formDataNotifier.getProperty(property: 'sellRetailPrice'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'sellRetailPrice': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'sellWholePrice',
              label: S.of(context).product_sell_whole_price,
              initialValue: formDataNotifier.getProperty(property: 'sellWholePrice'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'sellWholePrice': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'salesmanComission',
              label: S.of(context).product_salesman_comission,
              initialValue: formDataNotifier.getProperty(property: 'salesmanComission'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'salesmanComission': value});
              },
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'initialQuantity',
              label: S.of(context).product_initial_quantitiy,
              initialValue: formDataNotifier.getProperty(property: 'initialQuantity'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'initialQuantity': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'altertWhenLessThan',
              label: S.of(context).product_altert_when_less_than,
              initialValue: formDataNotifier.getProperty(property: 'altertWhenLessThan'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'altertWhenLessThan': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'alertWhenExceeds',
              label: S.of(context).product_alert_when_exceeds,
              initialValue: formDataNotifier.getProperty(property: 'alertWhenExceeds'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'alertWhenExceeds': value});
              },
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            FormInputField(
              dataType: FieldDataTypes.string,
              name: 'packageType',
              label: S.of(context).product_package_type,
              initialValue: formDataNotifier.getProperty(property: 'packageType'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'packageType': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'packageWeight',
              label: S.of(context).product_package_weight,
              initialValue: formDataNotifier.getProperty(property: 'packageWeight'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'packageWeight': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              dataType: FieldDataTypes.num,
              name: 'numItemsInsidePackage',
              label: S.of(context).product_num_items_inside_package,
              initialValue: formDataNotifier.getProperty(property: 'numItemsInsidePackage'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'numItemsInsidePackage': value});
              },
            ),
          ],
        )
      ],
    );
  }
}
