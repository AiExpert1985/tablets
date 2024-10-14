import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/utils/field_box_decoration.dart';
import 'package:tablets/src/features/products/controllers/form_data_provider.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tablets/src/features/products/repository/product_stream_provider.dart';
import 'package:tablets/src/features/products/model/product.dart';

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
            constants.FormGap.horizontal,
            GeneralFormField(
              dataType: FieldDataTypes.string.name,
              name: 'name',
              displayedTitle: S.of(context).product_name,
            ),
            constants.FormGap.horizontal,
            // GeneralFormField(
            //   dataType: FieldDataTypes.string.name,
            //   name: 'category',
            //   displayedTitle: S.of(context).product_category,
            // ),
            const ProductCategoryFormField(),
          ],
        ),
        constants.FormGap.vertical,
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'sellRetailPrice',
              displayedTitle: S.of(context).product_sell_retail_price,
            ),
            constants.FormGap.horizontal,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'sellWholePrice',
              displayedTitle: S.of(context).product_sell_whole_price,
            ),
            constants.FormGap.horizontal,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'salesmanComission',
              displayedTitle: S.of(context).product_salesman_comission,
            ),
          ],
        ),
        constants.FormGap.vertical,
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'initialQuantity',
              displayedTitle: S.of(context).product_initial_quantitiy,
            ),
            constants.FormGap.horizontal,
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'altertWhenLessThan',
              displayedTitle: S.of(context).product_altert_when_less_than,
            ),
            constants.FormGap.horizontal,
            GeneralFormField(
              dataType: FieldDataTypes.int.name,
              name: 'alertWhenExceeds',
              displayedTitle: S.of(context).product_alert_when_exceeds,
            ),
          ],
        ),
        constants.FormGap.vertical,
        Row(
          children: [
            GeneralFormField(
              dataType: FieldDataTypes.string.name,
              name: 'packageType',
              displayedTitle: S.of(context).product_package_type,
            ),
            constants.FormGap.horizontal,
            GeneralFormField(
              dataType: FieldDataTypes.double.name,
              name: 'packageWeight',
              displayedTitle: S.of(context).product_package_weight,
            ),
            constants.FormGap.horizontal,
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
        decoration: formFieldDecoration(displayedTitle),
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
                fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_strings);
          }
          if (dataType == FieldDataTypes.int.name) {
            return utils.FormValidation.validateIntField(
                fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_integers);
          }
          if (dataType == FieldDataTypes.double.name) {
            return utils.FormValidation.validateDoubleField(
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
    final userFormData = ref.watch(productFormDataProvider);
    dynamic initialValue = userFormData['category'];

    if (initialValue != null) {
      initialValue = initialValue is String ? initialValue : initialValue.toString();
    }
    final TextEditingController textEditingController = TextEditingController();
    final productListValue = ref.read(productsStreamProvider);
    List<Map<String, dynamic>> productList = productListValue.value ?? [];
    List<Product> items = productList.map((product) => Product.fromMap(product)).toList();
    return Expanded(
      child: Center(
        child: DropdownButtonFormField2<String>(
          isExpanded: true,

          hint: Text(
            S.of(context).category_selection,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    alignment: Alignment.center,
                    value: item.name,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          foregroundImage: CachedNetworkImageProvider(item.imageUrls[0]),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          value: initialValue,
          onChanged: (value) {},
          onSaved: (value) {
            ref.watch(productFormDataProvider.notifier).update(key: 'category', value: value);
          },
          validator: (value) => utils.FormValidation.validateStringField(
            fieldValue: value,
            errorMessage: S.of(context).input_validation_error_message_for_strings,
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 200,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                textAlign: TextAlign.center,
                expands: true,
                maxLines: null,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: '... ${S.of(context).search} ...',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      ),
    );
  }
}
