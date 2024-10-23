import 'package:flutter/material.dart';

class HorizontalGap {
  static const formFieldToField = SizedBox(width: 25);
}

class VerticalGap {
  static const formImageToFields = SizedBox(height: 25);
  static const formImageToButtons = SizedBox(height: 15);
  static const formFieldToField = SizedBox(height: 15);
  static const mainDrawerIconToIcon = SizedBox(height: 5);
  static const iconToText = SizedBox(height: 6);
  static const sideDrawerfieldsToButtons = SizedBox(height: 30);
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
