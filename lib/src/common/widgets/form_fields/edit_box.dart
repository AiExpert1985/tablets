import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

class FormInputField extends StatefulWidget {
  const FormInputField({
    required this.formData,
    required this.onChangedFn,
    required this.fieldName,
    this.label,
    this.isRequired = true, // if isRequired = false, then the field will not be validated
    this.hideBorders = false, // hide borders in decoration, used if the field in sub list
    // isReadOnly: sometimes we need item to be not editable, usually when it is set by another field
    this.isReadOnly = false,
    required this.dataType, // to be used for validation based on datatype (int, double, string)
    this.subItemSequence,
    this.subItemProperty,
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
  final int? subItemSequence;
  final String? subItemProperty;

  @override
  State<FormInputField> createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  dynamic initialValue;
  @override
  void initState() {
    super.initState();
    if (widget.subItemSequence == null) {
      initialValue = widget.formData[widget.fieldName];
      return;
    }
    if (widget.subItemSequence! >= widget.formData[widget.fieldName].length) {
      initialValue = null;
      return;
    }
    initialValue = widget.formData[widget.fieldName][widget.subItemSequence][widget.subItemProperty];
  }

  @override
  Widget build(BuildContext context) {
    final onChangedFn = widget.onChangedFn;
    final dataType = widget.dataType;
    final fieldName = widget.fieldName;
    final formData = widget.formData;
    final label = widget.label;
    final isRequired = widget.isRequired; // if not required, then it will not be validated
    final isReadOnly = widget.isReadOnly; // if isReadOnly = true, then user can't edit this field
    final hideBorders = widget.hideBorders;
    final subItemSequence = widget.subItemSequence;
    final subItemProperty = widget.subItemProperty;
    if (initialValue != null) {
      initialValue = dataType == FieldDataTypes.string ? initialValue : initialValue.toString();
    }
    return Expanded(
      child: FormBuilderTextField(
        readOnly: isReadOnly,
        textAlign: TextAlign.center,
        name: fieldName,
        initialValue: initialValue.runtimeType is String ? initialValue : initialValue?.toString(),
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
          if (subItemProperty == null) {
            formData[fieldName] = userValue;
          } else {
            formData[fieldName] ??= [];
            formData[fieldName][subItemSequence][subItemProperty] = userValue;
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
