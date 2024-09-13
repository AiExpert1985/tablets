import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:toastification/toastification.dart';

class CustomDebug {
  static void print(message) {
    debugPrint('------------------------$message--------------------------');
  }
}

class UserMessages {
  static void success(
      {required BuildContext context, required String message}) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      showProgressBar: false,
    );
  }

  static void failure(
      {required BuildContext context, required String message}) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      showProgressBar: false,
    );
  }

  static void info({required BuildContext context, required String message}) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      showProgressBar: false,
    );
  }
}

class FormValidation {
  static String? validateNumberField({
    required String? fieldValue,
    required BuildContext context,
  }) {
    if (fieldValue == null || double.tryParse(fieldValue) == null) {
      return S.of(context).input_validation_error_message_for_numbers;
    }
    return null;
  }

  /// used in form validation to check if entered name is valid
  static String? validateNameField({
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
}
