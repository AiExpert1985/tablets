import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class CategoryRepository {
  CategoryRepository(this._ref);
  final ProviderRef _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// add item to firebase products document
  /// return true if added successfully, otherwise returns false
  Future<bool> createCategory({
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
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref);
});

final firestoreStreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
  (ref) async* {
    final querySnapshot =
        FirebaseFirestore.instance.collection('categories').snapshots();
    yield* querySnapshot;
  },
);
