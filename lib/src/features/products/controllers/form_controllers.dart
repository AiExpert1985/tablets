import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/image_slider_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/dialog_form_add.dart';
import 'package:tablets/src/features/products/view/dialog_form_edit.dart';
import 'package:tablets/src/common/functions/user_messages.dart' as toastification;

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
    final product = Product.fromMap({...updatedData, 'imageUrls': updatedUrls});
    final successful = await _repository.addProductToDB(product: product);
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
        toastification.success(context: context, message: S.of(context).db_success_deleting_doc);
      }
    } else {
      if (context.mounted) {
        toastification.failure(context: context, message: S.of(context).db_error_deleting_doc);
      }
    }
    if (context.mounted) closeForm(context);
  }

  void updateProduct(BuildContext context, Product oldProduct) async {
    if (!validateForm()) return;
    final updatedUrls = _imageSlider.savedUpdatedImages();
    _formData.update(key: 'imageUrls', value: updatedUrls);
    final updatedData = _formData.getState();
    final product = Product.fromMap({...updatedData, 'imageUrls': updatedUrls});
    final successful = await _repository.updateProductInDB(newProduct: product, oldProduct: oldProduct);
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

final productFormControllerProvider = Provider<ProductFormFieldsController>((ref) {
  final repository = ref.read(productsRepositoryProvider);
  final formData = ref.watch(productFormDataProvider.notifier);
  final imageSliderController = ref.watch(imageSliderNotifierProvider.notifier);
  return ProductFormFieldsController(repository, formData, imageSliderController);
});

class UserFormData extends StateNotifier<Map<String, dynamic>> {
  UserFormData(super.state);

  void initialize(Product product) {
    state = {
      'code': product.code,
      'name': product.name,
      'sellRetailPrice': product.sellRetailPrice,
      'sellWholePrice': product.sellWholePrice,
      'packageType': product.packageType,
      'packageWeight': product.packageWeight,
      'numItemsInsidePackage': product.numItemsInsidePackage,
      'alertWhenExceeds': product.alertWhenExceeds,
      'altertWhenLessThan': product.altertWhenLessThan,
      'salesmanComission': product.salesmanComission,
      'imageUrls': product.imageUrls,
      'category': product.category,
      'initialQuantity': product.initialQuantity
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

final productFormDataProvider = StateNotifierProvider<UserFormData, Map<String, dynamic>>((ref) => UserFormData({}));
