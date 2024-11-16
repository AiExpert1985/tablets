import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';

/// A text data cell that is used for main screen for all features
/// if it is header, then the text will be bold and larger
/// if it is warning for user, then it will be red colored
/// if it is a column total, then the value will be put inside paranthesis
class MainScreenTextCell extends StatelessWidget {
  final dynamic data;
  final bool isExpanded;
  final bool isHeader;
  final bool isWarning;
  final bool isColumnTotal;

  const MainScreenTextCell(
    this.data, {
    super.key,
    this.isExpanded = true,
    this.isHeader = false,
    this.isWarning = false,
    this.isColumnTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    String processedData;
    if (data is double || data is int) {
      processedData = doubleToStringWithComma(data);
      if (isColumnTotal) processedData = '($processedData)';
    } else if (data is DateTime) {
      processedData = formatDate(data);
    } else if (data is String) {
      processedData = data;
    } else {
      processedData = 'Unknown data type';
    }
    Widget cell = Text(
      processedData,
      textAlign: TextAlign.center,
      style: isHeader
          ? const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )
          : TextStyle(fontSize: 16, color: isWarning ? Colors.red : null),
    );
    if (isExpanded) {
      cell = Expanded(child: cell);
    }
    return cell;
  }
}

/// Empty cell used as place holder in list data or list headers
class MainScreenPlaceholder extends StatelessWidget {
  final bool isExpanded;
  final double? width;

  const MainScreenPlaceholder({
    super.key,
    this.isExpanded = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Widget cell = SizedBox(width: width);
    if (isExpanded) {
      cell = Expanded(child: cell);
    }
    return cell;
  }
}

/// A clickable cell that is used for main screen for all features
/// if it is warning for user, then it will be red colored
/// this cell is clickable, when it is clicked, it runs onTap fucntion
class MainScreenClickableCell extends StatelessWidget {
  final dynamic data;
  final VoidCallback onTap;
  final bool isWarning;
  final bool isExpanded;

  const MainScreenClickableCell(
    this.data,
    this.onTap, {
    super.key,
    this.isWarning = false,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget cell = InkWell(
      onTap: onTap,
      child: MainScreenTextCell(data, isWarning: isWarning, isExpanded: false),
    );
    if (isExpanded) {
      cell = Expanded(child: cell);
    }
    return cell;
  }
}

/// clickable a avatar image that opens an edit form
/// used in main screen of almost all features as the button that show the item form
class MainScreenEditButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const MainScreenEditButton(
    this.imageUrl,
    this.onTap, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 15,
        foregroundImage: CachedNetworkImageProvider(imageUrl),
      ),
    );
  }
}

// returns a cell that is used for main screen List Column title
// if it is a column total, then the value will be put inside paranthesis
class MainScreenHeaderCell extends StatelessWidget {
  final dynamic data;
  final bool isExpanded;
  final bool isColumnTotal;

  const MainScreenHeaderCell(
    this.data, {
    super.key,
    this.isExpanded = true,
    this.isColumnTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return MainScreenTextCell(
      data,
      isExpanded: isExpanded,
      isHeader: true,
      isColumnTotal: isColumnTotal,
    );
  }
}
