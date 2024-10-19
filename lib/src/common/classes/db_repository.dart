import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';
import 'package:tablets/src/common/functions/debug_print.dart';

class DbRepository {
  DbRepository(this._collectionName);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collectionName;
  final String _dbReferenceKey = 'dbKey';

  Future<bool> addItem(BaseItem item) async {
    try {
      final docRef = _firestore.collection(_collectionName).doc();
      await docRef.set(item.toMap());
      return true;
    } catch (e) {
      errorPrint(message: e, stackTrace: StackTrace.current);
      return false;
    }
  }

  Future<bool> updateItem(BaseItem updatedItem) async {
    try {
      final query = _firestore
          .collection(_collectionName)
          .where(_dbReferenceKey, isEqualTo: updatedItem.dbKey);
      final querySnapshot = await query.get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.update(updatedItem.toMap());
      }
      return true;
    } catch (error) {
      errorPrint(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteItem(BaseItem item) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where(_dbReferenceKey, isEqualTo: item.dbKey)
          .get();
      if (querySnapshot.size > 0) {
        final documentRef = querySnapshot.docs[0].reference;
        await documentRef.delete();
      }
      return true;
    } catch (error) {
      errorPrint(message: error, stackTrace: StackTrace.current);
      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> watchItemAsMaps({String orderedBy = 'name'}) {
    final ref = _firestore.collection(_collectionName).orderBy(orderedBy);
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  /// below function was not tested
  Stream<List<BaseItem>> watchItemsAsItems({String orderedBy = 'name'}) {
    final query = _firestore.collection(_collectionName).orderBy(orderedBy);
    final ref = query.withConverter(
      fromFirestore: (doc, _) => BaseItem.fromMap(doc.data()!),
      toFirestore: (BaseItem product, options) => product.toMap(),
    );
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Future<BaseItem> fetchItemAsObject(
      {String? filterKey, String? filterValue, String orderedBy = 'name'}) async {
    Query query = _firestore.collection(_collectionName).orderBy(orderedBy);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final ref = query.withConverter(
      fromFirestore: (doc, _) => BaseItem.fromMap(doc.data()!),
      toFirestore: (BaseItem product, options) => product.toMap(),
    );
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList().first;
  }

  Future<Map<String, dynamic>> fetchItemAsMap(
      {String? filterKey, String? filterValue, String orderedBy = 'name'}) async {
    Query query = _firestore.collection(_collectionName).orderBy(orderedBy);
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

  Future<List<BaseItem>> fetchItemsAsObjects(
      {String? filterKey, String? filterValue, String orderedBy = 'name'}) async {
    Query query = _firestore.collection(_collectionName).orderBy(orderedBy);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final ref = query.withConverter(
      fromFirestore: (doc, _) => BaseItem.fromMap(doc.data()!),
      toFirestore: (BaseItem product, options) => product.toMap(),
    );
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  /// below function was not tested
  Future<List<Map<String, dynamic>>> fetchItemsAsMaps(
      {String? filterKey, String? filterValue, String orderedBy = 'name'}) async {
    Query query = _firestore.collection(_collectionName).orderBy(orderedBy);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final snapshot = await query.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data() as Map<String, dynamic>).toList();
  }
}
