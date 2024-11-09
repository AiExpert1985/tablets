import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';

void showDialogList(
  BuildContext context,
  String title,
  double width,
  double height,
  List<String> columnTitles,
  List<List<dynamic>> dataList,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
        content: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column Titles
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: columnTitles.map((item) {
                      return SizedBox(
                        width: width / columnTitles.length, // Set fixed width for each column
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
                // Data Rows
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Prevents scrolling of ListView
                  shrinkWrap: true, // Allows the ListView to take only the required height
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final data = dataList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: data.map((item) {
                          if (item is DateTime) item = formatDate(item);
                          if (item is! String) item = item.toString();
                          return SizedBox(
                            width: width / columnTitles.length, // Set fixed width for each column
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
    },
  );
}
