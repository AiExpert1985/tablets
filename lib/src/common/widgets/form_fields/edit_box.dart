import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

// either use controller or initialvalue not both
// we use controller only when we need to set the initialValue using another field
// usually a sibling dropdown field
class FormInputField extends ConsumerWidget {
  const FormInputField({
    required this.formData,
    required this.onChangedFn,
    required this.property,
    this.label,
    this.isRequired = true,
    this.hideBorders = false,
    this.isReadOnly = false,
    required this.dataType,
    this.subPropertyIndex,
    this.subProperty,
    this.controller,
    super.key,
  });

  final void Function(Map<String, dynamic>) onChangedFn;
  final FieldDataTypes dataType;
  final String property;
  final Map<String, dynamic> formData;
  final String? label;
  final bool isRequired;
  final bool isReadOnly;
  final bool hideBorders;
  final int? subPropertyIndex;
  final String? subProperty;
  final TextEditingController? controller;

  String getInitialValue() {
    dynamic initialValue;
    if (formData[property] == null) {
      initialValue = '';
    } else if (subProperty == null) {
      initialValue = formData[property];
    } else {
      initialValue = formData[property][subPropertyIndex][subProperty] ?? 0;
    }
    return initialValue.runtimeType is String ? initialValue : initialValue.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: FormBuilderTextField(
        // initialValue: controller == null ? getInitialValue() : null,
        controller: controller,
        readOnly: isReadOnly,
        textAlign: TextAlign.center,
        name: property,
        decoration: hideBorders
            ? utils.formFieldDecoration(label: label, hideBorders: true)
            : utils.formFieldDecoration(label: label),
        onChanged: (value) {
          if (value == null || value.trim().isEmpty) return;
          dynamic userValue = value;
          if (dataType == FieldDataTypes.int) {
            userValue = int.tryParse(value);
          }
          if (dataType == FieldDataTypes.double) {
            userValue = double.tryParse(value);
          }
          if (subProperty == null) {
            formData[property] = userValue;
          } else {
            formData[property] ??= [];
            formData[property][subPropertyIndex][subProperty] = userValue;
          }
          onChangedFn(formData);
        },
        validator: isRequired
            ? (value) {
                if (dataType == FieldDataTypes.string) {
                  return validation.validateStringField(
                      fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_strings);
                }

                if (dataType == FieldDataTypes.int) {
                  return validation.validateIntField(
                      fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_integers);
                }

                if (dataType == FieldDataTypes.double) {
                  return validation.validateDoubleField(
                      fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_doubles);
                }
                return null;
              }
            : null,
      ),
    );
  }
}
