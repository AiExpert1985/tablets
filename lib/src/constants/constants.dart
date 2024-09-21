import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:http/http.dart' as http;
import 'package:tablets/src/utils/utils.dart' as utils;

class FormFieldsSpacing {
  static const vertical = SizedBox(height: 25);
  static const horizontal = SizedBox(width: 40);
}

class DefaultImage {
  static File? imageFile;
  static const imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image.PNG?alt=media&token=1f3c874e-d3c2-4fea-aaba-ff219d13d61e';

  static Future<void> initializDefaultImageFile() async {
    try {
      utils.CustomDebug.print('hi form _useDefaultImageFile');
      final tempDir = await path_provider.getTemporaryDirectory();
      final filePath = '${tempDir.path}/default_image.tmp';

      final file = File(filePath);
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;

      await file.writeAsBytes(bytes);

      imageFile = file;
    } catch (e) {
      utils.CustomDebug.print('Error downloading file: $e',
          callerName: 'UserPickedImage.defaultImageFile()');
    }
  }
}
