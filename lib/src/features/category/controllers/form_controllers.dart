import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/image_slider_controller.dart';
import 'package:tablets/src/features/category/model/product_category.dart';
import 'package:tablets/src/features/category/repository/category_repository_provider.dart';
// import 'package:tablets/src/features/products/view/dialog_form_add.dart';
// import 'package:tablets/src/features/products/view/dialog_form_edit.dart';
import 'package:tablets/src/common/functions/user_messages.dart' as toastification;
import 'package:tablets/src/features/category/view/dialog_form_add.dart';
import 'package:tablets/src/features/category/view/dialog_form_edit.dart';

class CategoryFormFieldsController {
  CategoryFormFieldsController(
    this._repository,
    this._formData,
    this._imageSlider,
  );
  final CategoryRepository _repository;
  final CategoryUserFormData _formData;

  final ImageSliderNotifier _imageSlider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateForm() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return false;
    formKey.currentState!.save();
    return true;
  }

  void closeForm(BuildContext context) {
    Navigator.of(context).pop();
  }

  void addCategory(context) async {
    if (!validateForm()) return;
    final updatedUrls = _imageSlider.savedUpdatedImages();
    _formData.update(key: 'imageUrls', value: updatedUrls);
    final updatedData = _formData.getState();
    final category = ProductCategory.fromMap({...updatedData, 'imageUrls': updatedUrls});
    final successful = await _repository.addCategoryToDB(category: category);
    if (successful) {
      toastification.success(
        context: context,
        message: S.of(context).db_success_adding_doc,
      );
    } else {
      toastification.failure(
        context: context,
        message: S.of(context).db_error_adding_doc,
      );
    }
    if (context.mounted) closeForm(context);
  }

  void showAddForm(BuildContext context) {
    _imageSlider.initialize();
    showDialog(
      context: context,
      builder: (BuildContext context) => const AddCategoryForm(),
    ).whenComplete(_onFormClosing);
  }

  /// when form is closed, we delete (from firestore) all uploaded images that aren't used
  /// this is needed because app stores images (to firestore) directly when uploaded and
  /// it happends that user sometimes uploads images then cancel the form
  void _onFormClosing() {
    _imageSlider.close();
    _formData.reset();
  }

  void showEditForm({required BuildContext context, required ProductCategory category}) {
    _imageSlider.initialize(urls: category.imageUrls);
    _formData.initialize(category);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const EditCategoryForm(),
    ).whenComplete(_onFormClosing);
  }

  void deleteCategory(BuildContext context, ProductCategory category) async {
    // add all urls to the tempurls list, they will be automatically deleted once form is closed
    bool successful = await _repository.deleteCategoryFromDB(category: category);
    if (successful) {
      if (context.mounted) {
        toastification.success(context: context, message: S.of(context).db_success_deleting_doc);
      }
    } else {
      if (context.mounted) {
        toastification.failure(context: context, message: S.of(context).db_error_deleting_doc);
      }
    }
    if (context.mounted) closeForm(context);
  }

  void updateCategory(BuildContext context, ProductCategory oldCategory) async {
    if (!validateForm()) return;
    final updatedUrls = _imageSlider.savedUpdatedImages();
    _formData.update(key: 'imageUrls', value: updatedUrls);
    final updatedData = _formData.getState();
    final category = ProductCategory.fromMap({...updatedData, 'imageUrls': updatedUrls});
    final successful = await _repository.updateCategoryInDB(newCategory: category, oldCategory: oldCategory);
    if (successful) {
      if (context.mounted) {
        toastification.success(context: context, message: S.of(context).db_success_updaging_doc);
      }
    } else {
      if (context.mounted) {
        toastification.failure(context: context, message: S.of(context).db_error_updating_doc);
      }
    }
    if (context.mounted) closeForm(context);
  }
}

final categoryFormControllerProvider = Provider<CategoryFormFieldsController>((ref) {
  final repository = ref.read(categoriesRepositoryProvider);
  final formData = ref.watch(categoryFormDataProvider.notifier);
  final imageSliderController = ref.watch(imageSliderNotifierProvider.notifier);
  return CategoryFormFieldsController(repository, formData, imageSliderController);
});

class CategoryUserFormData extends StateNotifier<Map<String, dynamic>> {
  CategoryUserFormData(super.state);

  void initialize(ProductCategory category) {
    state = {
      'name': category.name,
      'imageUrls': category.imageUrls,
    };
  }

  void update({required String key, required dynamic value}) {
    Map<String, dynamic> tempMap = {...state};
    tempMap[key] = value;
    state = {...tempMap};
  }

  void reset() => state = {};

  Map<String, dynamic> getState() => state;
}

final categoryFormDataProvider =
    StateNotifierProvider<CategoryUserFormData, Map<String, dynamic>>((ref) => CategoryUserFormData({}));
