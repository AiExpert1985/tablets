import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FireStoreRepository {
  FireStoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Query<Map<String, dynamic>> usersQuery() {
    return _firestore.collection('users');
  }
}

final firestoreRepositoryProvider = Provider<FireStoreRepository>((ref) {
  return FireStoreRepository(FirebaseFirestore.instance);
});
