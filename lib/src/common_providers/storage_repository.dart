import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_functions/utils.dart' as utils;

class StorageRepository {
  StorageRepository(this._storage);
  final FirebaseStorage _storage;

  Future<String?> uploadImage({required String fileName, required Uint8List file}) async {
    try {
      final storageRef = _storage.ref().child('images').child('$fileName.jpg');
      await storageRef.putData(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      utils.errorDebugPrint(message: e, stackTrace: StackTrace.current);
      return null;
    }
  }

  Future<bool> deleteImage(String url) async {
    try {
      final storageRef = _storage.refFromURL(url);
      await storageRef.delete();
      return true;
    } catch (e) {
      utils.errorDebugPrint(message: e, stackTrace: StackTrace.current);
      return false;
    }
  }
}

final imageStorageProvider = Provider<StorageRepository>((ref) {
  final FirebaseStorage storage = FirebaseStorage.instance;
  return StorageRepository(storage);
});
