import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';

void showDialogListWithDateFilter(
  BuildContext context,
  String title,
  double width,
  double height,
  List<String> columnTitles,
  List<List<dynamic>> dataList,
  int dateIndex,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _DateFilterDialog(
        title: title,
        width: width,
        height: height,
        columnTitles: columnTitles,
        dataList: dataList,
        dateIndex: dateIndex,
      );
    },
  );
}

class _DateFilterDialog extends StatefulWidget {
  final String title;
  final double width;
  final double height;
  final List<String> columnTitles;
  final List<List<dynamic>> dataList;
  final int dateIndex;

  const _DateFilterDialog({
    required this.title,
    required this.width,
    required this.height,
    required this.columnTitles,
    required this.dataList,
    required this.dateIndex,
  });

  @override
  __DateFilterDialogState createState() => __DateFilterDialogState();
}

class __DateFilterDialogState extends State<_DateFilterDialog> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Make the column take minimum height
        children: [
          // Date Picker
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  icon: Image.asset(
                    'assets/icons/buttons/date_picker.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                HorizontalGap.m,
                Text(
                  selectedDate == null ? '' : formatDate(selectedDate!),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(),
          // Column Titles (Not scrollable)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0), // Decrease height of titles
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widget.columnTitles.map((item) {
                return SizedBox(
                  width:
                      widget.width / widget.columnTitles.length, // Set fixed width for each column
                  child: Text(
                    item,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          // Data List
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15), // Adjust padding for the list
            width: widget.width,
            height: widget.height * 0.6, // Set a fixed height for the list
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data Rows
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Prevents scrolling of ListView
                    shrinkWrap: true, // Allows the ListView to take only the required height
                    itemCount: _filteredDataList(widget.dataList, widget.dateIndex).length,
                    itemBuilder: (context, index) {
                      final data = _filteredDataList(widget.dataList, widget.dateIndex)[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0), // Increase space of each data row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: data.map((item) {
                            if (item is DateTime) item = formatDate(item);
                            if (item is! String) item = item.toString();
                            return SizedBox(
                              width: widget.width /
                                  widget.columnTitles.length, // Set fixed width for each column
                              child: Text(
                                item.toString(),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: IconButton(
            icon: const CancelIcon(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  List<List<dynamic>> _filteredDataList(List<List<dynamic>> dataList, int dateIndex) {
    if (selectedDate == null) return dataList; // Return all data if no date is selected
    return dataList.where((row) {
      // Assuming the date is in the specified column; adjust index as necessary
      if (row.isNotEmpty && row[dateIndex] is DateTime) {
        return (row[dateIndex] as DateTime).isAfter(selectedDate!) ||
            (row[dateIndex] as DateTime).isAtSameMomentAs(selectedDate!);
      }
      return false; // Exclude rows without a valid date
    }).toList();
  }
}
