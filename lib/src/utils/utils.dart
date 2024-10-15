import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:image/image.dart' as img;

void errorDebugPrint({message, stackTrace}) {
  // Sometime the stack trace is shorter than 225, so I need to have protection against that
  String stackText = stackTrace.toString();
  int trimEnd = stackText.length < 225 ? stackText.length : 225;
  String details = stackText.substring(0, trimEnd);

  debugPrint('||===== Hamandi ====> $message =====> $details======||');
}

/// Temporary print for texting code
void tempDebugPrint(message) {
  debugPrint('||===== Temp Print ====> $message ======||');
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
      alignment: Alignment.topCenter,
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

String generateRandomString({int len = 5}) {
  var r = Random();
  return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89)).toString();
}

/// compare two Lists of string
/// find items in the first list that don't exists in second list
List<String> twoListsDifferences(List<String> list1, List<String> list2) =>
    list1.where((item) => !list2.toSet().contains(item)).toList();

// Default result image size is 50 k byte (reduce speed and the cost of firebase)
// compression depends on image size, the larget image the more compression
// if image size is small, it will not be compressed
Uint8List? compressImage(Uint8List? image, {int targetImageSizeInBytes = 51200}) {
  final quality = (image!.length / targetImageSizeInBytes).round();
  if (quality > 0) {
    image = img.encodeJpg(img.decodeImage(image)!, quality: quality);
  }
  return image;
}

InputDecoration formFieldDecoration({String? label}) {
  return InputDecoration(
    // floatingLabelAlignment: FloatingLabelAlignment.center,
    label: label == null
        ? null
        : Text(
            label,
            // textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black38,
            ),
          ),
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.all(12),
    isDense: true, // Add this line to remove the default padding
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
}
