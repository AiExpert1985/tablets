import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

void backupDatabase(List<Map<String, dynamic>> data, String filename) {
  // Step 1: Convert the List to a JSON String

  String jsonString = jsonEncode(data);

  // Step 2: Create a Blob from the JSON String

  final blob = Blob([jsonString], 'application/json');

  // Step 3: Create a URL for the Blob

  final url = Url.createObjectUrlFromBlob(blob);

  // Step 4: Create an anchor element and set its attributes

  AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click(); // Programmatically click the anchor to trigger the download

  // Step 5: Clean up the URL after the download

  Url.revokeObjectUrl(url);
}
