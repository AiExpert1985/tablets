import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository();

  Future<bool> createUserWithoutLogin(
      String email, String password, String userName, File? pickedImage) async {
    bool isUserCreatedSuccessfully = false;
    try {
      // Create a secondary app
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );
      // Create a user with the secondary app
      UserCredential newUserCredential =
          await FirebaseAuth.instanceFor(app: secondaryApp)
              .createUserWithEmailAndPassword(email: email, password: password);
      // close second app after creating the user
      await secondaryApp.delete();

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_iamges')
          .child('${newUserCredential.user!.uid}.jpg');
      await storageRef.putFile(pickedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');
      await users.doc(newUserCredential.user!.uid).set({
        'userName': userName,
        'email': email,
        'creationTime': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
        'privilage': 'admin',
      });
      isUserCreatedSuccessfully = true;
    } on FirebaseAuthException catch (e) {
      debugPrint('User Creation Error: ${e.message}');
    }
    return isUserCreatedSuccessfully;
  }

  void signUserIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('User Login Error: ${e.message}');
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
