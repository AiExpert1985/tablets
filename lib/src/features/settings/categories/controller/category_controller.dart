import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/features/settings/categories/model/product_category.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';

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

  // add an image to firebase storage
  // and create a new document in categories collection
  // store the category name and image url
  void addCategoryDocument(context) async {
    final isValid = formKey.currentState!.validate(); // runs validation inside form
    if (!isValid) return;
    formKey.currentState!.save(); // runs onSave inside form
    try {
      final pickedImage = _ref.read(pickedImageFileProvider);
      // if an image is picked, we will store it and use its url
      // otherwise, we will use the default item image url
      if (pickedImage != null) {
        // first we clear the image picker from the picked image
        _ref.read(pickedImageFileProvider.notifier).update((state) => null);
        category.imageUrl = await _ref
            .read(fileStorageProvider)
            .addFile(folder: 'category', fileName: category.name, file: pickedImage);
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
    }
  }
}

final categoryControllerProvider = Provider<CategoryController>((ref) {
  return CategoryController(ref);
});

final categoriesStreamProvider = StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
  (ref) async* {
    final querySnapshot = FirebaseFirestore.instance.collection('categories').snapshots();
    yield* querySnapshot;
  },
);
