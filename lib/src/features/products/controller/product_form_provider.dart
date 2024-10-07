import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/products/controller/products_list_controller.dart';
import 'package:tablets/src/features/products/controller/product_state_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/product_add_dialog.dart';
import 'package:tablets/src/features/products/view/product_edit_dialog.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:tablets/src/constants/constants.dart' as constants;

class ProductFormController {
  ProductFormController(
    this._productsRepository,
    this._productStateController,
    this.productSearchController,
  );
  final ProductRepository _productsRepository;
  final ProductStateNotifier _productStateController;
  final ProductSearchNotifier productSearchController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> _tempUrls = [];

  bool saveForm() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return false;
    formKey.currentState!.save();
    return true;
  }

  void closeForm(BuildContext context) {
    Navigator.of(context).pop();
  }

  void addProductToDb(context) async {
    if (!saveForm()) return;
    final imageUrls = _productStateController.currentState.imageUrls;
    final productState =
        _productStateController.setProduct(_productStateController.currentState.product.copyWith(imageUrls: imageUrls));
    _tempUrls = [];
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
    productSearchController.updateProductList();
  }

  /// this takes an image file (which was created by imagePicker) and store it directly in firebase
  /// and store the new url into a temp list inside the controller
  /// this list will be viewed later by the image slider viewer
  /// I did that as a solution to separate the image upload from from submission
  /// note that this method is called automatically by the image picker when a new image is picked
  void uploadImageToDb(File? pickedImage) async {
    // always store with random numbers to avoid duplications
    String name = utils.StringOperations.generateRandomString();
    final url = await _productsRepository.uploadImageToDb(fileName: name, imageFile: pickedImage);
    if (url != null) {
      _productStateController.addImageUrls(url); // add to imageUrls to be displayed inside form
      _tempUrls.add(url); // add to tempUrls to be deleted in form is cancelled by user
    }
  }

  void showAddProductForm(BuildContext context) {
    _productStateController.reset();
    showDialog(
      context: context,
      builder: (BuildContext context) => const AddProductForm(),
    ).whenComplete(_onProductFormClosing);
  }

  /// when form is closed, we delete (from firestore) all uploaded images that aren't used
  /// this is needed because app stores images (to firestore) directly when uploaded and
  /// it happends that user sometimes uploads images then cancel the form
  void _onProductFormClosing() {
    _deleteMultipleImagesFromDb(_tempUrls);
    _tempUrls = [];
    _productStateController.reset();
  }

  void _deleteMultipleImagesFromDb(List<String> urls) {
    for (var url in urls) {
      _deleteSingleImageFromDb(url);
    }
  }

  void _deleteSingleImageFromDb(String url) => _productsRepository.deleteImageFromDb(url);

  void showEditProductForm({required BuildContext context, required Product product}) {
    _productStateController.setImageUrls(product.imageUrls);
    _productStateController.setProduct(product);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const EditProductForm(),
    ).whenComplete(_onProductFormClosing);
  }

  void removeFormImage(String url) {
    _productStateController.removeImageUrls(url);
    if (url == constants.DefaultImage.url) return; // we don't remove the default image
    _tempUrls.add(url);
  }

  void deleteProductFromDB(BuildContext context, Product product) async {
    // we don't want to delete image if its the default image
    bool deleteImage = product.imageUrls[0] != constants.DefaultImage.url;
    bool successful = await _productsRepository.deleteProductFromDB(product: product, deleteImage: deleteImage);
    if (successful) {
      if (context.mounted) {
        utils.UserMessages.success(context: context, message: S.of(context).db_success_deleting_doc);
      }
    } else {
      if (context.mounted) {
        utils.UserMessages.failure(context: context, message: S.of(context).db_error_deleting_doc);
      }
    }
    if (context.mounted) closeForm(context);
    productSearchController.updateProductList();
  }

  void updateProductInDB(BuildContext context, Product oldProduct) async {
    if (!saveForm()) return;
    final tempImageUrls = _productStateController.currentState.imageUrls;
    final tempProduct = _productStateController.currentState.product;
    final newProduct = _productStateController.setProduct(tempProduct.copyWith(imageUrls: tempImageUrls)).product;
    _tempUrls = [];
    bool successful = await _productsRepository.updateProductInDB(newProduct: newProduct, oldProduct: oldProduct);
    if (successful) {
      if (context.mounted) {
        utils.UserMessages.success(context: context, message: S.of(context).db_success_updaging_doc);
      }
    } else {
      if (context.mounted) {
        utils.UserMessages.failure(context: context, message: S.of(context).db_error_updating_doc);
      }
    }
    if (context.mounted) {
      closeForm(context);
    }
    productSearchController.updateProductList();
  }
}

final productsFormControllerProvider = Provider<ProductFormController>((ref) {
  final productsRepository = ref.read(productsRepositoryProvider);
  final productStateController = ref.watch(productStateNotifierProvider.notifier);
  final productSearchController = ref.watch(productSearchNotifierProvider.notifier);
  return ProductFormController(productsRepository, productStateController, productSearchController);
});
