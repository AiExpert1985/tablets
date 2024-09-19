import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageRepository {
  StorageRepository();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // put a file referenced by the userId
  // returns the url of the file or null
  Future<String?> addFile({
    required String folder,
    required String fileName,
    required File? file,
  }) async {
    try {
      String? imageUrl;
      final storageRef = _storage.ref().child(folder).child('$fileName.jpg');
      await storageRef.putFile(file!);
      imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }
}

final fileStorageProvider = Provider<StorageRepository>((ref) {
  return StorageRepository();
});
