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

  void closeForm(BuildContext context) {
    // close the form
    Navigator.of(context).pop();
  }

  void addProductToDb(context) async {
    if (!saveForm()) return;
    final productsRespository = ref.read(productsRepositoryProvider);
    final productStateController = ref.read(productStateNotifierProvider);
    final tempImageUrls = productStateController.imageUrls;
    final tempProduct = productStateController.product;
    final product = ref
        .read(productStateNotifierProvider.notifier)
        .setProduct(tempProduct.copyWith(imageUrls: tempImageUrls))
        .product;
    final successful = await productsRespository.addProductToDB(product: product);
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
    closeForm(context);
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
    ).whenComplete(_onProductFormClosing);
  }

  // void _onAddFormClose() {
  //   // when form is closed, we delete (from firestore) all uploaded images that aren't used
  //   // this is needed because app stores images (to firestore) directly when uploaded and
  //   // it happends that user sometimes uploads images then cancel the form
  //   final product = ref.read(productStateNotifierProvider).product;
  //   final imageUrls = ref.read(productStateNotifierProvider).imageUrls;
  //   // if imageUrls are the same as product.imageUrls, mean all images are used, we do nothing
  //   if (product.imageUrls != imageUrls) {
  //     for (var url in imageUrls) {
  //       ref.read(productsRepositoryProvider).deleteImageFromDb(url);
  //     }
  //   }
  //   ref.read(productStateNotifierProvider.notifier).reset();
  // }

  /// when form is closed, we delete (from firestore) all uploaded images that aren't used
  /// this is needed because app stores images (to firestore) directly when uploaded and
  /// it happends that user sometimes uploads images then cancel the form
  void _onProductFormClosing() {
    final productImageUrls = ref.read(productStateNotifierProvider).product.imageUrls;
    final tempImageUrls = ref.read(productStateNotifierProvider).imageUrls;
    List<String> difference =
        tempImageUrls.where((item) => !productImageUrls.toSet().contains(item)).toList();
    for (var url in difference) {
      ref.read(productsRepositoryProvider).deleteImageFromDb(url);
    }

    ref.read(productStateNotifierProvider.notifier).reset();
  }

  void showEditProductForm({required BuildContext context, required Product product}) {
    ref.read(productStateNotifierProvider.notifier).setImageUrls(product.imageUrls);
    ref.read(productStateNotifierProvider.notifier).setProduct(product);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const EditProductForm(),
    ).whenComplete(_onProductFormClosing);
  }

  void deleteCategoryInDB(BuildContext context, Product product) async {
    // we don't want to delete image if its the default image
    bool deleteImage = product.imageUrls[0] != constants.DefaultImage.url;
    bool successful = await ref
        .read(productsRepositoryProvider)
        .deleteProductFromDB(product: product, deleteImage: deleteImage);
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
  }

  void updateProductInDB(BuildContext context, Product oldProduct) async {
    if (!saveForm()) return;
    final productsRespository = ref.read(productsRepositoryProvider);
    final productStateController = ref.read(productStateNotifierProvider);
    final tempImageUrls = productStateController.imageUrls;
    final tempProduct = productStateController.product;
    final newProduct = ref
        .read(productStateNotifierProvider.notifier)
        .setProduct(tempProduct.copyWith(imageUrls: tempImageUrls))
        .product;
    bool successful =
        await productsRespository.updateProductInDB(newProduct: newProduct, oldProduct: oldProduct);
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
      closeForm(context);
    }
  }
}

final productsFormControllerProvider = Provider<ProductFormController>((ref) {
  return ProductFormController(ref);
});
