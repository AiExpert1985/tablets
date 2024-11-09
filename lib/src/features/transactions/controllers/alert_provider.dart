import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final invoiceBackgroundColorProvider = StateProvider<Color>((ref) {
  return Colors.white; // Default color
});
