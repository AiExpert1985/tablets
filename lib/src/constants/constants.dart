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

String defaultImageUrl =
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image.PNG?alt=media&token=d142f689-e42f-46ca-bb4b-8ea68a714ba4';
