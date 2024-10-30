import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/form_validation.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:cloud_firestore/cloud_firestore.dart';

class FormDatePickerField extends StatelessWidget {
  const FormDatePickerField({
    this.initialValue,
    required this.onChangedFn,
    required this.fieldName,
    this.label,
    this.isRequired = true,
    this.hideBorders = false,
    super.key,
  });
  final DateTime? initialValue;
  final String? label;
  final String fieldName;
  final bool hideBorders; // hide borders in decoration, used if the field in sub list
  final bool isRequired; // if isRequired = false, then the field will not be validated
  final void Function(DateTime?) onChangedFn;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FormBuilderDateTimePicker(
        decoration: hideBorders
            ? utils.formFieldDecoration(label: label, hideBorders: true)
            : utils.formFieldDecoration(label: label),
        textAlign: TextAlign.center,
        name: fieldName,
        initialValue: initialValue,
        fieldHintText: S.of(context).date_picker_hint,
        inputType: InputType.date,
        onChanged: (value) {
          // since we update on change, we must ensure value isn't null
          if (value == null) return;
          onChangedFn(value);
        },
        validator: (value) => isRequired
            ? validateDatePicker(
                fieldValue: value,
                errorMessage: S.of(context).input_validation_error_message_for_date)
            : null,
      ),
    );
  }
}
