import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';

// returns a cell that is used for main screen for all features
// if it is header, then the text will be bold and larger
// if it is warning for user, then it will be red colored
// if it is a column total, then the value will be put inside paranthesis
Widget buildMainScreenTextCell(dynamic data,
    {isExpanded = true, bool isHeader = false, bool isWarning = false, isColumnTotal = false}) {
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
  Widget cell = Text(
    processedData,
    textAlign: TextAlign.center,
    style: isHeader
        ? const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        : TextStyle(fontSize: 16, color: isWarning ? Colors.red : null),
  );
  if (isExpanded) {
    cell = Expanded(child: cell);
  }
  return cell;
}

Widget buildMainScreenPlaceholder({isExpanded = true, double? width}) {
  Widget cell = SizedBox(width: width);
  if (isExpanded) {
    cell = Expanded(child: cell);
  }
  return cell;
}

// returns a cell that is used for main screen for all features
// if it is warning for user, then it will be red colored
// this cell is clickable, when it is clicked, it runs onTap fucntion
Widget buildMainScreenClickableCell(dynamic data, VoidCallback onTap,
    {bool isWarning = false, isExpanded = true}) {
  Widget cell = InkWell(
    onTap: onTap,
    child: buildMainScreenTextCell(data, isWarning: isWarning, isExpanded: false),
  );
  if (isExpanded) {
    cell = Expanded(child: cell);
  }
  return cell;
}

// returns a avatar image that runs form edit function when clicked
// this is used for all features as the button that show the item form
Widget buildMainScreenEditButton(String imageUrl, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: CircleAvatar(
      radius: 15,
      foregroundImage: CachedNetworkImageProvider(imageUrl),
    ),
  );
}

// returns a cell that is used for main screen List Column title
// if it is a column total, then the value will be put inside paranthesis
Widget buildMainScreenHeaderCell(dynamic data, {isExpanded = true, isColumnTotal = false}) {
  return buildMainScreenTextCell(data,
      isExpanded: isExpanded, isHeader: true, isColumnTotal: isColumnTotal);
}
