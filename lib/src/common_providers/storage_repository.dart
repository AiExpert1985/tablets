import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/utils/utils.dart';

class StorageRepository {
  StorageRepository(this._storage);
  final FirebaseStorage _storage;

  // put a file referenced by the userId
  // returns the url of the file or null
  Future<String?> addFile({
    required String group,
    required String name,
    required File? file,
  }) async {
    try {
      String? imageUrl;
      final storageRef = _storage.ref().child(group).child('$name.jpg');
      await storageRef.putFile(file!);
      imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, String>>> getFilesInFolder(String folderName) async {
    try {
      List<Map<String, String>> categories = [];
      Reference folderRef = _storage.ref().child(folderName);
      ListResult result = await folderRef.listAll();
      for (var file in result.items) {
        String fileName = file.name;
        String filePath = file.fullPath;

        // Download the file
        Reference downloadRef = _storage.ref().child(filePath);
        var downloadedUrl = await downloadRef.getDownloadURL();
        categories.add({'imageUrl': downloadedUrl, 'fileName': fileName});
        CustomDebug.print('Successful firebase storage');
      }
      return categories;
    } catch (e) {
      CustomDebug.print('failed firebase storage');
      return [];
    }
  }
}

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(FirebaseStorage.instance);
});
