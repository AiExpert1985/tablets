import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

class FormInputField extends ConsumerWidget {
  const FormInputField({
    required this.onChangedFn,
    this.initialValue,
    this.label,
    this.isRequired = true,
    this.hideBorders = false,
    this.isReadOnly = false,
    required this.dataType,
    this.controller,
    required this.name,
    super.key,
  });

  final String? initialValue;
  final String? label; // label displayed in the fiedl
  final FieldDataTypes dataType; // used mainly for validation (based on datatype) purpose
  final void Function(String) onChangedFn;
  // isReadOnly used for fields that I don't want to be edited by user, for example
  // totalprice of an invoice which is the sum of item prices in the invoice
  final bool isReadOnly;
  final bool isRequired; // some field are optional to fill
  final bool hideBorders; // usually used for fields inside the item list
  // I mainly use controller to reflect changes caused by other fields
  // for example when an adjacent dropdown is select, this field is changed
  final TextEditingController? controller;
  final String name; // used by the widget, not used by me

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: FormBuilderTextField(
        // // if controller is used, initialValue should be neglected
        // initialValue: controller != null
        //     ? null
        //     : initialValue != null && initialValue is! String
        //         ? initialValue.toString()
        //         : initialValue,
        // controller: controller,
        enabled: !isReadOnly,
        textAlign: TextAlign.center,
        name: name,
        decoration: hideBorders
            ? utils.formFieldDecoration(label: label, hideBorders: true)
            : utils.formFieldDecoration(label: label),
        onChanged: (value) {
          if (value == null || value.trim().isEmpty) return;
          // I need to convert to dynamic because entered value may be converted to different types
          // (int, double, String) based on the datatype of data intended for this field
          dynamic userValue = value;
          if (dataType == FieldDataTypes.int) {
            userValue = int.tryParse(value);
          }
          if (dataType == FieldDataTypes.double) {
            userValue = double.tryParse(value);
          }
          onChangedFn(userValue);
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
