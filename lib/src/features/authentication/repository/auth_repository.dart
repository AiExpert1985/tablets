import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthRepository {
  AuthRepository();

  ///creates a new user without log him in
  /// return the userId of the newly created user 
  Future<String?> newUser({
    required String email,
    required String password,
  }) async {
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
    final newUserId = newUserCredential.user!.uid;
    await secondaryApp.delete();
    return newUserId;
  }

  void signUserIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> deleteUser() asynch {
    await FirebaseAuth.instance
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
