String? validateNumberField({
  required String? fieldValue,
  required String errorMessage,
}) {
  if (fieldValue == null || double.tryParse(fieldValue) == null) {
    return errorMessage;
  }
  return null;
}

/// used in form validation to check if entered name is valid
String? validateTextField({
  required String? fieldValue,
  required String errorMessage,
}) {
  if (fieldValue == null || fieldValue.trim().isEmpty || fieldValue.trim().length < 2) {
    return errorMessage;
  }
  return null;
}

String? validateDropDownField({
  required String? fieldValue,
  required String errorMessage,
}) {
  if (fieldValue == null) {
    return errorMessage;
  }
  return null;
}

String? validateDatePicker({
  required DateTime? fieldValue,
  required String errorMessage,
}) {
  if (fieldValue == null) {
    return errorMessage;
  }
  return null;
}
