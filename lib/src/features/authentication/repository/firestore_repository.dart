import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/authentication/repository/app_user.dart';

class FireStoreRepository {
  FireStoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Query<AppUser> usersQuery() {
    return _firestore.collection('users').withConverter(
          fromFirestore: (snapshot, _) => AppUser.fromMap(snapshot.data()!),
          toFirestore: (appUser, _) => appUser.toMap(),
        );
  }

  Future<void> addUser({
    required String uid,
    required String userName,
    required String email,
    required String imageUrl,
    required String privilage,
  }) async {
    CollectionReference users = _firestore.collection('users');
    await users.doc(uid).set({
      'userName': userName,
      'email': email,
      'imageUrl': imageUrl,
      'privilage': privilage,
    });
  }

  Future<void> updateUser({
    required String uid,
    required String userName,
    required String email,
    required String imageUrl,
    required String privilage,
  }) async {
    CollectionReference users = _firestore.collection('users');
    await users.doc(uid).update({
      'userName': userName,
      'email': email,
      'imageUrl': imageUrl,
      'privilage': privilage,
    });
  }

  Future<void> deleteUser({required String uid}) async{
    await _firestore.collection('users').doc(uid).delete();
  }

}

final firestoreRepositoryProvider = Provider<FireStoreRepository>((ref) {
  return FireStoreRepository(FirebaseFirestore.instance);
});
