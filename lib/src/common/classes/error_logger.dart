import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:tablets/src/common/functions/debug_print.dart';

class Logger {
  static Future<File> _getLogFile() async {
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    // Define the log file path
    final logFilePath = '${directory.path}/error_log.txt';
    tempPrint(logFilePath);
    // Create the log file if it doesn't exist
    return File(logFilePath);
  }

  static Future<void> logError(String error) async {
    final file = await _getLogFile();
    // Append the error message with a timestamp
    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('$timestamp: $error\n', mode: FileMode.append);
  }
}
