import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/settings/initial_categories/controller/old_init_category_db_controller.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class CategoryController {
  CategoryController(this._ref);
  final ProviderRef _ref;
  final formKey = GlobalKey<FormState>();
  List<Map<String, String>> categories = [];

  late String category;

  void addCategory(context) async {
    utils.CustomDebug.print('here inside');
    final isValid =
        formKey.currentState!.validate(); // runs validation inside form
    if (!isValid) return;
    formKey.currentState!.save(); // runs onSave inside form
    bool isSuccessful = await _ref
        .read(categoryRepositoryProvider)
        .addNewCategory(category: category);
    if (isSuccessful) {
      Navigator.of(context).pop();
      utils.UserMessages.success(
        context: context,
        message: S.of(context).success_adding_doc_to_db,
      );
    } else {
      utils.UserMessages.failure(
        context: context,
        message: S.of(context).error_adding_doc_to_db,
      );
    }
  }

  // return all photos in the category folder inside firebase storage as a list of maps
  // {'imageUrl': downloadedUrl, 'fileName': fileName}
  void fetchAllCategories() async {
    categories = await _ref.read(categoryRepositoryProvider).getAllCategories();
  }
}

final categoryControllerProvider = Provider<CategoryController>((ref) {
  return CategoryController(ref);
});
