import 'package:flutter/material.dart';

class FormFrame extends StatelessWidget {
  const FormFrame(
      {super.key,
      required this.formKey,
      required this.fields,
      required this.buttons,
      required this.widthRatio,
      required this.heightRatio});
  final List<Widget> fields;
  final List<Widget> buttons;
  final GlobalKey<FormState> formKey;
  final double widthRatio;
  final double heightRatio;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      // title: Text(S.of(context).add_new_user),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * widthRatio,
          height: MediaQuery.of(context).size.height * heightRatio,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: fields,
            ),
          ),
        ),
      ),

      actions: [
        OverflowBar(alignment: MainAxisAlignment.center, children: buttons)
      ],
    );
  }
}
