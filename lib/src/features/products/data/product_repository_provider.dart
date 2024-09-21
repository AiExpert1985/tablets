import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductRepository {
  ProductRepository(this._firestore);
  final FirebaseFirestore _firestore;

  /// add item to firebase products document
  /// return true if added successfully, otherwise returns false
  Future<bool> addProduct({
    required double itemCode,
    required String itemName,
    required double productSellRetailPrice,
    required double productSellWholePrice,
    required String productPackageType,
    required double productPackageWeight,
    required double productNumItemsInsidePackage,
    required double productAlertWhenExceeds,
    required double productAltertWhenLessThan,
    required double productSalesmanComission,
    required String productCategory,
    required double productInitialQuantity,
  }) async {
    final productsRef = _firestore.collection('products').doc();
    try {
      await productsRef.set({
        'creationTime': FieldValue.serverTimestamp(),
        'itemCode': itemCode,
        'itemName': itemName,
        'productSellRetailPrice': productSellRetailPrice,
        'productSellWholePrice': productSellWholePrice,
        'productPackageType': productPackageType,
        'productPackageWeight': productPackageWeight,
        'productNumItemsInsidePackage': productNumItemsInsidePackage,
        'productAlertWhenExceeds': productAlertWhenExceeds,
        'productAltertWhenLessThan': productAltertWhenLessThan,
        'productSalesmanComission': productSalesmanComission,
        'productCategory': productCategory,
        'productInitialQuantity': productInitialQuantity,
      });
      return true;
    } catch (e) {
      utils.CustomDebug.print(e,
          callerMethod: 'ProductRepository.addProduct()');
      return false;
    }
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(FirebaseFirestore.instance);
});
