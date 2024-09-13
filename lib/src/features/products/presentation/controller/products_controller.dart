import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/products/data/product_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductsController {
  ProductsController(this.productRepositoryProvider);
  final ProductRepository productRepositoryProvider;
  final formKey = GlobalKey<FormState>();

  String productCode = '';
  String productName = '';

  void addProduct(context) async {
    final isValid =
        formKey.currentState!.validate(); // runs validation inside form
    if (!isValid) return;
    formKey.currentState!.save(); // runs onSave inside form
    bool isSuccessful = await productRepositoryProvider.addProduct(
      itemCode: productCode,
      itemName: productName,
    );
    if (isSuccessful) {
      Navigator.of(context).pop();
      utils.UserMessages.success(
        context: context,
        message: S.of(context).success_adding_doc_to_db,
      );
    } else {
      utils.UserMessages.failure(
        context: context,
        message: S.of(context).error_adding_doc_to_db,
      );
    }
  }
}

final productsControllerProvider = Provider<ProductsController>((ref) {
  final productsRepository = ref.read(productRepositoryProvider);
  return ProductsController(productsRepository);
});
