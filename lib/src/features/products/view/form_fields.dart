import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/categories/model/product_category.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/features/products/controllers/form_data_provider.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/utils/utils.dart' as utils;

enum FieldDataTypes { int, double, string }

class ProductFormFields extends ConsumerWidget {
  const ProductFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productFormDataProvider);
    return Column(
      children: [
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'code',
              displayedTitle: S.of(context).product_code,
            ),
            constants.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.string.name,
              name: 'name',
              displayedTitle: S.of(context).product_name,
            ),
            constants.HorizontalGap.formFieldToField,
            const ProductCategoryFormField()
          ],
        ),
        constants.VerticalGap.formFieldToField,
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'sellRetailPrice',
              displayedTitle: S.of(context).product_sell_retail_price,
            ),
            constants.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'sellWholePrice',
              displayedTitle: S.of(context).product_sell_whole_price,
            ),
            constants.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'salesmanComission',
              displayedTitle: S.of(context).product_salesman_comission,
            ),
          ],
        ),
        constants.VerticalGap.formFieldToField,
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'initialQuantity',
              displayedTitle: S.of(context).product_initial_quantitiy,
            ),
            constants.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'altertWhenLessThan',
              displayedTitle: S.of(context).product_altert_when_less_than,
            ),
            constants.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'alertWhenExceeds',
              displayedTitle: S.of(context).product_alert_when_exceeds,
            ),
          ],
        ),
        constants.VerticalGap.formFieldToField,
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.string.name,
              name: 'packageType',
              displayedTitle: S.of(context).product_package_type,
            ),
            constants.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'packageWeight',
              displayedTitle: S.of(context).product_package_weight,
            ),
            constants.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'numItemsInsidePackage',
              displayedTitle: S.of(context).product_num_items_inside_package,
            ),
          ],
        )
      ],
    );
  }
}

class GeneralFormField extends ConsumerWidget {
  const GeneralFormField({
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
    final userFormData = ref.watch(productFormDataProvider);
    dynamic initialValue = userFormData[name];

    if (initialValue != null) {
      initialValue = initialValue is String ? initialValue : initialValue.toString();
    }
    return Expanded(
      child: FormBuilderTextField(
        name: name,
        initialValue: initialValue,
        decoration: utils.formFieldDecoration(label: displayedTitle),
        onSaved: (value) {
          dynamic userValue = value;
          if (dataType == FieldDataTypes.int.name) {
            userValue = int.tryParse(value!);
          }
          if (dataType == FieldDataTypes.double.name) {
            userValue = double.tryParse(value!);
          }
          ref.read(productFormDataProvider.notifier).update(key: name, value: userValue);
        },
        validator: (value) {
          if (dataType == FieldDataTypes.string.name) {
            return utils.FormValidation.validateStringField(
                fieldValue: value,
                errorMessage: S.of(context).input_validation_error_message_for_strings);
          }
          if (dataType == FieldDataTypes.int.name) {
            return utils.FormValidation.validateIntField(
                fieldValue: value,
                errorMessage: S.of(context).input_validation_error_message_for_integers);
          }
          if (dataType == FieldDataTypes.double.name) {
            return utils.FormValidation.validateDoubleField(
                fieldValue: value,
                errorMessage: S.of(context).input_validation_error_message_for_doubles);
          }
          return null;
        },
      ),
    );
  }
}

class ProductCategoryFormField extends ConsumerWidget {
  const ProductCategoryFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFormData = ref.read(productFormDataProvider);
    return Expanded(
      child: DropdownSearch<ProductCategory>(
        mode: Mode.form,
        decoratorProps: DropDownDecoratorProps(
          decoration: utils.formFieldDecoration(label: S.of(context).category),
        ),
        // if new item, then selectedItem should be null
        selectedItem: userFormData.keys.isNotEmpty
            ? ProductCategory(name: userFormData['category'], imageUrl: constants.defaultImageUrl)
            : null,
        items: (filter, t) =>
            ref.read(categoriesRepositoryProvider).fetchFilteredCategoriesList(filter),
        compareFn: (i, s) => i == s,
        popupProps: PopupProps.dialog(
          dialogProps: DialogProps(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          fit: FlexFit.loose,
          showSearchBox: true,
          itemBuilder: popUpItem,
          searchFieldProps: TextFieldProps(
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: utils.formFieldDecoration(),
          ),
        ),
        validator: (item) => utils.FormValidation.validateStringField(
            fieldValue: item?.name,
            errorMessage: S.of(context).input_validation_error_message_for_strings),
        itemAsString: (item) => item.name,
        onSaved: (item) =>
            ref.read(productFormDataProvider.notifier).update(key: 'category', value: item?.name),
      ),
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
          foregroundImage: CachedNetworkImageProvider(item.imageUrl),
        ),
      ),
    ),
  );
}
