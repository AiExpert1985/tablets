// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/features/categories/controller/current_category_provider.dart';
import 'package:tablets/src/features/categories/model/product_category.dart';
import 'package:tablets/src/features/categories/view/create_category_dialog.dart';
import 'package:tablets/src/features/categories/view/update_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

/// the controller works with category forms (through its 'formKey') to update its category object
/// and gets images from a 'pickedImageNotifierProvider' where image file is stored when
/// user pick image (inside form)
class CategoryController {
  final GlobalKey<FormState> formKey;
  final ProviderRef ref;
  CategoryController({
    required this.formKey,
    required this.ref,
  });

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
    ref.read(pickedImageNotifierProvider.notifier).reset();
    ref.read(currentCategoryProvider).setDefaultValues();
  }

  ///  take the data & image in the 'add form' and using this data to
  /// add an image to firebase storage & a document in the firestore
  /// (the image is from pickedImageNotifierProvider which already picked by user)
  /// then create a new document in categories collection
  /// to store the category name and url of uploaded image
  void addCategoryToDB(BuildContext context) async {
    if (!saveForm()) return;
    final pickedImage = ref.read(pickedImageNotifierProvider);
    final categoryRespository = ref.read(categoryRepositoryProvider);
    final currentCategory = ref.read(currentCategoryProvider);

    final successful = await categoryRespository.addCategoryToDB(
        category: currentCategory, pickedImage: pickedImage);
    if (successful) {
      utils.UserMessages.success(
        context: context,
        message: S.of(context).db_success_adding_doc,
      );
    } else {
      utils.UserMessages.failure(
        context: context,
        message: S.of(context).db_error_adding_doc,
      );
    }
    cancelForm(context);
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
      BuildContext context, ProductCategory oldCategory) async {
    if (!saveForm()) return;
    final pickedImage = ref.read(pickedImageNotifierProvider);
    final categoryRespository = ref.read(categoryRepositoryProvider);
    final currentCategory = ref.read(currentCategoryProvider);
    bool successful = await categoryRespository.updateCategoryInDB(
        newCategory: currentCategory,
        oldCategory: oldCategory,
        pickedImage: pickedImage);
    if (successful) {
      utils.UserMessages.success(
          context: context, message: S.of(context).db_success_updaging_doc);
    } else {
      utils.UserMessages.failure(
          context: context, message: S.of(context).db_error_updating_doc);
    }
    cancelForm(context);
  }

  /// showing the pre-filled update form, using the passed ProductCategory object
  /// the category passed to it comes from the selected category widget (in the grid)
  /// it uses category.iamgeUrl to get an image from firebase storage
  /// and uses category.name to show the category name
  void showCategoryUpdateForm(BuildContext context, ProductCategory cat) {
    final currentCategory = ref.read(currentCategoryProvider);
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
  final formKey = GlobalKey<FormState>();
  return CategoryController(formKey: formKey, ref: ref);
});
