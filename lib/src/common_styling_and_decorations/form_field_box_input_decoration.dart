import 'package:flutter/material.dart';

InputDecoration formFieldBoxInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
}
