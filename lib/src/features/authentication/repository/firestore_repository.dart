import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FireStoreRepository {
  FireStoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addUser({
    required String uid,
    required String email,
    required String userName,
    required String imageUrl,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      "email": email,
      "username": userName,
      "image_url": imageUrl,
    });
  }
}

final firestoreRepositoryProvider = Provider<FireStoreRepository>((ref) {
  return FireStoreRepository(FirebaseFirestore.instance);
});
