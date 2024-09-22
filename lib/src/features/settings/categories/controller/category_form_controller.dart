// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/features/settings/categories/controller/current_category_provider.dart';
import 'package:tablets/src/features/settings/categories/model/product_category.dart';
import 'package:tablets/src/features/settings/categories/view/create_category_dialog.dart';
import 'package:tablets/src/features/settings/categories/view/update_category_dialog.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';

/// the controller works with category forms (through its 'formKey') to update its category object
/// and gets images from a 'pickedImageNotifierProvider' where image file is stored when
/// user pick image (inside form)
class CategoryController {
  CategoryController(this._ref);
  final ProviderRef _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  bool saveForm() {
    // runs validation inside form
    final isValid = formKey.currentState!.validate();
    if (!isValid) return false;
    // runs onSave inside form
    formKey.currentState!.save();
    return true;
  }

  void cancelForm(BuildContext context) {
    // close the form
    Navigator.of(context).pop();
    // reset the image picker
    _ref.read(pickedImageNotifierProvider.notifier).reset();
    _ref.read(currentCategoryProvider).setDefaultValues();
  }

  ///  take the data & image in the 'add form' and using this data to
  /// add an image to firebase storage & a document in the firestore
  /// (the image is from pickedImageNotifierProvider which already picked by user)
  /// then create a new document in categories collection
  /// to store the category name and url of uploaded image
  void addCategoryToDB(BuildContext context) async {
    bool isSuccessful = saveForm();
    if (!isSuccessful) return;
    try {
      final currentCategory = _ref.read(currentCategoryProvider);
      final pickedImage = _ref.read(pickedImageNotifierProvider).pickedImage;

      // if an image is picked, we will store it in firebase and use its url
      // otherwise, we will use the default item image url
      if (pickedImage != null) {
        final newUrl = await _ref.read(fileStorageProvider).addFile(
            folder: 'category',
            fileName: currentCategory.name,
            file: pickedImage);
        currentCategory.imageUrl = newUrl!;
      }

      final docRef = _firestore.collection('categories').doc();

      await docRef.set({
        ProductCategory.dbKeyName: currentCategory.name,
        ProductCategory.dbKeyImageUrl: currentCategory.imageUrl,
      });
      utils.UserMessages.success(
        context: context,
        message: S.of(context).db_success_adding_doc,
      );
    } catch (e) {
      utils.UserMessages.failure(
        context: context,
        message: S.of(context).db_error_adding_doc,
      );
    } finally {
      cancelForm(context);
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
  void updateCategoryInDB(
      BuildContext context, String previousCategoryName) async {
    if (!saveForm()) return;
    try {
      final currentCategory = _ref.read(currentCategoryProvider);
      // first update the photo
      final pickedImage = _ref.read(pickedImageNotifierProvider).pickedImage;
      // if an image is picked, we will store it and use its url
      // otherwise, we will use the default item image url
      if (pickedImage != null) {
        final newUrl = await _ref.read(fileStorageProvider).updateFile(
            folder: 'category',
            fileName: currentCategory.name,
            file: pickedImage,
            fileUrl: currentCategory.imageUrl);
        //we must update the category imageUrl based on the new url
        currentCategory.imageUrl = newUrl!;
      }
      // then update the category document
      final query = _firestore
          .collection('categories')
          .where('name', isEqualTo: previousCategoryName);
      final querySnapshot = await query.get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.update({
          ProductCategory.dbKeyName: currentCategory.name,
          ProductCategory.dbKeyImageUrl: currentCategory.imageUrl,
        });
        utils.UserMessages.success(
            context: context, message: S.of(context).db_success_updaging_doc);
      } else {
        utils.UserMessages.info(
            context: context, message: S.of(context).search_not_found_in_db);
      }
    } catch (error) {
      utils.UserMessages.failure(
          context: context, message: S.of(context).db_error_updating_doc);
    } finally {
      cancelForm(context);
    }
  }

  /// showing the pre-filled update form, using the passed ProductCategory object
  /// the category passed to it comes from the selected category widget (in the grid)
  /// it uses category.iamgeUrl to get an image from firebase storage
  /// and uses category.name to show the category name
  void showCategoryUpdateForm(BuildContext context, ProductCategory cat) {
    final currentCategory = _ref.read(currentCategoryProvider);
    currentCategory.imageUrl = cat.imageUrl;
    currentCategory.name = cat.name;
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const UpdateCategoryDialog(),
    );
  }

  /// show the form for creating new category
  /// image displayed in the picker is the default image
  void showCategoryCreateForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const CreateCategoryDialog(),
    );
  }
}

final categoryControllerProvider = Provider<CategoryController>((ref) {
  return CategoryController(ref);
});
