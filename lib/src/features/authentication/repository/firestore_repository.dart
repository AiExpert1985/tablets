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
}

final firestoreRepositoryProvider = Provider<FireStoreRepository>((ref) {
  return FireStoreRepository(FirebaseFirestore.instance);
});
