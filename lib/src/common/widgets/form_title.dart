import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  const FormTitle(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 184, 7, 7))),
    );
  }
}
