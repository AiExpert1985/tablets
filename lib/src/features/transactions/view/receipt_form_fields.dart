import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/form_drop_down_field.dart';
import 'package:tablets/src/common/widgets/form_input_field.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/common/constants/constants.dart';
import 'package:tablets/src/common/constants/gaps.dart' as gaps;
import 'package:tablets/src/features/products/controllers/product_form_controller.dart';

class ReceiptFormFields extends ConsumerWidget {
  const ReceiptFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(productFormDataProvider);

    final formDataNotifier = ref.read(productFormDataProvider.notifier);
    final categoryRepository = ref.read(categoryRepositoryProvider);
    return Column(
      children: [
        Row(
          children: [
            ProductFormInputField(
              dataType: FieldDataTypes.int,
              name: 'code',
              displayedTitle: S.of(context).product_code,
            ),
            gaps.HorizontalGap.formFieldToField,
            ProductFormInputField(
              dataType: FieldDataTypes.string,
              name: 'name',
              displayedTitle: S.of(context).product_name,
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownFormField(
              title: S.of(context).category_selection,
              formData: formData,
              formDataUpdateFn: formDataNotifier.update,
              dbItemFetchFn: categoryRepository.fetchItemAsMap,
              dbListFetchFn: categoryRepository.fetchItemListAsMaps,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            ProductFormInputField(
              dataType: FieldDataTypes.double,
              name: 'sellRetailPrice',
              displayedTitle: S.of(context).product_sell_retail_price,
            ),
            gaps.HorizontalGap.formFieldToField,
            ProductFormInputField(
              dataType: FieldDataTypes.double,
              name: 'sellWholePrice',
              displayedTitle: S.of(context).product_sell_whole_price,
            ),
            gaps.HorizontalGap.formFieldToField,
            ProductFormInputField(
              dataType: FieldDataTypes.double,
              name: 'salesmanComission',
              displayedTitle: S.of(context).product_salesman_comission,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            ProductFormInputField(
              dataType: FieldDataTypes.int,
              name: 'initialQuantity',
              displayedTitle: S.of(context).product_initial_quantitiy,
            ),
            gaps.HorizontalGap.formFieldToField,
            ProductFormInputField(
              dataType: FieldDataTypes.int,
              name: 'altertWhenLessThan',
              displayedTitle: S.of(context).product_altert_when_less_than,
            ),
            gaps.HorizontalGap.formFieldToField,
            ProductFormInputField(
              dataType: FieldDataTypes.int,
              name: 'alertWhenExceeds',
              displayedTitle: S.of(context).product_alert_when_exceeds,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            ProductFormInputField(
              dataType: FieldDataTypes.string,
              name: 'packageType',
              displayedTitle: S.of(context).product_package_type,
            ),
            gaps.HorizontalGap.formFieldToField,
            ProductFormInputField(
              dataType: FieldDataTypes.double,
              name: 'packageWeight',
              displayedTitle: S.of(context).product_package_weight,
            ),
            gaps.HorizontalGap.formFieldToField,
            ProductFormInputField(
              dataType: FieldDataTypes.int,
              name: 'numItemsInsidePackage',
              displayedTitle: S.of(context).product_num_items_inside_package,
            ),
          ],
        )
      ],
    );
  }
}

class ProductFormInputField extends ConsumerWidget {
  const ProductFormInputField({
    required this.dataType,
    required this.name,
    required this.displayedTitle,
    super.key,
  });

  final FieldDataTypes dataType;
  final String name;
  final String displayedTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productFormController = ref.watch(productFormDataProvider.notifier);
    final formData = productFormController.data;
    return FormInputField(
        formData: formData,
        formDataUpdateFn: productFormController.update,
        dataType: dataType,
        name: name,
        displayedTitle: displayedTitle);
  }
}
