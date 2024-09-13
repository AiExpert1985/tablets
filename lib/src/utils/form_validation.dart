import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';

/// used in form validation to check if entered value is a valid number
String? validateNumberFields({
  required String? fieldValue,
  required BuildContext context,
}) {
  if (fieldValue == null || double.tryParse(fieldValue) == null) {
    return S.of(context).input_validation_error_message_for_numbers;
  }
  return null;
}

/// used in form validation to check if entered name is valid
String? validateNameFields({
  required String? fieldValue,
  required BuildContext context,
}) {
  if (fieldValue == null ||
      fieldValue.trim().isEmpty ||
      fieldValue.trim().length < 2) {
    return S.of(context).input_validation_error_message_for_names;
  }
  return null;
}
