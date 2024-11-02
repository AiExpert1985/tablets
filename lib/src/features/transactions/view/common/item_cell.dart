import 'package:flutter/material.dart';

Widget buildDataCell(width, cell, {height = 45, isTitle = false, isFirst = false, isLast = false}) {
  return Container(
      decoration: BoxDecoration(
        border: Border(
            left: !isLast
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
            right: !isFirst
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
            bottom: const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)),
      ),
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cell,
        ],
      ));
}
