import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_providers/image_picker_provider.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/create_product_from.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductsController {
  ProductsController(this.ref);
  final ProviderRef ref;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Product tempProduct = Product.defaultValues();

  void resetTempProduct() {
    tempProduct = Product.defaultValues();
  }

  void resetImagePicker() {
    ref.read(pickedImageNotifierProvider.notifier).reset();
  }

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
    resetImagePicker();
    resetTempProduct();
  }

  void createNewProductInDb(context) async {
    if (!saveForm()) return;
    final pickedImage = ref.read(pickedImageNotifierProvider);
    final productsRespository = ref.read(productsRepositoryProvider);
    final product = tempProduct;
    final successful = await productsRespository.addCategoryToDB(
        product: product, pickedImage: pickedImage);
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

  /// show the form for creating new category
  /// image displayed in the picker is the default image
  void showProductCreateForm(BuildContext context) {
    resetTempProduct();
    resetImagePicker();
    showDialog(
      context: context,
      builder: (BuildContext context) => const CreateProductForm(),
    );
  }

  void showCategoryUpdateForm(
      {required BuildContext context, required Product product}) {}
}

final productsControllerProvider = Provider<ProductsController>((ref) {
  return ProductsController(ref);
});
