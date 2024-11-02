import 'package:flutter/material.dart';

class HorizontalGap {
  static const s = SizedBox(width: 5);
  static const m = SizedBox(width: 15);
  static const l = SizedBox(width: 30);
  static const xl = SizedBox(width: 45);
  static const formFieldToField = SizedBox(width: 25);
}

class VerticalGap {
  static const s = SizedBox(height: 5);
  static const m = SizedBox(height: 15);
  static const l = SizedBox(height: 30);
  static const xl = SizedBox(height: 45);
  static const xxl = SizedBox(height: 60);
}

/// this must be used inside Column (or Row)
class PushWidgets {
  static Widget toEnd = Expanded(
    child: Container(), // Empty container to push the last button to the bottom
  );
}
