import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/widgets/form_input_field.dart';
import 'package:tablets/src/features/categories/model/category.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/common/constants/gaps.dart' as gaps;
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;
import 'package:tablets/src/features/products/controllers/product_form_data_provider.dart';
import 'package:tablets/src/common/constants/constants.dart';

class ProductFormFields extends StatelessWidget {
  const ProductFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context) {
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
            const ProductCategoryFormField()
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
    final formData = productFormController.getState();
    return FormInputField(
        formData: formData,
        formDataUpdateFn: productFormController.update,
        dataType: dataType,
        name: name,
        displayedTitle: displayedTitle);
  }
}

class ProductCategoryFormField extends ConsumerWidget {
  const ProductCategoryFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.read(productFormDataProvider);
    return Expanded(
      child: DropdownSearch<ProductCategory>(
          mode: Mode.form,
          decoratorProps: DropDownDecoratorProps(
            decoration: utils.formFieldDecoration(label: S.of(context).category),
          ),
          // if new item, then selectedItem should be null
          selectedItem: formData.keys.length > 1 // because by default we put dbKey in formData
              ? ProductCategory(
                  dbKey: utils.generateRandomString(len: 8),
                  name: formData['category'],
                  imageUrls: formData['imageUrls'])
              : null,
          items: (filter, t) => ref
              .read(categoriesRepositoryProvider)
              .fetchCategoryList(filterKey: 'name', filterValue: filter),
          compareFn: (i, s) => i == s,
          popupProps: PopupProps.dialog(
            title: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                S.of(context).category_selection,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            dialogProps: DialogProps(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            fit: FlexFit.tight,
            showSearchBox: true,
            itemBuilder: popUpItem,
            searchFieldProps: TextFieldProps(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: utils.formFieldDecoration(),
            ),
          ),
          validator: (item) => validation.validateStringField(
                fieldValue: item?.name,
                errorMessage: S.of(context).input_validation_error_message_for_strings,
              ),
          itemAsString: (item) => item.name,
          onSaved: (item) {
            tempPrint(item);
            ref.read(productFormDataProvider.notifier).update(key: 'category', value: item?.dbKey);
          }),
    );
  }
}

Widget popUpItem(BuildContext context, ProductCategory item, bool isDisabled, bool isSelected) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),
        // subtitle: Text(item.code.toString()),
        leading: CircleAvatar(
          // radius: 70,
          backgroundColor: Colors.white,
          foregroundImage: CachedNetworkImageProvider(item.coverImage),
        ),
      ),
    ),
  );
}
