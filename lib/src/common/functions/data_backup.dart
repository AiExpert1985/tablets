import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:tablets/src/common/functions/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:archive/archive.dart'; // Import the archive package

// void backupDatabase(List<Map<String, dynamic>> data, String fileName) {
//   final now = formatDate(DateTime.now());
//   fileName = '$fileName $now';
//   // Step 1: Convert the List to a JSON String

//   String jsonString = jsonEncode(data);

//   // Step 2: Create a Blob from the JSON String

//   final blob = Blob([jsonString], 'application/json');

//   // Step 3: Create a URL for the Blob

//   final url = Url.createObjectUrlFromBlob(blob);

//   // Step 4: Create an anchor element and set its attributes

//   AnchorElement(href: url)
//     ..setAttribute('download', fileName)
//     ..click(); // Programmatically click the anchor to trigger the download

//   // Step 5: Clean up the URL after the download

//   Url.revokeObjectUrl(url);
// }

void backupDatabase(List<List<Map<String, dynamic>>> allData, List<String> fileNames) {
  final now = formatDate(DateTime.now());
  final zipFileName = 'قاعدة بيانات برنامج الواح $now.zip'; // Set the file name for the zip

  // Step 1: Create a new archive
  final archive = Archive();

  // Step 2: Loop through each List<Map<String, dynamic>> and add it to the archive
  for (int i = 0; i < allData.length; i++) {
    List<Map<String, dynamic>> data = allData[i];

    // Convert the List to a JSON String
    String jsonString = jsonEncode(data);
    List<int> bytes = utf8.encode(jsonString);

    // Add the JSON data as a file in the archive
    archive.addFile(ArchiveFile('${fileNames[i]}.json', bytes.length, bytes));
  }

  // Step 3: Encode the archive as a zip file
  final zipData = ZipEncoder().encode(archive);

  // Step 4: Create a Blob from the zip data
  final blob = Blob([zipData], 'application/zip');

  // Step 5: Create a URL for the Blob
  final url = Url.createObjectUrlFromBlob(blob);

  // Step 6: Create an anchor element and set its attributes
  AnchorElement(href: url)
    ..setAttribute('download', zipFileName)
    ..click(); // Programmatically click the anchor to trigger the download

  // Step 7: Clean up the URL after the download
  Url.revokeObjectUrl(url);
}
