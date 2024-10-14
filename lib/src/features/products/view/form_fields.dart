import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/utils/field_box_decoration.dart';
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
            const ProductCategoryFormField()
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
    return Expanded(
      child: DropdownSearch<int>(
        items: (f, cs) => List.generate(30, (i) => i + 1),
        decoratorProps: const DropDownDecoratorProps(
          decoration: InputDecoration(labelText: "Dialog with title", hintText: "Select an Int"),
        ),
        popupProps: PopupProps.dialog(
          title: Container(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              S.of(context).categories,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ),
          dialogProps: DialogProps(
            clipBehavior: Clip.antiAlias,
            shape: OutlineInputBorder(
              borderSide: const BorderSide(width: 0),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        validator: (value) => utils.FormValidation.validateDoubleField(
          fieldValue: value.toString(),
          errorMessage: S.of(context).input_validation_error_message_for_doubles,
        ),
        onSaved: (value) => ref.read(productFormDataProvider.notifier).update(key: 'category', value: value.toString()),
      ),
    );
  }
}
