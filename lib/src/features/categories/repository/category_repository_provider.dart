import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/categories/model/category.dart';
import 'package:tablets/src/common/functions/debug_print.dart' as debug;

class CategoryRepository {
  CategoryRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String collectionName = 'categories';
  static String dbReferenceKey = 'dbKey';
  static String dbOrderKey = 'name';

  Future<bool> addCategoryToDB(ProductCategory category) async {
    try {
      final docRef = _firestore.collection(collectionName).doc();
      await docRef.set(category.toMap());
      return true;
    } catch (e) {
      debug.errorPrint(
          message: 'An error while adding Product to DB', stackTrace: StackTrace.current);
      return false;
    }
  }

  Future<bool> updateCategoryInDB(ProductCategory updatedCategory) async {
    try {
      final query = _firestore
          .collection(collectionName)
          .where(dbReferenceKey, isEqualTo: updatedCategory.dbKey);
      final querySnapshot = await query.get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.update(updatedCategory.toMap());
      }
      return true;
    } catch (error) {
      debug.errorPrint(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteCategoryFromDB(ProductCategory category) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where(dbReferenceKey, isEqualTo: category.dbKey)
          .get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.delete();
      }
      return true;
    } catch (error) {
      debug.errorPrint(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> watchMapList() {
    final ref = _firestore.collection(collectionName).orderBy(dbOrderKey);
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  /// below function was not tested
  Stream<List<ProductCategory>> watchCategoryList() {
    final query = _firestore.collection(collectionName).orderBy(dbOrderKey);
    final ref = query.withConverter(
      fromFirestore: (doc, _) => ProductCategory.fromMap(doc.data()!),
      toFirestore: (ProductCategory product, options) => product.toMap(),
    );
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Future<ProductCategory> fetchCategoryItem({String? filterKey, String? filterValue}) async {
    Query query = _firestore.collection(collectionName);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final ref = query.withConverter(
      fromFirestore: (doc, _) => ProductCategory.fromMap(doc.data()!),
      toFirestore: (ProductCategory product, options) => product.toMap(),
    );
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList().first;
  }

  Future<Map<String, dynamic>> fetchMapItem({String? filterKey, String? filterValue}) async {
    Query query = _firestore.collection(collectionName);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((docSnapshot) => docSnapshot.data() as Map<String, dynamic>)
        .toList()
        .first;
  }

  Future<List<ProductCategory>> fetchCategoryList({String? filterKey, String? filterValue}) async {
    Query query = _firestore.collection(collectionName);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final ref = query.withConverter(
      fromFirestore: (doc, _) => ProductCategory.fromMap(doc.data()!),
      toFirestore: (ProductCategory product, options) => product.toMap(),
    );
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  /// below function was not tested
  Future<List<Map<String, dynamic>>> fetchMapList({String? filterKey, String? filterValue}) async {
    Query query = _firestore.collection(collectionName);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final snapshot = await query.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data() as Map<String, dynamic>).toList();
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  return CategoryRepository(firestore);
});
