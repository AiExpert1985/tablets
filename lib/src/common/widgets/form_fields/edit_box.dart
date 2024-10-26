import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

class FormInputField extends ConsumerWidget {
  const FormInputField({
    required this.formData,
    required this.onChangedFn,
    required this.fieldName,
    this.subFieldName,
    this.label,
    this.isRequired = true, // if isRequired = false, then the field will not be validated
    this.hideBorders = false, // hide borders in decoration, used if the field in sub list
    // isReadOnly: sometimes we need item to be not editable, usually when it is set by another field
    this.isReadOnly = false,
    required this.dataType, // to be used for validation based on datatype (int, double, string)
    super.key,
  });

  final void Function(Map<String, dynamic>) onChangedFn;
  final FieldDataTypes dataType;
  final String fieldName;
  final Map<String, dynamic> formData;
  final String? label;
  final bool isRequired; // if not required, then it will not be validated
  final bool isReadOnly; // if isReadOnly = true, then user can't edit this field
  final bool hideBorders;
  final String? subFieldName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dynamic initialValue = formData[fieldName];
    if (initialValue != null) {
      initialValue = dataType == FieldDataTypes.string ? initialValue : initialValue.toString();
    }
    return Expanded(
      child: FormBuilderTextField(
        readOnly: isReadOnly,
        textAlign: TextAlign.center,
        name: fieldName,
        initialValue: initialValue,
        decoration: hideBorders
            ? utils.formFieldDecoration(label: label, hideBorders: true)
            : utils.formFieldDecoration(label: label),
        onChanged: (value) {
          if (value == null) return; // since we update on change, we must ensure value isn't null
          dynamic userValue = value;
          if (dataType == FieldDataTypes.int) {
            userValue = int.tryParse(value);
          }
          if (dataType == FieldDataTypes.double) {
            userValue = double.tryParse(value);
          }
          if (subFieldName == null) {
            formData[fieldName] = userValue;
          } else {
            formData[fieldName] ??= [];
            formData[fieldName].add({subFieldName: userValue});
          }

          onChangedFn(formData);
        },
        validator: isRequired
            ? (value) {
                if (dataType == FieldDataTypes.string) {
                  return validation.validateStringField(
                      fieldValue: value,
                      errorMessage: S.of(context).input_validation_error_message_for_strings);
                }
                if (dataType == FieldDataTypes.int) {
                  return validation.validateIntField(
                      fieldValue: value,
                      errorMessage: S.of(context).input_validation_error_message_for_integers);
                }
                if (dataType == FieldDataTypes.double) {
                  return validation.validateDoubleField(
                      fieldValue: value,
                      errorMessage: S.of(context).input_validation_error_message_for_doubles);
                }
                return null;
              }
            : null,
      ),
    );
  }
}
