import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void success({required BuildContext context, required String message}) =>
    _message(context: context, message: message, type: ToastificationType.success);

void failure({required BuildContext context, required String message}) =>
    _message(context: context, message: message, type: ToastificationType.error);

void info({required BuildContext context, required String message}) =>
    _message(context: context, message: message, type: ToastificationType.info);

void _message({required BuildContext context, required String message, required type}) {
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
