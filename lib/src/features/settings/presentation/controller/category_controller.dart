import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/settings/data/category_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class CategoryController {
  CategoryController(this.categoryRepository);
  final CategoryRepository categoryRepository;
  final formKey = GlobalKey<FormState>();

  late String category;

  void addCategory(context) async {
    utils.CustomDebug.print('here inside');
    final isValid =
        formKey.currentState!.validate(); // runs validation inside form
    if (!isValid) return;
    formKey.currentState!.save(); // runs onSave inside form
    bool isSuccessful =
        await categoryRepository.addCategory(category: category);
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
}

final categoryControllerProvider = Provider<CategoryController>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return CategoryController(categoryRepository);
});
