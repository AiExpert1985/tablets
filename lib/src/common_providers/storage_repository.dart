import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/utils/utils.dart';

class StorageRepository {
  StorageRepository(this._storage);
  final FirebaseStorage _storage;

  Future<String?> uploadImage({required String fileName, required File file}) async {
    try {
      final storageRef = _storage.ref().child('images').child('$fileName.jpg');
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteImage(String url) async {
    try {
      final storageRef = _storage.refFromURL(url);
      await storageRef.delete();
      return true;
    } catch (e) {
      CustomDebug.print(message: e, stackTrace: StackTrace.current);
      return false;
    }
  }
}

/// responsible only for adding & removing images from/to firebase storage
final imageStorageProvider = Provider<StorageRepository>((ref) {
  final FirebaseStorage storage = FirebaseStorage.instance;
  return StorageRepository(storage);
});
