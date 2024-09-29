// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:http/http.dart' as http;
// import 'package:tablets/src/utils/utils.dart' as utils;

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
  static String url = _defaultImageUrl[3];
  static const List<String> _defaultImageUrl = [
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image.PNG?alt=media&token=39d92c51-a67b-4025-ba08-566faa606d57',
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image.png?alt=media&token=bba72e1b-e06f-4764-8687-ba37cf0af770',
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image_3.png?alt=media&token=b2b7222a-ca76-437a-9003-7d046a908185',
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image4.png?alt=media&token=51fc74af-a74b-41a2-a0d0-d26a0ea675cc',
  ];
}
