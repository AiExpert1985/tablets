import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRepository {
  ProductRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addProduct({
    required String itemCode,
    required String itemName,
  }) async {
    CollectionReference users = _firestore.collection('products');
    await users.add({
      'itemCode': itemCode,
      'itemName': itemName,
    });
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(FirebaseFirestore.instance);
});
