import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_providers/image_slider_controller.dart';
import 'package:tablets/src/features/products/controllers/filter_controller_provider.dart';
import 'package:tablets/src/features/products/controllers/form_data_provider.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/adding_form_dialog.dart';
import 'package:tablets/src/features/products/view/editing_form_dialog.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductFormFieldsController {
  ProductFormFieldsController(
    this._repository,
    this._formData,
    this._filterData,
    this._imageSlider,
  );
  final ProductRepository _repository;
  final UserFormData _formData;
  final ProductSearchNotifier _filterData;
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

  void addProduct(context) async {
    if (!validateForm()) return;
    final updatedUrls = _imageSlider.savedUpdatedImages();
    _formData.update(key: 'imageUrls', value: updatedUrls);
    final updatedData = _formData.getState();
    utils.CustomDebug.tempPrint(updatedData);
    final product = Product.fromMap({...updatedData, 'imageUrls': updatedUrls});
    final successful = await _repository.addProductToDB(product: product);
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
    if (context.mounted) closeForm(context);
    // in case user applied a filter and added a new product, below code updates the UI
    if (_filterData.getState.isSearchOn) _filterData.applyFilters();
  }

  void showAddForm(BuildContext context) {
    _imageSlider.initialize();
    showDialog(
      context: context,
      builder: (BuildContext context) => const AddProductForm(),
    ).whenComplete(_onFormClosing);
  }

  /// when form is closed, we delete (from firestore) all uploaded images that aren't used
  /// this is needed because app stores images (to firestore) directly when uploaded and
  /// it happends that user sometimes uploads images then cancel the form
  void _onFormClosing() {
    _imageSlider.close();
    _formData.reset();
  }

  void showEditForm({required BuildContext context, required Product product}) {
    _imageSlider.initialize(urls: product.imageUrls);
    _formData.initialize(product);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const EditProductForm(),
    ).whenComplete(_onFormClosing);
  }

  void deleteProduct(BuildContext context, Product product) async {
    // add all urls to the tempurls list, they will be automatically deleted once form is closed
    bool successful = await _repository.deleteProductFromDB(product: product);
    if (successful) {
      if (context.mounted) {
        utils.UserMessages.success(
            context: context, message: S.of(context).db_success_deleting_doc);
      }
    } else {
      if (context.mounted) {
        utils.UserMessages.failure(context: context, message: S.of(context).db_error_deleting_doc);
      }
    }
    if (context.mounted) closeForm(context);
    // update the UI in case user edited the filtered items
    if (_filterData.getState.isSearchOn) _filterData.applyFilters();
  }

  void updateProduct(BuildContext context, Product oldProduct) async {
    if (!validateForm()) return;
    final updatedUrls = _imageSlider.savedUpdatedImages();
    _formData.update(key: 'imageUrls', value: updatedUrls);
    final updatedData = _formData.getState();
    final product = Product.fromMap({...updatedData, 'imageUrls': updatedUrls});
    final successful =
        await _repository.updateProductInDB(newProduct: product, oldProduct: oldProduct);
    if (successful) {
      if (context.mounted) {
        utils.UserMessages.success(
            context: context, message: S.of(context).db_success_updaging_doc);
      }
    } else {
      if (context.mounted) {
        utils.UserMessages.failure(context: context, message: S.of(context).db_error_updating_doc);
      }
    }
    if (context.mounted) closeForm(context);
    // update the UI in case user edited the filtered items
    if (_filterData.getState.isSearchOn) _filterData.applyFilters();
  }
}

final productFormControllerProvider = Provider<ProductFormFieldsController>((ref) {
  final repository = ref.read(productsRepositoryProvider);
  final formData = ref.watch(productFormDataProvider.notifier);
  final filterController = ref.watch(productFilterControllerProvider.notifier);
  final imageSliderController = ref.watch(imageSliderNotifierProvider.notifier);
  return ProductFormFieldsController(repository, formData, filterController, imageSliderController);
});
