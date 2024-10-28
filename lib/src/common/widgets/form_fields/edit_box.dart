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

  @override
  FormInputFieldState createState() => FormInputFieldState();
}

class FormInputFieldState extends ConsumerState<FormInputField> {
  late TextEditingController controller = TextEditingController();
  final WidgetStatesController _statesController = WidgetStatesController();

  void setBoxValue() {
    tempPrint('setBoxValue is called');
    dynamic initialValue;
    if (widget.formData[widget.property] == null) {
      initialValue = '';
    } else if (widget.subProperty == null) {
      initialValue = widget.formData[widget.property];
    } else {
      initialValue = widget.formData[widget.property][widget.subPropertyIndex][widget.subProperty] ?? 0;
    }

    controller.text = initialValue.runtimeType is String ? initialValue : initialValue.toString();

    // return initialValue.runtimeType is String ? initialValue : initialValue.toString();
  }

  @override
  void initState() {
    controller.addListener(() {
      tempPrint('listener has listened');
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FormBuilderTextField(
        controller: controller,
        readOnly: widget.isReadOnly,
        textAlign: TextAlign.center,
        name: widget.property,
        decoration: widget.hideBorders
            ? utils.formFieldDecoration(label: widget.label, hideBorders: true)
            : utils.formFieldDecoration(label: widget.label),
        onChanged: (value) {
          tempPrint('onChanged is called');
        },
        statesController: _statesController,
        onReset: () => tempPrint('onRest is called'),
        onSaved: (value) {
          if (value == null || value == '') return;
          dynamic userValue = value;
          if (widget.dataType == FieldDataTypes.int) {
            tempPrint('1');
            userValue = int.tryParse(value);
          }
          if (widget.dataType == FieldDataTypes.double) {
            userValue = double.tryParse(value);
            tempPrint('2');
          }
          if (widget.subProperty == null) {
            tempPrint('3');
            widget.formData[widget.property] = userValue;
          } else {
            tempPrint('4');
            widget.formData[widget.property] ??= [];
            widget.formData[widget.property][widget.subPropertyIndex][widget.subProperty] = userValue;
          }
          tempPrint(widget.formData);
          widget.onChangedFn(widget.formData);
        },
        validator: widget.isRequired
            ? (value) {
                if (widget.dataType == FieldDataTypes.string) {
                  return validation.validateStringField(
                      fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_strings);
                }

                if (widget.dataType == FieldDataTypes.int) {
                  return validation.validateIntField(
                      fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_integers);
                }

                if (widget.dataType == FieldDataTypes.double) {
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
