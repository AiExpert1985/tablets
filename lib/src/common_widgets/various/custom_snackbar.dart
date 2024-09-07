import 'package:flutter/material.dart';

enum MessageType { failure, success, info, warning }

Map<String, Color?> colorMapping = {
  MessageType.failure.name: Colors.red,
  MessageType.success.name: Colors.green,
  MessageType.info.name: Colors.orange,
  MessageType.warning.name: Colors.blue,
};

class NewCustomSnackBar {
  static show(
      {required BuildContext context,
      required String message,
      required MessageType type}) {
    Color messageColor = colorMapping[type.name]!;

    SnackBar snackBar = SnackBar(
      content: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: messageColor.withAlpha(90), width: 2),
            color: messageColor.withAlpha(20)),
        child: Center(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: messageColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.error, color: Colors.white),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // const Text('Warning',
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 14)),
                    Text(message,
                        style: TextStyle(
                            color: Colors.black.withOpacity(.5), fontSize: 12))
                  ],
                ),
              )),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.close, color: Colors.black.withOpacity(.8)),
                ),
              ),
            ],
          ),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 16),
      duration: const Duration(seconds: 3),
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context)
        .clearSnackBars(); // first remove previous snackbars
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
