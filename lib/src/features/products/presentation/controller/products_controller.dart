import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/products/data/product_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductsController {
  ProductsController(this.productRepositoryProvider);
  final ProductRepository productRepositoryProvider;
  final formKey = GlobalKey<FormState>();

  late double productCode;
  late String productName;
  late double productSellRetailPrice;
  late double productSellWholePrice;
  late String productPackageType;
  late double productPackageWeight;
  late double productNumItemsInsidePackage;
  late double productAlertWhenExceeds;
  late double productAltertWhenLessThan;
  late double productSalesmanComission;
  late String productCategory;
  late double productInitialQuantity;

  void addProduct(context) async {
    final isValid =
        formKey.currentState!.validate(); // runs validation inside form
    if (!isValid) return;
    formKey.currentState!.save(); // runs onSave inside form
    bool isSuccessful = await productRepositoryProvider.addProduct(
      itemCode: productCode,
      itemName: productName,
      productSellRetailPrice: productSellRetailPrice,
      productSellWholePrice: productSellWholePrice,
      productPackageType: productPackageType,
      productPackageWeight: productPackageWeight,
      productNumItemsInsidePackage: productNumItemsInsidePackage,
      productAlertWhenExceeds: productAlertWhenExceeds,
      productAltertWhenLessThan: productAltertWhenLessThan,
      productSalesmanComission: productSalesmanComission,
      productCategory: productCategory,
      productInitialQuantity: productInitialQuantity,
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
