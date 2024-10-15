import 'package:flutter/material.dart';

class HorizontalGap {
  static const formFieldToField = SizedBox(width: 40);
}

class VerticalGap {
  static const formImageToFields = SizedBox(height: 20);
  static const formImageToButtons = SizedBox(height: 10);
  static const formFieldToField = SizedBox(height: 15);
  static const mainDrawerIconToIcon = SizedBox(height: 5);
  static const iconToText = SizedBox(height: 6);
}

class DrawerGap {
  // static const vertical = SizedBox(height: 5);
}

/// this must be used inside Column (or Row)
class PushWidgets {
  static Widget toEnd = Expanded(
    child: Container(), // Empty container to push the last button to the bottom
  );
}
