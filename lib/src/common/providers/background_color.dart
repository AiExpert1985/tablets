import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final normalColor = Colors.grey[100];
const warningColor = Colors.red;

final backgroundColorProvider = StateProvider<Color>((ref) {
  return normalColor!; // Default color
});
