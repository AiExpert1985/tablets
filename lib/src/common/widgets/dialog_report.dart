import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';

void showReportDialog(
  BuildContext context,
  double width,
  double height,
  List<String> columnTitles,
  List<List<dynamic>> dataList, {
  String? title,
  int? dateIndex,
  // int? dropdownIndex,
  // List<String>? dropdownList,
  int? sumIndex,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _DateFilterDialog(
        title: title,
        width: width,
        height: height,
        titleList: columnTitles,
        dataList: dataList,
        dateIndex: dateIndex,
        //          dropdownIndex: dropdownIndex,
        //  dropdownList:dropdownList,
        sumIndex: sumIndex,
      );
    },
  );
}

class _DateFilterDialog extends StatefulWidget {
  final double width;
  final double height;
  final List<String> titleList;
  final List<List<dynamic>> dataList;
  final String? title;
  final int? dateIndex;
  // final int? dropdownIndex;
  // final List<String>? dropdownList;
  final int? sumIndex;

  const _DateFilterDialog({
    required this.width,
    required this.height,
    required this.titleList,
    required this.dataList,
    this.title,
    this.dateIndex,
    // this.dropdownIndex,
    // this.dropdownList,
    this.sumIndex,
  });

  @override
  __DateFilterDialogState createState() => __DateFilterDialogState();
}

class __DateFilterDialogState extends State<_DateFilterDialog> {
  DateTime? startDate;
  DateTime? endDate;
  List<List<dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = List.from(widget.dataList);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.title != null) _buildTitle(),
            VerticalGap.xl,
            Row(
              children: [
                _buildStartDateCancelButton(),
                _buildStartDatePicker(),
                HorizontalGap.xl,
                _buildEndDateCancelButton(),
                _buildEndDatePicker(),
              ],
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Make the column take minimum height
        children: [
          const Divider(),
          _buildListTitles(),
          const Divider(),
          _buildDataList(),
        ],
      ),
      actions: _buildButtons(),
    );
  }

  void _filterOnDate(List<List<dynamic>> dataList, int dateIndex, DateTime? start, DateTime? end) {
    final newList = dataList.where((list) {
      if (list.length <= dateIndex) {
        return false;
      }
      DateTime date;
      try {
        date = DateTime.parse(list[dateIndex].toString());
      } catch (e) {
        return false;
      }
      bool afterStart = start == null || date.isAfter(start) || date.isAtSameMomentAs(start);
      bool beforeEnd = end == null || date.isBefore(end) || date.isAtSameMomentAs(end);
      return afterStart && beforeEnd;
    }).toList();
    setState(() {
      filteredList = newList;
    });
  }

  Widget _buildStartDateCancelButton() {
    return Visibility(
      visible: startDate != null,
      child: IconButton(
        icon: const Icon(
          Icons.clear,
          size: 15,
          color: Colors.red,
        ), // Clear icon
        onPressed: () {
          setState(() {
            startDate = null; // Remove date filter
          });
          _filterOnDate(widget.dataList, widget.dateIndex!, startDate, endDate);
        },
      ),
    );
  }

  Widget _buildStartDatePicker() {
    return Expanded(
      child: FormBuilderDateTimePicker(
        textAlign: TextAlign.center,
        name: 'start_date',
        decoration: InputDecoration(
          labelText: S.of(context).from_date,
          border: const OutlineInputBorder(),
        ),
        initialValue: startDate,
        inputType: InputType.date, // Set to date only
        format: DateFormat('dd-MM-yyyy'),
        onChanged: (value) {
          setState(() {
            startDate = value;
          });
          _filterOnDate(widget.dataList, widget.dateIndex!, startDate, endDate);
        },
      ),
    );
  }

  Widget _buildEndDateCancelButton() {
    return Visibility(
      visible: endDate != null,
      child: IconButton(
        icon: const Icon(
          Icons.clear,
          size: 15,
          color: Colors.red,
        ), // Clear icon
        onPressed: () {
          setState(() {
            endDate = null; // Remove date filter
          });
          _filterOnDate(widget.dataList, widget.dateIndex!, startDate, endDate);
        },
      ),
    );
  }

  Widget _buildEndDatePicker() {
    return Expanded(
      child: FormBuilderDateTimePicker(
        textAlign: TextAlign.center,
        name: 'end_date',
        decoration: InputDecoration(
          labelText: S.of(context).to_date,
          border: const OutlineInputBorder(),
        ),
        initialValue: endDate,
        inputType: InputType.date, // Set to date only
        format: DateFormat('dd-MM-yyyy'),
        onChanged: (value) {
          setState(() {
            endDate = value;
          });
          _filterOnDate(widget.dataList, widget.dateIndex!, startDate, endDate);
        },
      ),
    );
  }

  Widget _buildListTitles() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased height of titles
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.titleList.map((item) {
            return SizedBox(
              width: widget.width / widget.titleList.length, // Set fixed width for each column
              child: Text(
                item,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildDataList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding for the list
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
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final data = filteredList[index];
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 5.0), // Reduced height of data rows
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: data.map((item) {
                          if (item is DateTime) item = formatDate(item);
                          if (item is! String) item = item.toString();
                          return SizedBox(
                            width: widget.width /
                                widget.titleList.length, // Set fixed width for each column
                            child: Text(
                              item.toString(),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(
                        thickness: 0.2,
                        color: Colors.grey) // Thin light horizontal line below each data row
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(widget.title!, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  List<Widget> _buildButtons() {
    return <Widget>[
      Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // Use min to wrap the buttons tightly
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
          children: [
            IconButton(
              icon: const PrintIcon(),
              onPressed: () {
                // TODO: Implement print functionality
              },
            ),
            HorizontalGap.m, // Add spacing between buttons
            IconButton(
              icon: const ShareIcon(),
              onPressed: () {
                // TODO: Implement share functionality
              },
            ),
          ],
        ),
      ),
    ];
  }
}
