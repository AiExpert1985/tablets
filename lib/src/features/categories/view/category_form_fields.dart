import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/constants/constants.dart' as constants;
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;
import 'package:tablets/src/features/categories/controllers/category_form_fields_data_provider.dart';

class CategoryFormFields extends ConsumerWidget {
  const CategoryFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(categoryFormFieldsDataProvider);
    return GeneralFormField(
      dataType: constants.FieldDataTypes.string.name,
      name: 'name',
      displayedTitle: S.of(context).product_name,
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
    final userFormData = ref.watch(categoryFormFieldsDataProvider);
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
          if (dataType == constants.FieldDataTypes.int.name) {
            userValue = int.tryParse(value!);
          }
          if (dataType == constants.FieldDataTypes.double.name) {
            userValue = double.tryParse(value!);
          }
          ref.read(categoryFormFieldsDataProvider.notifier).update(key: name, value: userValue);
        },
        validator: (value) {
          if (dataType == constants.FieldDataTypes.string.name) {
            return validation.validateStringField(
                fieldValue: value,
                errorMessage: S.of(context).input_validation_error_message_for_strings);
          }
          if (dataType == constants.FieldDataTypes.int.name) {
            return validation.validateIntField(
                fieldValue: value,
                errorMessage: S.of(context).input_validation_error_message_for_integers);
          }
          if (dataType == constants.FieldDataTypes.double.name) {
            return validation.validateDoubleField(
                fieldValue: value,
                errorMessage: S.of(context).input_validation_error_message_for_doubles);
          }
          return null;
        },
      ),
    );
  }
}
