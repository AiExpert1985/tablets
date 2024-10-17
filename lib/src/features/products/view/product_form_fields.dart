import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/category/model/category.dart';
import 'package:tablets/src/features/category/repository/category_repository_provider.dart';
import 'package:tablets/src/features/products/controllers/product_form_controllers.dart';
import 'package:tablets/src/common/constants/gaps.dart' as gaps;
import 'package:tablets/src/common/constants/constants.dart' as constants;
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

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
            gaps.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.string.name,
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
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'sellRetailPrice',
              displayedTitle: S.of(context).product_sell_retail_price,
            ),
            gaps.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'sellWholePrice',
              displayedTitle: S.of(context).product_sell_whole_price,
            ),
            gaps.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'salesmanComission',
              displayedTitle: S.of(context).product_salesman_comission,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'initialQuantity',
              displayedTitle: S.of(context).product_initial_quantitiy,
            ),
            gaps.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'altertWhenLessThan',
              displayedTitle: S.of(context).product_altert_when_less_than,
            ),
            gaps.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'alertWhenExceeds',
              displayedTitle: S.of(context).product_alert_when_exceeds,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.string.name,
              name: 'packageType',
              displayedTitle: S.of(context).product_package_type,
            ),
            gaps.HorizontalGap.formFieldToField,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'packageWeight',
              displayedTitle: S.of(context).product_package_weight,
            ),
            gaps.HorizontalGap.formFieldToField,
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
            return validation.validateStringField(
                fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_strings);
          }
          if (dataType == FieldDataTypes.int.name) {
            return validation.validateIntField(
                fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_integers);
          }
          if (dataType == FieldDataTypes.double.name) {
            return validation.validateDoubleField(
                fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_doubles);
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
            ? ProductCategory(name: userFormData['category'], imageUrls: userFormData['imageUrls'])
            : null,
        items: (filter, t) =>
            ref.read(categoriesRepositoryProvider).fetchCategoryList(filterKey: 'name', filterValue: filter),
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
            fieldValue: item?.name, errorMessage: S.of(context).input_validation_error_message_for_strings),
        itemAsString: (item) => item.name,
        onSaved: (item) => ref.read(productFormDataProvider.notifier).update(key: 'category', value: item?.name),
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
          foregroundImage: CachedNetworkImageProvider(item.coverImage),
        ),
      ),
    ),
  );
}
