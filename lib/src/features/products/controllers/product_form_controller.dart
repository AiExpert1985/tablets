import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/features/products/controllers/product_form_data_provider.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/common/functions/user_messages.dart' as toast;
import 'package:tablets/src/features/products/view/product_form.dart';

class ProductFormFieldsController {
  ProductFormFieldsController(
    this._repository,
    this._formData,
    this._imageSlider,
  );
  final ProductRepository _repository;
  final UserFormData _formData;
  final ImageSliderNotifier _imageSlider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void showForm(BuildContext context, {Product? product}) {
    _imageSlider.initialize(urls: product?.imageUrls);
    _formData.initialize(product: product);
    final isEditMode = product != null;
    showDialog(
      context: context,
      builder: (BuildContext ctx) => ProductForm(isEditMode),
    ).whenComplete(() => _resetProviders()); // when form is closed, this will be executed
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
    final product = Product.fromMap({...updatedFormData, 'imageUrls': updatedUrls});
    final success = isEditMode
        ? await _repository.updateProductInDB(product)
        : await _repository.addProductToDB(product);
    if (!context.mounted) return; // just for protection in async functions
    success
        ? toast.success(context: context, message: S.of(context).db_success_saving_doc)
        : toast.failure(context: context, message: S.of(context).db_error_saving_doc);
    _closeForm(context);
  }

  void deleteCategory(BuildContext context) async {
    final updatedUrls = _imageSlider.savedUpdatedImages();
    final updatedFormData = _formData.getState();
    final product = Product.fromMap({...updatedFormData, 'imageUrls': updatedUrls});
    final successful = await _repository.deleteProductFromDB(product);
    if (!context.mounted) return;
    successful
        ? toast.success(context: context, message: S.of(context).db_success_deleting_doc)
        : toast.failure(context: context, message: S.of(context).db_error_deleting_doc);
    _closeForm(context);
  }

  void _closeForm(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _resetProviders() {
    _imageSlider.close();
    _formData.reset();
  }
}

final productFormControllerProvider = Provider<ProductFormFieldsController>((ref) {
  final repository = ref.read(productRepositoryProvider);
  final formData = ref.watch(productFormDataProvider.notifier);
  final imageSliderController = ref.watch(imagePickerProvider.notifier);
  return ProductFormFieldsController(repository, formData, imageSliderController);
});
