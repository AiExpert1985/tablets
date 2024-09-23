import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/features/categories/model/product_category.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

/// the controller works with category forms (through its 'formKey') to update its category object
/// and gets images from a 'pickedImageNotifierProvider' where image file is stored when
/// user pick image (inside form)
class CategoryRepository {
  CategoryRepository(this._firestore, this._imageStorage);
  final FirebaseFirestore _firestore;
  final StorageRepository _imageStorage;

  ///  take the data & image in the 'add form' and using this data to
  /// add an image to firebase storage & a document in the firestore
  /// (the image is from pickedImageNotifierProvider which already picked by user)
  /// then create a new document in categories collection
  /// to store the category name and url of uploaded image
  Future<bool> addCategoryToDB(
      {required ProductCategory category, File? pickedImage}) async {
    try {
      // if an image is picked, we will store it in firebase and use its url
      // otherwise, we will use the default item image url
      if (pickedImage != null) {
        final newUrl = await _imageStorage.addFile(
            folder: 'category', fileName: category.name, file: pickedImage);
        category.imageUrl = newUrl!;
      }

      final docRef = _firestore.collection('categories').doc();

      await docRef.set({
        ProductCategory.dbKeyName: category.name,
        ProductCategory.dbKeyImageUrl: category.imageUrl,
      });
      return true;
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error while adding category to DB',
          stackTrace: StackTrace.current);
      return false;
    }
  }

  /// updates category in the DB where it updates the document in firestore & image in storage
  /// use pickedImageNotifierProvider to update category image in firebase storage
  /// and CategoryController.category to update category document in the firestore
  /// before calling this method, both pickedImageNotifierProvider and CategoryController.category
  /// are updated using 'update form' which was previously called
  /// by CategoryController.showCategoryUpdateForm()
  /// note that this method receives the previous category name to use to when searching db to
  /// get the document that will be updated.
  Future<bool> updateCategoryInDB(
      {required ProductCategory newCategory,
      required ProductCategory oldCategory,
      File? pickedImage}) async {
    try {
      String url = oldCategory.imageUrl;
      // first update the photo
      // if an image is picked, we will store it and use its url
      // otherwise, we will use the default item image url
      if (pickedImage != null) {
        final newUrl = await _imageStorage.updateFile(
            folder: 'category',
            fileName: newCategory.name,
            file: pickedImage,
            fileUrl: newCategory.imageUrl);
        if (newUrl != null) url = newUrl;
      }
      // then update the category document
      final query = _firestore
          .collection('categories')
          .where('name', isEqualTo: oldCategory.name);
      final querySnapshot = await query.get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.update({
          ProductCategory.dbKeyName: newCategory.name,
          ProductCategory.dbKeyImageUrl: url,
        });
      }
      return true;
    } catch (error) {
      utils.CustomDebug.print(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final imageStorage = ref.read(fileStorageProvider);
  final firestore = FirebaseFirestore.instance;
  return CategoryRepository(firestore, imageStorage);
});

/// Streaming categorys from firestore 'categories' collection.
/// categoris are steamed separately (I didn't include it in 'categoryController')
///  because it is easy for me to implement
final categoryStreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
  (ref) async* {
    try {
      final querySnapshot =
          FirebaseFirestore.instance.collection('categories').snapshots();
      yield* querySnapshot;
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error happened while streaming categories from DB',
          stackTrace: StackTrace.current);
    }
  },
);
