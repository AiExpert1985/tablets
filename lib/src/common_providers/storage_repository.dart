import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/utils/utils.dart';

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

  /// update and existing file referenced by the url
  /// returns the new url if successed or null if failed
  Future<String?> updateFile({
    required String folder,
    required String fileName,
    required File file,
    required String fileUrl,
  }) async {
    try {
      // delete the old photo unless it is the default photo
      // and then add the new photo and return its url
      if (fileUrl != constants.DefaultImageUrl.defaultImageUrl) {
        print('file will be deleted');
        deleteFile(fileUrl);
      }
      final newUrl =
          await addFile(folder: folder, fileName: fileName, file: file);
      return newUrl;
    } catch (e) {
      return null;
    }
  }

  /// delete photo from storage using its url
  Future<void> deleteFile(String imageUrl) async {
    try {
      CustomDebug.print(
          message: 'image will be deleted',
          callerName: 'StorageRepository.deleteFile()');
      final storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      CustomDebug.print(
          message: 'error happened while deleting file from firebase storage',
          callerName: 'StorageRepository.deleteFile()');
    }
  }
}

final fileStorageProvider = Provider<StorageRepository>((ref) {
  return StorageRepository();
});
