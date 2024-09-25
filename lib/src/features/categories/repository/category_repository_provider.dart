import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/features/categories/model/product_category.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

/// the controller works with category forms (through its 'formKey') to update its category object
/// and gets images from a 'pickedImageNotifierProvider' where image file is stored when
/// user pick image (inside form)
class CategoriesRepository {
  CategoriesRepository(this._firestore, this._imageStorage);
  final FirebaseFirestore _firestore;
  final StorageRepository _imageStorage;

  static String collectionName = 'categories';
  static String nameKey = 'name';
  static String imageUrlKey = 'imageUrl';

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
        nameKey: category.name,
        imageUrlKey: category.imageUrl,
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
          .where(nameKey, isEqualTo: oldCategory.name);
      final querySnapshot = await query.get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.update({
          nameKey: newCategory.name,
          imageUrlKey: url,
        });
      }
      return true;
    } catch (error) {
      utils.CustomDebug.print(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  /// delete the document from firestore
  /// delete image from storage
  Future<bool> deleteCategoryInDB(
      {required ProductCategory category, bool deleteImage = true}) async {
    try {
      // delete document using its name
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where(nameKey, isEqualTo: category.name)
          .get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.delete();
      }
      // sometime we don't want to delete image (if it is the default image)
      if (deleteImage) {
        _imageStorage.deleteFile(category.imageUrl);
      }
      return true;
    } catch (error) {
      utils.CustomDebug.print(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  Stream<List<ProductCategory>> watchCategoriesList() {
    final ref = _categoriesRef();
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Query<ProductCategory> _categoriesRef() {
    return _firestore
        .collection(collectionName)
        .withConverter(
          fromFirestore: (doc, _) => ProductCategory.fromMap(doc.data()!),
          toFirestore: (ProductCategory product, options) => product.toMap(),
        )
        .orderBy(nameKey);
  }
}

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  final imageStorage = ref.read(fileStorageProvider);
  final firestore = FirebaseFirestore.instance;
  return CategoriesRepository(firestore, imageStorage);
});

final categoriesStreamProvider =
    StreamProvider.autoDispose<List<ProductCategory>>((ref) {
  final categoriesRepository = ref.watch(categoriesRepositoryProvider);
  return categoriesRepository.watchCategoriesList();
});
