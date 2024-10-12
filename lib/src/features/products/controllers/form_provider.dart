import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_providers/image_slider_controller.dart';
import 'package:tablets/src/features/products/controllers/list_filter_controller.dart';
import 'package:tablets/src/features/products/controllers/temp_product_provider.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/widgets/forms/form_add.dart';
import 'package:tablets/src/features/products/view/widgets/forms/form_edit.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductFormFieldsController {
  ProductFormFieldsController(
    this._productsRepository,
    this._productStateController,
    this._productFilterController,
    this._imageSliderController,
  );
  final ProductRepository _productsRepository;
  final ProductStateNotifier _productStateController;
  final ProductSearchNotifier _productFilterController;
  final ImageSliderNotifier _imageSliderController;
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
    final updatedUrls = _imageSliderController.savedUpdatedImages();
    final productState = _productStateController
        .setProduct(_productStateController.currentState.product.copyWith(imageUrls: updatedUrls));
    final successful = await _productsRepository.addProductToDB(product: productState.product);
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
    if (_productFilterController.getState.isSearchOn) _productFilterController.applyFilters();
  }

  void showAddForm(BuildContext context) {
    _productStateController.reset();
    _imageSliderController.initialize();
    showDialog(
      context: context,
      builder: (BuildContext context) => const AddProductForm(),
    ).whenComplete(_onFormClosing);
  }

  /// when form is closed, we delete (from firestore) all uploaded images that aren't used
  /// this is needed because app stores images (to firestore) directly when uploaded and
  /// it happends that user sometimes uploads images then cancel the form
  void _onFormClosing() {
    _imageSliderController.close();
    _productStateController.reset();
  }

  void showEditForm({required BuildContext context, required Product product}) {
    _productStateController.setImageUrls(product.imageUrls);
    _productStateController.setProduct(product);
    _imageSliderController.initialize(urls: product.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const EditProductForm(),
    ).whenComplete(_onFormClosing);
  }

  void deleteProduct(BuildContext context, Product product) async {
    // add all urls to the tempurls list, they will be automatically deleted once form is closed
    bool successful = await _productsRepository.deleteProductFromDB(product: product);
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
    if (_productFilterController.getState.isSearchOn) _productFilterController.applyFilters();
  }

  void updateProduct(BuildContext context, Product oldProduct) async {
    if (!validateForm()) return;
    final updateUrls = _imageSliderController.savedUpdatedImages();
    final tempProduct = _productStateController.currentState.product;
    final newProduct =
        _productStateController.setProduct(tempProduct.copyWith(imageUrls: updateUrls)).product;
    bool successful =
        await _productsRepository.updateProductInDB(newProduct: newProduct, oldProduct: oldProduct);
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
    if (_productFilterController.getState.isSearchOn) _productFilterController.applyFilters();
  }
}

final productsFormFieldsControllerProvider = Provider<ProductFormFieldsController>((ref) {
  final productsRepository = ref.read(productsRepositoryProvider);
  final productStateController = ref.watch(productStateNotifierProvider.notifier);
  final productFilterController = ref.watch(productListFilterNotifierProvider.notifier);
  final imageSliderController = ref.watch(imageSliderNotifierProvider.notifier);
  return ProductFormFieldsController(
      productsRepository, productStateController, productFilterController, imageSliderController);
});
