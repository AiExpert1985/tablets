import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/form_validation.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:cloud_firestore/cloud_firestore.dart';

class FormDatePickerField extends StatelessWidget {
  const FormDatePickerField({required this.onSaveFn, required this.formData, super.key});
  final void Function({required String key, required dynamic value}) onSaveFn;
  final Map<String, dynamic> formData;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FormBuilderDateTimePicker(
        decoration: utils.formFieldDecoration(label: S.of(context).transaction_date),
        textAlign: TextAlign.center,
        name: 'date',
        initialValue: formData['date']?.runtimeType == DateTime ? formData['date'] : null,
        fieldHintText: S.of(context).date_picker_hint,
        inputType: InputType.date,
        onSaved: (value) => onSaveFn(key: 'date', value: Timestamp.fromDate(value!)),
        validator: (value) => validateDatePicker(
            fieldValue: value, errorMessage: S.of(context).input_validation_error_message_for_date),
      ),
    );
  }
}
