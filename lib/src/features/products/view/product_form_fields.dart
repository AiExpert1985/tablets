import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
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
              dataType: FieldDataType.num,
              name: 'code',
              label: S.of(context).product_code,
              initialValue: formDataNotifier.getProperty('code'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'code': value});
              },
            ),
            HorizontalGap.l,
            FormInputField(
              dataType: FieldDataType.text,
              name: 'name',
              label: S.of(context).product_name,
              initialValue: formDataNotifier.getProperty('name'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'name': value});
              },
            ),
            HorizontalGap.l,
            DropDownWithSearchFormField(
              label: S.of(context).category_selection,
              initialValue: formDataNotifier.getProperty('category'),
              dbRepository: repository,
              onChangedFn: (item) {
                formDataNotifier
                    .updateProperties({'category': item['name'], 'categoryDbRef': item['dbRef']});
              },
            ),
          ],
        ),
        VerticalGap.m,
        Row(
          children: [
            FormInputField(
              dataType: FieldDataType.num,
              name: 'buyingPrice',
              label: S.of(context).product_buying_price,
              initialValue: formDataNotifier.getProperty('buyingPrice'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'buyingPrice': value});
              },
            ),
            HorizontalGap.l,
            FormInputField(
              dataType: FieldDataType.num,
              name: 'sellRetailPrice',
              label: S.of(context).product_sell_retail_price,
              initialValue: formDataNotifier.getProperty('sellRetailPrice'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'sellRetailPrice': value});
              },
            ),
            HorizontalGap.l,
            FormInputField(
              dataType: FieldDataType.num,
              name: 'sellWholePrice',
              label: S.of(context).product_sell_whole_price,
              initialValue: formDataNotifier.getProperty('sellWholePrice'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'sellWholePrice': value});
              },
            ),
          ],
        ),
        VerticalGap.m,
        Row(
          children: [
            FormInputField(
              dataType: FieldDataType.num,
              name: 'initialQuantity',
              label: S.of(context).product_initial_quantitiy,
              initialValue: formDataNotifier.getProperty('initialQuantity'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'initialQuantity': value});
              },
            ),
            HorizontalGap.l,
            FormInputField(
              dataType: FieldDataType.num,
              name: 'altertWhenLessThan',
              label: S.of(context).product_altert_when_less_than,
              initialValue: formDataNotifier.getProperty('altertWhenLessThan'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'altertWhenLessThan': value});
              },
            ),
            HorizontalGap.l,
            FormInputField(
              dataType: FieldDataType.num,
              name: 'alertWhenExceeds',
              label: S.of(context).product_alert_when_exceeds,
              initialValue: formDataNotifier.getProperty('alertWhenExceeds'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'alertWhenExceeds': value});
              },
            ),
          ],
        ),
        VerticalGap.m,
        Row(
          children: [
            FormInputField(
              dataType: FieldDataType.text,
              name: 'packageType',
              label: S.of(context).product_package_type,
              initialValue: formDataNotifier.getProperty('packageType'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'packageType': value});
              },
            ),
            HorizontalGap.l,
            FormInputField(
              dataType: FieldDataType.num,
              name: 'packageWeight',
              label: S.of(context).product_package_weight,
              initialValue: formDataNotifier.getProperty('packageWeight'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'packageWeight': value});
              },
            ),
            HorizontalGap.l,
            FormInputField(
              dataType: FieldDataType.num,
              name: 'numItemsInsidePackage',
              label: S.of(context).product_num_items_inside_package,
              initialValue: formDataNotifier.getProperty('numItemsInsidePackage'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'numItemsInsidePackage': value});
              },
            ),
          ],
        ),
        VerticalGap.m,
        Row(
          children: [
            FormInputField(
              dataType: FieldDataType.num,
              name: 'salesmanComission',
              label: S.of(context).product_salesman_comission,
              initialValue: formDataNotifier.getProperty('salesmanComission'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'salesmanComission': value});
              },
            ),
            HorizontalGap.l,
            FormInputField(
              isRequired: false,
              dataType: FieldDataType.text,
              name: 'notes',
              label: S.of(context).notes,
              initialValue: formDataNotifier.getProperty('notes'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'notes': value});
              },
            ),
          ],
        )
      ],
    );
  }
}
