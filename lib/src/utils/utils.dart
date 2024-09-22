import 'dart:math';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomDebug {
  static void print({message, stackTrace}) {
    // Sometime the stack trace is shorter than 225, so I need to have protection against that
    String stackText = stackTrace.toString();
    int trimEnd = stackText.length < 225 ? stackText.length : 225;
    String details = stackText.substring(0, trimEnd);

    debugPrint('||===== Hamandi ====> $message =====> $details======||');
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
    required String errorMessage,
  }) {
    if (fieldValue == null || double.tryParse(fieldValue) == null) {
      return errorMessage;
    }
    return null;
  }

  /// used in form validation to check if entered name is valid
  static String? validateNameField({
    required String? fieldValue,
    required String errorMessage,
  }) {
    if (fieldValue == null ||
        fieldValue.trim().isEmpty ||
        fieldValue.trim().length < 2) {
      return errorMessage;
    }
    return null;
  }
}

class StringOperations {
  static String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }
}
