import 'package:flutter/material.dart';

class FormDialog extends StatelessWidget {
  const FormDialog(
      {super.key,
      required this.formKey,
      required this.fieldsWidget,
      required this.buttonsList,
      required this.widthRatio,
      required this.heightRatio});
  final Widget fieldsWidget;
  final List<Widget> buttonsList;
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
            child: fieldsWidget,
          ),
        ),
      ),

      actions: [
        OverflowBar(alignment: MainAxisAlignment.center, children: buttonsList)
      ],
    );
  }
}
