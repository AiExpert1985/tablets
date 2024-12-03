import 'package:flutter/material.dart';
import 'package:tablets/src/common/classes/error_logger.dart';

void errorPrint(dynamic message, {stackTrace}) {
  // Sometime the stack trace is shorter than 225, so I need to have protection against that
  String stackText = stackTrace.toString();
  int trimEnd = stackText.length < 225 ? stackText.length : 225;
  String details = stackText.substring(0, trimEnd);
  debugPrint('||===== Catched Error ====> $message =====> $details======||');
  // write error to the log file
  logPrint('$message');
}

/// Temporary print for texting code
void tempPrint(dynamic message) {
  debugPrint('||===== Debug Print ====> $message ======||');
}

void logPrint(dynamic message) {
  Logger.logError('$message');
}
