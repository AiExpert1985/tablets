import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/features/settings/categories/model/product_category.dart';
import 'package:tablets/src/features/settings/categories/view/update_category_dialog.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';

/// the controller works with category forms (through its 'formKey') to update its category variable
/// and gets images from a 'pickedImageNotifierProvider' where image file is stored when
/// user pick image (inside form)
class CategoryController {
  CategoryController(this._ref);
  final ProviderRef _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  late ProductCategory category;

  // create a new ProductCategory object with default image url
  void createCategory(String name) {
    category = ProductCategory(name: name);
  }

  /// add an image to firebase storage
  /// (the image is from pickedImageNotifierProvider which already picked by user)
  /// then create a new document in categories collection
  /// to store the category name and url of uploaded image
  void addCategoryToFirebase(context) async {
    final isValid =
        formKey.currentState!.validate(); // runs validation inside form
    if (!isValid) return;
    formKey.currentState!.save(); // runs onSave inside form
    try {
      final pickedImage = _ref.read(pickedImageNotifierProvider).pickedImage;
      // if an image is picked, we will store it and use its url
      // otherwise, we will use the default item image url
      if (pickedImage != null) {
        // first we clear the image picker from the picked image
        category.imageUrl = await _ref.read(fileStorageProvider).addFile(
            folder: 'category', fileName: category.name, file: pickedImage);
      }

      final docRef = _firestore.collection('categories').doc();

      await docRef.set({
        'name': category.name,
        'imageUrl': category.imageUrl,
      });
      Navigator.of(context).pop();
      utils.UserMessages.success(
        context: context,
        message: S.of(context).success_adding_doc_to_db,
      );
    } catch (e) {
      utils.UserMessages.failure(
        context: context,
        message: S.of(context).error_adding_doc_to_db,
      );
    } finally {
      // reset the image picker
      _ref.read(pickedImageNotifierProvider.notifier).reset();
    }
  }

  void updateCategoryDocument(context) async {
    utils.CustomDebug.print(
        message: category.name,
        callerName: 'CategoryController.updateCategoryDocument()');
  }

  void prepareCategoryUpdate(context, cat) {
    category = cat;
    utils.CustomDebug.print(
        message: category.name,
        callerName: 'CategoryController.prepareCategoryUpdate()');
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const UpdateCategoryDialog(),
    );
  }
}

final categoryControllerProvider = Provider<CategoryController>((ref) {
  return CategoryController(ref);
});

/// Responsible for streaming categorys from firestore 'categories' collection.
/// categoris are steamed separately (I didn't include it in 'categoryController')
///  because it is easy for me to implement
final categoriesStreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
  (ref) async* {
    try {
      final querySnapshot =
          FirebaseFirestore.instance.collection('categories').snapshots();
      yield* querySnapshot;
    } catch (e) {
      utils.CustomDebug.print(
          message: 'an error happened while streaming categories',
          callerName: 'categoriesStreamProvider');
    }
  },
);
