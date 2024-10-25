import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

class FormInputField extends ConsumerWidget {
  const FormInputField({
    required this.onSaveFn, //update the formData when saved
    required this.dataType, // to be used for validation based on datatype
    required this.name, // required by the FormBuilder
    required this.displayedTitle, // decoration title
    required this.formData, // used for initial value
    this.isRequired = true,
    super.key,
  });

  final void Function({required String key, required dynamic value}) onSaveFn;
  final FieldDataTypes dataType;
  final String name;
  final String displayedTitle;
  final Map<String, dynamic> formData;
  final bool isRequired; // if not required, then it will not be validated

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dynamic initialValue = formData[name];
    if (initialValue != null) {
      initialValue = dataType == FieldDataTypes.string ? initialValue : initialValue.toString();
    }
    return Expanded(
      child: FormBuilderTextField(
        textAlign: TextAlign.center,
        name: name,
        initialValue: initialValue,
        decoration: utils.formFieldDecoration(label: displayedTitle),
        onSaved: (value) {
          dynamic userValue = value;
          if (dataType == FieldDataTypes.int) {
            userValue = int.tryParse(value!);
          }
          if (dataType == FieldDataTypes.double) {
            userValue = double.tryParse(value!);
          }
          onSaveFn(key: name, value: userValue);
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
