import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/utils/debug_utils.dart';

class ProductRepository {
  ProductRepository(this._firestore);
  final FirebaseFirestore _firestore;

  /// add item to firebase products document
  /// return true if added successfully, otherwise returns false
  Future<bool> addProduct({
    required String itemCode,
    required String itemName,
  }) async {
    final productsRef = _firestore.collection('products').doc();
    try {
      await productsRef.set({
        'itemCode': itemCode,
        'itemName': itemName,
      });
      return true;
    } catch (e) {
      customDebugPrint(e);
      return false;
    }
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(FirebaseFirestore.instance);
});
