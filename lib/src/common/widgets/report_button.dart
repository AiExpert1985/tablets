import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  const ReportButton(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey, // Light border color
          width: 0.2, // Border width
        ),

        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
