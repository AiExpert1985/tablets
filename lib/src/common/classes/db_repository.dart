import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';
import 'package:tablets/src/common/functions/debug_print.dart';

class DbRepository {
  DbRepository(this._collectionName);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collectionName;
  final String _dbReferenceKey = 'dbRef';

  Future<void> addItem(BaseItem item) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      // Device is connected to the internet
      try {
        await _firestore.collection(_collectionName).doc().set(item.toMap());
        errorLog('Item added to live firestore successfully!');
        return;
      } catch (e) {
        errorPrint('Error adding item to live firestore: $e');
        return;
      }
    }
    // Device is offline
    final docRef = _firestore.collection(_collectionName).doc();
    docRef.set(item.toMap()).then((_) {
      errorLog('Item added to firestore cache!');
    }).catchError((e) {
      errorPrint('Error adding item to firestore cache: $e');
    });
  }

  Future<void> updateItem(BaseItem updatedItem) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      // Device is connected to the internet
      try {
        final query = _firestore
            .collection(_collectionName)
            .where(_dbReferenceKey, isEqualTo: updatedItem.dbRef);
        final querySnapshot = await query.get(const GetOptions(source: Source.cache));
        if (querySnapshot.size > 0) {
          final documentRef = querySnapshot.docs[0].reference;
          await documentRef.update(updatedItem.toMap());
          errorLog('Item updated in live firestore successfully!');
        }
        return;
      } catch (e) {
        errorPrint('Error updating item in live firestore: $e');
        return;
      }
    }
    // when offline
    final query =
        _firestore.collection(_collectionName).where(_dbReferenceKey, isEqualTo: updatedItem.dbRef);
    final querySnapshot = await query.get(const GetOptions(source: Source.cache));
    if (querySnapshot.size > 0) {
      final documentRef = querySnapshot.docs[0].reference;
      await documentRef.update(updatedItem.toMap()).then((_) {
        errorLog('Item updated in firestore cache!');
      }).catchError((e) {
        errorPrint('Error updating item in firebase cache: $e');
      });
    }
  }

  Future<void> deleteItem(BaseItem item) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      // Device is connected to the internet
      try {
        final querySnapshot = await _firestore
            .collection(_collectionName)
            .where(_dbReferenceKey, isEqualTo: item.dbRef)
            .get(const GetOptions(source: Source.cache));
        if (querySnapshot.size > 0) {
          final documentRef = querySnapshot.docs[0].reference;
          await documentRef.delete();
          errorLog('Item deleted from live firestore successfully!');
        }
        return;
      } catch (e) {
        errorPrint('Error deleting item from firestore cache: $e');
        return;
      }
    }
    final querySnapshot = await _firestore
        .collection(_collectionName)
        .where(_dbReferenceKey, isEqualTo: item.dbRef)
        .get(const GetOptions(source: Source.cache));
    if (querySnapshot.size > 0) {
      final documentRef = querySnapshot.docs[0].reference;
      await documentRef.delete().then((_) {
        errorLog('Item deleted from firestore cache!');
      }).catchError((e) {
        errorPrint('Error deleting item from firestore cache: $e');
      });
    }
  }

  Stream<List<Map<String, dynamic>>> watchItemListAsMaps() {
    final ref = _firestore.collection(_collectionName);
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  /// below function was not tested
  Stream<List<BaseItem>> watchItemListAsItems() {
    final query = _firestore.collection(_collectionName);
    final ref = query.withConverter(
      fromFirestore: (doc, _) => BaseItem.fromMap(doc.data()!),
      toFirestore: (BaseItem product, options) => product.toMap(),
    );
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  Future<BaseItem> fetchItemAsObject({String? filterKey, String? filterValue}) async {
    Query query = _firestore.collection(_collectionName);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final ref = query.withConverter(
      fromFirestore: (doc, _) => BaseItem.fromMap(doc.data()!),
      toFirestore: (BaseItem product, options) => product.toMap(),
    );
    final snapshot = await ref.get(const GetOptions(source: Source.cache));
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList().first;
  }

  Future<Map<String, dynamic>> fetchItemAsMap({String? filterKey, String? filterValue}) async {
    Query query = _firestore.collection(_collectionName);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final snapshot = await query.get(const GetOptions(source: Source.cache));
    return snapshot.docs
        .map((docSnapshot) => docSnapshot.data() as Map<String, dynamic>)
        .toList()
        .first;
  }

  Future<List<BaseItem>> fetchItemListAsObjects({String? filterKey, String? filterValue}) async {
    Query query = _firestore.collection(_collectionName);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final ref = query.withConverter(
      fromFirestore: (doc, _) => BaseItem.fromMap(doc.data()!),
      toFirestore: (BaseItem product, options) => product.toMap(),
    );
    final snapshot = await ref.get(const GetOptions(source: Source.cache));
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  /// below function was not tested
  Future<List<Map<String, dynamic>>> fetchItemListAsMaps(
      {String? filterKey, String? filterValue}) async {
    Query query = _firestore.collection(_collectionName);
    if (filterKey != null) {
      query = query
          .where(filterKey, isGreaterThanOrEqualTo: filterValue)
          .where(filterKey, isLessThan: '$filterValue\uf8ff');
    }
    final snapshot = await query.get(const GetOptions(source: Source.cache));
    return snapshot.docs.map((docSnapshot) => docSnapshot.data() as Map<String, dynamic>).toList();
  }
}
