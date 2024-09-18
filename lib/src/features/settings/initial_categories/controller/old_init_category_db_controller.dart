import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class CategoryRepository {
  CategoryRepository(this._firestore, this._ref);
  final FirebaseFirestore _firestore;
  final ProviderRef _ref;

  /// add item to firebase products document
  /// return true if added successfully, otherwise returns false
  Future<bool> addNewCategory({
    required String category,
  }) async {
    final pickedImage = _ref.read(pickedImageFileProvider);
    if (pickedImage == null) return false;

    final imageUrl = await _ref
        .read(storageRepositoryProvider)
        .addFile(group: 'category', name: category, file: pickedImage);

    final docRef = _firestore.collection('categories').doc();
    try {
      await docRef.set({
        'creationTime': FieldValue.serverTimestamp(),
        'category': category,
        'imageUrl': imageUrl,
      });
      return true;
    } catch (e) {
      utils.CustomDebug.print(e);
      return false;
    }
  }

  // return all photos in the category folder inside firebase storage as a list of maps
  // {'imageUrl': downloadedUrl, 'fileName': fileName}
  Future<List<Map<String, String>>> getAllCategories() async {
    return await _ref
        .read(storageRepositoryProvider)
        .getFilesInFolder('category');
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(FirebaseFirestore.instance, ref);
});
