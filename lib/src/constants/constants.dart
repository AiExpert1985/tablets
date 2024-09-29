import 'package:flutter/material.dart';

class FormGap {
  static const vertical = SizedBox(height: 15);
  static const horizontal = SizedBox(width: 40);
}

class ImageToFormFieldsGap {
  static const vertical = SizedBox(height: 40);
}

/// the gap between the icon and the text below (or next to) it
class IconToTextGap {
  static const vertical = SizedBox(height: 6);
  static const horizontal = SizedBox(width: 6);
}

class DrawerGap {
  static const vertical = SizedBox(height: 5);
}

/// this must be used inside Column (or Row)
class PushWidgets {
  static Widget toEnd = Expanded(
    child: Container(), // Empty container to push the last button to the bottom
  );
}

class DefaultImage {
  static String url = _defaultImageUrl[5];
  static const List<String> _defaultImageUrl = [
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2FUntitled-removebg-preview.png?alt=media&token=958caeb7-e0cb-4956-b3aa-b0407622b82a',
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image.png?alt=media&token=bba72e1b-e06f-4764-8687-ba37cf0af770',
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image_3.png?alt=media&token=b2b7222a-ca76-437a-9003-7d046a908185',
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image4.png?alt=media&token=51fc74af-a74b-41a2-a0d0-d26a0ea675cc',
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image.PNG?alt=media&token=d142f689-e42f-46ca-bb4b-8ea68a714ba4',
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdsfdsfgdfg.jpeg?alt=media&token=56e00f94-404e-4e6b-9438-b97b500af562',
  ];
}
