import 'package:flutter/material.dart';
import 'package:tablets/src/common/values/gaps.dart';

class FormFrame extends StatelessWidget {
  const FormFrame(
      {super.key,
      this.backgroundColor,
      // required this.formKey,
      required this.fields,
      required this.buttons,
      this.width = 800,
      this.height = 900});
  final Color? backgroundColor;
  final Widget fields;
  final List<Widget> buttons;
  // final GlobalKey<FormState> formKey;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: width,
        height: height,
        child: Column(
          children: [
            Form(
              // key: formKey,
              child: fields,
            ),
            VerticalGap.xl,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: buttons,
            ),
          ],
        ),
      ),
    );
  }
}
