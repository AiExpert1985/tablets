// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:http/http.dart' as http;
// import 'package:tablets/src/utils/utils.dart' as utils;

class FormGap {
  static const vertical = SizedBox(height: 25);
  static const horizontal = SizedBox(width: 40);
}

class DrawerGap {
  static const vertical = SizedBox(height: 10);
}

/// this must be used inside Column (or Row)
class PushWidgets {
  static Widget toEnd = Expanded(
    child: Container(), // Empty container to push the last button to the bottom
  );
}

class DefaultImage {
  // static File? imageFile;
  static const imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image.PNG?alt=media&token=058a0797-af23-48e1-977b-a43fbd2d495a';
}
