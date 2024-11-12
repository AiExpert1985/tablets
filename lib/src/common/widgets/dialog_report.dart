import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';

const double dialogHeightFactor = 0.6;
const double iconSize = 15.0;

void showReportDialog(
  BuildContext context,
  double width,
  double height,
  List<String> columnTitles,
  List<List<dynamic>> dataList, {
  String? title,
  int? dateIndex,
  int? dropdownIndex,
  List<String>? dropdownList,
  int? sumIndex,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return _DateFilterDialog(
        title: title,
        width: width,
        height: height,
        titleList: columnTitles,
        dataList: dataList,
        dateIndex: dateIndex,
        dropdownIndex: dropdownIndex,
        dropdownList: dropdownList,
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
  final int? dropdownIndex;
  final List<String>? dropdownList;
  final int? sumIndex;

  const _DateFilterDialog({
    required this.width,
    required this.height,
    required this.titleList,
    required this.dataList,
    this.title,
    this.dateIndex,
    this.dropdownIndex,
    this.dropdownList,
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
                _buildCancelButton(startDate, () {
                  setState(() {
                    startDate = null;
                  });
                  _filterOnDate(widget.dataList, widget.dateIndex!, startDate, endDate);
                }),
                _buildDatePicker('start_date', startDate, S.of(context).from_date, (value) {
                  setState(() {
                    startDate = value;
                  });
                  _filterOnDate(widget.dataList, widget.dateIndex!, startDate, endDate);
                }),
                HorizontalGap.xl,
                _buildCancelButton(endDate, () {
                  setState(() {
                    endDate = null;
                  });
                  _filterOnDate(widget.dataList, widget.dateIndex!, startDate, endDate);
                }),
                _buildDatePicker('end_date', endDate, S.of(context).to_date, (value) {
                  setState(() {
                    endDate = value;
                  });
                  _filterOnDate(widget.dataList, widget.dateIndex!, startDate, endDate);
                }),
              ],
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
      if (list.length <= dateIndex) return false;
      DateTime date;
      try {
        date = DateTime.parse(list[dateIndex].toString());
      } catch (e) {
        return false;
      }
      return (start == null || date.isAfter(start) || date.isAtSameMomentAs(start)) &&
          (end == null || date.isBefore(end) || date.isAtSameMomentAs(end));
    }).toList();
    setState(() {
      filteredList = newList;
    });
  }

  Widget _buildDatePicker(
      String name, DateTime? initialValue, String labelText, ValueChanged<DateTime?> onChanged) {
    return Expanded(
      child: FormBuilderDateTimePicker(
        textAlign: TextAlign.center,
        name: name,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        initialValue: initialValue,
        inputType: InputType.date,
        format: DateFormat('dd-MM-yyyy'),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCancelButton(DateTime? date, VoidCallback onPressed) {
    return Visibility(
      visible: date != null,
      child: IconButton(
        icon: const Icon(Icons.clear, size: iconSize, color: Colors.red),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildListTitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.titleList.map((item) {
          return SizedBox(
            width: widget.width / widget.titleList.length,
            child: Text(
              item,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: widget.width,
      height: widget.height * dialogHeightFactor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredList.length,
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 0.2, color: Colors.grey),
              itemBuilder: (context, index) {
                final data = filteredList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: data.map((item) {
                      if (item is DateTime) item = formatDate(item);
                      return SizedBox(
                        width: widget.width / widget.titleList.length,
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
    );
  }

  Widget _buildTitle() {
    return Text(widget.title!, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  List<Widget> _buildButtons() {
    return <Widget>[
      Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const PrintIcon(),
              onPressed: () {
                // TODO: Implement print functionality
              },
            ),
            HorizontalGap.m,
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
