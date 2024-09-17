import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    String? imageUrl;
    final storageRef = _storage.ref().child(group).child('$name.jpg');
    await storageRef.putFile(file!);
    imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }
}

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(FirebaseStorage.instance);
});
