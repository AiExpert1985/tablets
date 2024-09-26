import 'package:flutter/material.dart';

InputDecoration formFieldBoxInputDecoration(String label) {
  return InputDecoration(
    floatingLabelAlignment: FloatingLabelAlignment.center,
    label: Text(
      label,
      // textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 13,
        color: Color.fromARGB(255, 248, 25, 17),
      ),
    ),
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.all(12),
    isDense: true, // Add this line to remove the default padding
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
}
