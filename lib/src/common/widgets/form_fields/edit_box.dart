import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

class FormInputField extends ConsumerStatefulWidget {
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

  @override
  FormInputFieldState createState() => FormInputFieldState();
}

class FormInputFieldState extends ConsumerState<FormInputField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        tempPrint('Controller text changed: ${widget.controller?.text}');
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(() {
        tempPrint('Controller listener removed');
      });
      widget.controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FormBuilderTextField(
        controller: widget.controller,
        readOnly: widget.isReadOnly,
        textAlign: TextAlign.center,
        name: widget.property,
        decoration: widget.hideBorders
            ? utils.formFieldDecoration(label: widget.label, hideBorders: true)
            : utils.formFieldDecoration(label: widget.label),
        onChanged: (value) {
          if (value == null) return;
          dynamic userValue = value;
          if (widget.dataType == FieldDataTypes.int) {
            userValue = int.tryParse(value);
          }
          if (widget.dataType == FieldDataTypes.double) {
            userValue = double.tryParse(value);
          }
          if (widget.subProperty == null) {
            widget.formData[widget.property] = userValue;
          } else {
            widget.formData[widget.property] ??= [];

            widget.formData[widget.property][widget.subPropertyIndex][widget.subProperty] =
                userValue;
          }
          widget.onChangedFn(widget.formData);
        },
        validator: widget.isRequired
            ? (value) {
                if (widget.dataType == FieldDataTypes.string) {
                  return validation.validateStringField(
                      fieldValue: value,
                      errorMessage: S.of(context).input_validation_error_message_for_strings);
                }

                if (widget.dataType == FieldDataTypes.int) {
                  return validation.validateIntField(
                      fieldValue: value,
                      errorMessage: S.of(context).input_validation_error_message_for_integers);
                }

                if (widget.dataType == FieldDataTypes.double) {
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
