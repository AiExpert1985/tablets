import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/products/controller/product_state_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/add_product_dialog.dart';
import 'package:tablets/src/features/products/view/edit_product_dialog.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:tablets/src/constants/constants.dart' as constants;

class ProductFormController {
  ProductFormController(this.ref);
  final ProviderRef ref;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    ref.read(productStateNotifierProvider.notifier).reset();
  }

  void addProductToDb(context) async {
    if (!saveForm()) return;
    final productsRespository = ref.read(productsRepositoryProvider);
    final productStateController = ref.read(productStateNotifierProvider);
    final product = productStateController.product;
    product.imageUrls = productStateController.imageUrls;
    final successful = await productsRespository.addCategoryToDB(product: product);
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

  /// this takes an image file (which was created by imagePicker) and store it directly in firebase
  /// and store the new url into a temp list inside the controller
  /// this list will be viewed later by the image slider viewer
  /// I did that as a solution to separate the image upload from from submission
  /// note that this method is called automatically by the image picker when a new image is picked
  void uploadImageToDb(pickedImage) async {
    // always store with random numbers to avoid duplications
    String name = utils.StringOperations.generateRandomString();
    final url = await ref
        .read(productsRepositoryProvider)
        .uploadImageToDb(fileName: name, imageFile: pickedImage);
    if (url != null) {
      ref.read(productStateNotifierProvider.notifier).updateImageUrls(url);
    }
  }

  void showAddProductForm(BuildContext context) {
    ref.read(productStateNotifierProvider.notifier).reset();
    showDialog(
      context: context,
      builder: (BuildContext context) => const AddProductForm(),
    );
  }

  void showEditProductForm({required BuildContext context, required Product product}) {
    ref.read(productStateNotifierProvider.notifier).setImageUrls(product.imageUrls);
    ref.read(productStateNotifierProvider.notifier).setProduct(product);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const EditProductForm(),
    );
  }

  void deleteCategoryInDB(BuildContext context, Product product) async {
    // we don't want to delete image if its the default image
    bool deleteImage = product.imageUrls[0] != constants.DefaultImage.url;
    bool successful = await ref
        .read(productsRepositoryProvider)
        .deleteCategoryInDB(product: product, deleteImage: deleteImage);
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
    if (context.mounted) cancelForm(context);
  }

  void updateProductInDB(BuildContext context, Product oldProduct) async {
    if (!saveForm()) return;
    final productsRespository = ref.read(productsRepositoryProvider);
    final productStateController = ref.read(productStateNotifierProvider);
    final newProduct = productStateController.product.copyWith();
    newProduct.imageUrls = productStateController.imageUrls;
    bool successful = await productsRespository.updateCategoryInDB(
        newProduct: newProduct, oldProduct: oldProduct);
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
    if (context.mounted) {
      cancelForm(context);
    }
  }
}

final productsFormControllerProvider = Provider<ProductFormController>((ref) {
  return ProductFormController(ref);
});
