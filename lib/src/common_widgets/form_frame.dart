import 'package:flutter/material.dart';

class FormFrame extends StatelessWidget {
  const FormFrame(
      {super.key,
      required this.formKey,
      required this.fields,
      required this.buttons,
      required this.width,
      required this.height});
  final Widget fields;
  final List<Widget> buttons;
  final GlobalKey<FormState> formKey;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.all(1),
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      // title: Text(S.of(context).add_new_user),
      content: Container(
        padding: const EdgeInsets.all(10),
        width: width,
        height: height,
        child: Form(
          key: formKey,
          child: fields,
        ),
      ),

      actions: [OverflowBar(alignment: MainAxisAlignment.center, children: buttons)],
    );
  }
}
