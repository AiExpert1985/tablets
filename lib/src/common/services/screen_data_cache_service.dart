import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

class ScreenDataCacheService {
  ScreenDataCacheService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _customerCollection = 'customer_screen_data';
  static const _salesmanCollection = 'salesman_screen_data';
  static const _productCollection = 'product_screen_data';

  Future<List<Map<String, dynamic>>> fetchAllCustomerScreenData() async {
    return _fetchCollection(_customerCollection);
  }

  Future<List<Map<String, dynamic>>> fetchAllSalesmanScreenData() async {
    return _fetchCollection(_salesmanCollection);
  }

  Future<List<Map<String, dynamic>>> fetchAllProductScreenData() async {
    return _fetchCollection(_productCollection);
  }

  Future<bool> hasCustomerScreenData() async {
    return _collectionHasData(_customerCollection);
  }

  Future<bool> hasSalesmanScreenData() async {
    return _collectionHasData(_salesmanCollection);
  }

  Future<bool> hasProductScreenData() async {
    return _collectionHasData(_productCollection);
  }

  Future<void> saveCustomerScreenData(List<Map<String, dynamic>> rows) async {
    await _saveRows(_customerCollection, rows, 'customerDbRef');
  }

  Future<void> saveSalesmanScreenData(List<Map<String, dynamic>> rows) async {
    await _saveRows(_salesmanCollection, rows, 'salesmanDbRef');
  }

  Future<void> saveProductScreenData(List<Map<String, dynamic>> rows) async {
    await _saveRows(_productCollection, rows, 'productDbRef');
  }

  Future<void> saveCustomerRow(Map<String, dynamic> row) async {
    await _saveRow(_customerCollection, row, 'customerDbRef');
  }

  Future<void> saveSalesmanRow(Map<String, dynamic> row) async {
    await _saveRow(_salesmanCollection, row, 'salesmanDbRef');
  }

  Future<void> saveProductRow(Map<String, dynamic> row) async {
    await _saveRow(_productCollection, row, 'productDbRef');
  }

  Future<List<Map<String, dynamic>>> _fetchCollection(String collection) async {
    final snapshot = await _firestore.collection(collection).get(const GetOptions());
    return snapshot.docs.map((doc) => _deserializeData(doc.data())).toList();
  }

  Future<bool> _collectionHasData(String collection) async {
    final snapshot = await _firestore.collection(collection).limit(1).get(const GetOptions());
    return snapshot.size > 0;
  }

  Future<void> _saveRows(
      String collection, List<Map<String, dynamic>> rows, String refKey) async {
    final batch = _firestore.batch();
    for (final row in rows) {
      final ref = row[refKey] ?? row['dbRef'];
      if (ref == null) continue;
      final docRef = _firestore.collection(collection).doc(ref.toString());
      batch.set(docRef, _serializeData(row));
    }
    await batch.commit();
  }

  Future<void> _saveRow(String collection, Map<String, dynamic> row, String refKey) async {
    final ref = row[refKey] ?? row['dbRef'];
    if (ref == null) return;
    final docRef = _firestore.collection(collection).doc(ref.toString());
    await docRef.set(_serializeData(row));
  }

  Map<String, dynamic> _serializeData(Map<String, dynamic> data) {
    return data.map((key, value) => MapEntry(key, _serializeValue(value)));
  }

  dynamic _serializeValue(dynamic value) {
    if (value is Transaction) return value.toMap();
    if (value is DateTime) return Timestamp.fromDate(value);
    if (value is List) return value.map(_serializeValue).toList();
    if (value is Map<String, dynamic>) {
      return value.map((k, v) => MapEntry(k, _serializeValue(v)));
    }
    return value;
  }

  Map<String, dynamic> _deserializeData(Map<String, dynamic> data) {
    return data.map((key, value) => MapEntry(key, _deserializeValue(value)));
  }

  dynamic _deserializeValue(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is Map<String, dynamic>) {
      if (_looksLikeTransaction(value)) return Transaction.fromMap(value);
      return value.map((k, v) => MapEntry(k, _deserializeValue(v)));
    }
    if (value is List) return value.map(_deserializeValue).toList();
    return value;
  }

  bool _looksLikeTransaction(Map<String, dynamic> value) {
    return value.containsKey('transactionType') &&
        value.containsKey('date') &&
        value.containsKey('dbRef');
  }
}
