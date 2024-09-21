import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageRepository {
  StorageRepository();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // put a new file in the database, and returns the url if successful
  // or null if failed
  Future<String?> addFile({
    required String folder,
    required String fileName,
    required File file,
  }) async {
    try {
      String? imageUrl;
      final storageRef = _storage.ref().child(folder).child('$fileName.jpg');
      await storageRef.putFile(file);
      imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  // update and existing file referenced by the url
  // returns bool for sucess or failure
  Future<bool> updateFile({
    required File file,
    required String fileUrl,
  }) async {
    try {
      final storageRef = _storage.refFromURL(fileUrl);

      await storageRef.putFile(file);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final fileStorageProvider = Provider<StorageRepository>((ref) {
  return StorageRepository();
});
