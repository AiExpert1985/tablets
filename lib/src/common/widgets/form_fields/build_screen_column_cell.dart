import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';

// returns a cell that is used for main screen for all features
// if it is header, then the text will be bold and larger
// if it is warning for user, then it will be red colored
// if it is a column total, then the value will be put inside paranthesis
Widget buildMainScreenCell(dynamic data,
    {bool isHeader = false, bool isWarning = false, isColumnTotal = false}) {
  String processedData;
  if (data is double || data is int) {
    processedData = doubleToStringWithComma(data);
    if (isColumnTotal) processedData = '($processedData)';
  } else if (data is DateTime) {
    processedData = formatDate(data);
  } else if (data is String) {
    processedData = data;
  } else {
    processedData = 'Unkonw data type';
  }
  return Text(
    processedData,
    textAlign: TextAlign.center,
    style: isHeader
        ? TextStyle(fontSize: 16, color: isWarning ? Colors.red : null)
        : const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
  );
}

buildMainScreenPlaceholder({double? width}) {
  return SizedBox(
    width: width,
  );
}
