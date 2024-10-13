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

  /// Temporary print for texting code
  static void tempPrint(message) {
    debugPrint('||===== Temp Print ====> $message ======||');
  }
}

class UserMessages {
  static void success({required BuildContext context, required String message}) =>
      _message(context: context, message: message, type: ToastificationType.success);

  static void failure({required BuildContext context, required String message}) =>
      _message(context: context, message: message, type: ToastificationType.error);

  static void info({required BuildContext context, required String message}) =>
      _message(context: context, message: message, type: ToastificationType.info);

  static void _message({required BuildContext context, required String message, required type}) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      showIcon: false,
    );
  }
}

class FormValidation {
  static String? validateDoubleField({
    required String? fieldValue,
    required String errorMessage,
  }) {
    if (fieldValue == null || double.tryParse(fieldValue) == null) {
      return errorMessage;
    }
    return null;
  }

  static String? validateIntField({
    required String? fieldValue,
    required String errorMessage,
  }) {
    if (fieldValue == null || int.tryParse(fieldValue) == null) {
      return errorMessage;
    }
    return null;
  }

  /// used in form validation to check if entered name is valid
  static String? validateStringField({
    required String? fieldValue,
    required String errorMessage,
  }) {
    if (fieldValue == null || fieldValue.trim().isEmpty || fieldValue.trim().length < 2) {
      return errorMessage;
    }
    return null;
  }

  static String? validateDropDownField({
    required String? fieldValue,
    required String errorMessage,
  }) {
    if (fieldValue == null) {
      return errorMessage;
    }
    return null;
  }
}

class StringOperations {
  static String generateRandomString({int len = 5}) {
    var r = Random();
    return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89)).toString();
  }
}

class ListOperations {
  /// compare two Lists of string
  /// find items in the first list that don't exists in second list
  static List<String> twoListsDifferences(List<String> list1, List<String> list2) =>
      list1.where((item) => !list2.toSet().contains(item)).toList();
}
