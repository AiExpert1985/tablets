import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductRepository {
  ProductRepository(this._firestore, this._imageStorage);
  final FirebaseFirestore _firestore;
  final StorageRepository _imageStorage;

  static String collectionName = 'products';
  static String nameKey = 'name';

  Future<bool> addProductToDB({required Product product, File? pickedImage}) async {
    try {
      final docRef = _firestore.collection(collectionName).doc();
      await docRef.set(product.toMap());
      return true;
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error while adding Product to DB', stackTrace: StackTrace.current);
      return false;
    }
  }

  Future<bool> updateProductInDB({required Product newProduct, required Product oldProduct}) async {
    try {
      final query =
          _firestore.collection(collectionName).where(nameKey, isEqualTo: oldProduct.name);
      final querySnapshot = await query.get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.update(newProduct.toMap());
      }
      return true;
    } catch (error) {
      utils.CustomDebug.print(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteImageFromDb(String url) async => await _imageStorage.deleteImage(url);

  Future<bool> deleteProductFromDB({required Product product}) async {
    try {
      final querySnapshot =
          await _firestore.collection(collectionName).where(nameKey, isEqualTo: product.name).get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.delete();
      }
      return true;
    } catch (error) {
      utils.CustomDebug.print(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> watchProductsList() {
    final ref = _productsRef();
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Query<Map<String, dynamic>> _productsRef() {
    return _firestore.collection(collectionName).orderBy(nameKey);
  }

  /// fetch a list filtered based on product name
  Future<List<Product>> fetchFilteredProductsList(String filter) async {
    Query query = _firestore.collection(collectionName);
    query = query
        .where('name', isGreaterThanOrEqualTo: filter)
        .where('name', isLessThan: '$filter\uf8ff');
    final ref = query.withConverter(
      fromFirestore: (doc, _) => Product.fromMap(doc.data()!),
      toFirestore: (Product product, options) => product.toMap(),
    );
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }
}

final productsRepositoryProvider = Provider<ProductRepository>((ref) {
  final imageStorage = ref.read(imageStorageProvider);
  final firestore = FirebaseFirestore.instance;
  return ProductRepository(firestore, imageStorage);
});
