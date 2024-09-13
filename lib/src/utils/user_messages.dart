import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showSuccessSnackbar(
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

void showFailureSnackbar(
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

void showInfoSnackbar(
    {required BuildContext context, required String message}) {
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
