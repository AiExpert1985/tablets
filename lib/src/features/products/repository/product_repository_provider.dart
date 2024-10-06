import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/features/products/controller/product_search_provider.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductRepository {
  ProductRepository(this._firestore, this._imageStorage, this._ref);
  final FirebaseFirestore _firestore;
  final StorageRepository _imageStorage;
  final ProviderRef<ProductRepository> _ref;

  static String collectionName = 'products';
  static String nameKey = 'name';
  static String imageFolderName = 'products';

  Future<bool> addProductToDB({required Product product, File? pickedImage}) async {
    try {
      // if an image is picked, we will store it in firebase and use its url
      // otherwise, we will use the default item image url
      if (pickedImage != null) {
        final newUrl = await _imageStorage.addFile(
            folder: imageFolderName, fileName: product.name, file: pickedImage);
        product.imageUrls.add(newUrl!);
      }

      final docRef = _firestore.collection(collectionName).doc();
      await docRef.set(product.toMap());
      return true;
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error while adding Product to DB', stackTrace: StackTrace.current);
      return false;
    }
  }

  Future<String?> uploadImageToDb({required String fileName, required File? imageFile}) async {
    try {
      if (imageFile != null) {
        final newUrl = await _imageStorage.addFile(
            folder: imageFolderName, fileName: fileName, file: imageFile);
        return newUrl;
      }
      return null;
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error while adding Product to DB', stackTrace: StackTrace.current);
      return null;
    }
  }

  Future<bool> updateProductInDB({required Product newProduct, required Product oldProduct}) async {
    try {
      // then update the category document
      final query =
          _firestore.collection(imageFolderName).where(nameKey, isEqualTo: oldProduct.name);
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

  Future<bool> deleteImageFromDb(String url) async {
    try {
      _imageStorage.deleteFile(url);
      return true;
    } catch (error) {
      utils.CustomDebug.print(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  /// delete the document from firestore
  /// delete image from storage
  Future<bool> deleteProductFromDB({required Product product, bool deleteImage = true}) async {
    try {
      // delete document using its name
      final querySnapshot =
          await _firestore.collection(collectionName).where(nameKey, isEqualTo: product.name).get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.delete();
      }
      // sometime we don't want to delete image (if it is the default image)
      if (deleteImage) {
        product.imageUrls.map((url) => _imageStorage.deleteFile(url));
      }
      return true;
    } catch (error) {
      utils.CustomDebug.print(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  Stream<List<Product>> watchProductsList() {
    final ref = _productsRef();
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Query<Product> _productsRef() {
    final searchedValues = _ref.watch(productSearchNotifierProvider).fieldValues;
    Query query = _firestore.collection(collectionName);
    searchedValues.forEach((key, value) {
      if (value is String) {
        query =
            query.where(key, isGreaterThanOrEqualTo: value).where(key, isLessThan: '$value\uf8ff');

        utils.CustomDebug.tempPrint('$key, $value');
      } else {
        query = query.where(key, isGreaterThanOrEqualTo: value);
      }
    });
    return query.withConverter(
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
