import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductRepository {
  ProductRepository(this._firestore, this._imageStorage, this._ref);
  final FirebaseFirestore _firestore;
  final StorageRepository _imageStorage;
  final ProviderRef _ref;

  static String firestoreCollectionName = 'products';
  static String firebaseOrderKey = 'name';
  static String storageFolderName = 'products';

  Future<bool> addCategoryToDB(
      {required Product product, File? pickedImage}) async {
    try {
      // if an image is picked, we will store it in firebase and use its url
      // otherwise, we will use the default item image url
      if (pickedImage != null) {
        final newUrl = await _imageStorage.addFile(
            folder: storageFolderName,
            fileName: product.name,
            file: pickedImage);
        product.iamgesUrl.add(newUrl!);
      }

      final docRef = _firestore.collection(firestoreCollectionName).doc();
      await docRef.set(product.toMap());
      return true;
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error while adding Product to DB',
          stackTrace: StackTrace.current);
      return false;
    }
  }

  Stream<List<Product>> watchProductsList() {
    final ref = _productsRef();
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Query<Product> _productsRef() {
    return _firestore
        .collection(firestoreCollectionName)
        .orderBy(firebaseOrderKey)
        .withConverter(
          fromFirestore: (doc, _) => Product.fromMap(doc.data()!),
          toFirestore: (Product product, options) => product.toMap(),
        );
  }
}

final productsRepositoryProvider = Provider<ProductRepository>((ref) {
  final imageStorage = ref.read(fileStorageProvider);
  final firestore = FirebaseFirestore.instance;
  return ProductRepository(firestore, imageStorage, ref);
});

final productsStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});
