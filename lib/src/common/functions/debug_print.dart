import 'package:flutter/material.dart';

void errorPrint({message, stackTrace}) {
  // Sometime the stack trace is shorter than 225, so I need to have protection against that
  String stackText = stackTrace.toString();
  int trimEnd = stackText.length < 225 ? stackText.length : 225;
  String details = stackText.substring(0, trimEnd);

  debugPrint('||===== Catched Error ====> $message =====> $details======||');
}

/// Temporary print for texting code
void tempPrint(message) {
  debugPrint('||===== Debug Print ====> $message ======||');
}
