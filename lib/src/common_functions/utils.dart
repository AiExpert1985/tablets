import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_functions/debug_print.dart' as debug;
import 'package:image/image.dart' as img;

String generateRandomString({int len = 5}) {
  var r = Random();
  return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89)).toString();
}

/// compare two Lists of string
/// find items in the first list that don't exists in second list
List<String> twoListsDifferences(List<String> list1, List<String> list2) =>
    list1.where((item) => !list2.toSet().contains(item)).toList();

// Default result image size is 50 k byte (reduce speed and the cost of firebase)
// compression depends on image size, the larget image the more compression
// if image size is small, it will not be compressed
Uint8List? compressImage(Uint8List? image, {int targetImageSizeInBytes = 51200}) {
  final quality = (image!.length / targetImageSizeInBytes).round();
  if (quality > 0) {
    image = img.encodeJpg(img.decodeImage(image)!, quality: quality);
  }
  return image;
}

InputDecoration formFieldDecoration({String? label}) {
  return InputDecoration(
    // floatingLabelAlignment: FloatingLabelAlignment.center,
    label: label == null
        ? null
        : Text(
            label,
            // textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black38,
            ),
          ),
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.all(12),
    isDense: true, // Add this line to remove the default padding
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
}

List<Map<String, dynamic>> convertAsyncValueListToList(
    AsyncValue<List<Map<String, dynamic>>> asyncProductList) {
  return asyncProductList.when(
      data: (products) => products,
      error: (e, st) {
        debug.errorPrint(message: e, stackTrace: st);
        return [];
      },
      loading: () {
        debug.errorPrint(message: 'product list is loading');
        return [];
      });
}
