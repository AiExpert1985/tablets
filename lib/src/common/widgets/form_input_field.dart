import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/constants/constants.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

class FormInputField extends ConsumerWidget {
  const FormInputField({
    required this.formDataUpdateFn,
    required this.dataType,
    required this.name,
    required this.displayedTitle,
    this.initialValue,
    super.key,
  });

  final String? initialValue;
  final void Function({required String key, required String value}) formDataUpdateFn;
  final FieldDataTypes dataType;
  final String name;
  final String displayedTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: FormBuilderTextField(
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
          formDataUpdateFn(key: name, value: userValue);
        },
        validator: (value) {
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
        },
      ),
    );
  }
}
