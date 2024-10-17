import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/image_slider_controller.dart';
import 'package:tablets/src/features/categories/controllers/category_form_fields_data_provider.dart';
import 'package:tablets/src/features/categories/model/category.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/common/functions/user_messages.dart' as toastification;
import 'package:tablets/src/features/categories/view/category_form.dart';

class CategoryFormController {
  CategoryFormController(
    this._repository,
    this._formData,
    this._imageSlider,
  );
  final CategoryRepository _repository;
  final CategoryFormFieldsData _formData;
  final ImageSliderNotifier _imageSlider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void showForm(BuildContext context, {ProductCategory? category}) {
    _imageSlider.initialize(urls: category?.imageUrls);
    _formData.initialize(category: category);
    final isEditMode = category != null;
    showDialog(
      context: context,
      builder: (BuildContext ctx) => CategoryForm(isEditMode),
    ).whenComplete(() {
      _imageSlider.close();
      _formData.reset();
    });
  }

  bool validateForm() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return false;
    formKey.currentState!.save();
    return true;
  }

  void saveCategory(BuildContext context, bool isEditMode) async {
    if (!validateForm()) return;
    final updatedUrls = _imageSlider.savedUpdatedImages();
    final updatedFormData = _formData.getState();
    final category = ProductCategory.fromMap({...updatedFormData, 'imageUrls': updatedUrls});
    final success = isEditMode
        ? await _repository.updateCategoryInDB(category)
        : await _repository.addCategoryToDB(category);
    if (!context.mounted) return; // just for protection
    success
        ? toastification.success(context: context, message: S.of(context).db_success_saving_doc)
        : toastification.failure(context: context, message: S.of(context).db_error_saving_doc);
    closeForm(context);
  }

  void deleteCategory(BuildContext context) async {
    final updatedUrls = _imageSlider.savedUpdatedImages();
    final updatedFormData = _formData.getState();
    final category = ProductCategory.fromMap({...updatedFormData, 'imageUrls': updatedUrls});
    final successful = await _repository.deleteCategoryFromDB(category);
    if (!context.mounted) return;
    successful
        ? toastification.success(context: context, message: S.of(context).db_success_deleting_doc)
        : toastification.failure(context: context, message: S.of(context).db_error_deleting_doc);
    closeForm(context);
  }

  void closeForm(BuildContext context) {
    Navigator.of(context).pop();
  }
}

final categoryFormControllerProvider = Provider<CategoryFormController>((ref) {
  final repository = ref.read(categoriesRepositoryProvider);
  final formData = ref.watch(categoryFormFieldsDataProvider.notifier);
  final imageSliderController = ref.watch(imageSliderNotifierProvider.notifier);
  return CategoryFormController(repository, formData, imageSliderController);
});
