import 'package:firebase_auth/firebase_auth.dart';
import 'package:tablets/src/features/authentication/domain/app_user.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_convertUser);
  }

  AppUser? get currentUser => _convertUser(_auth.currentUser);

  /// convert User to AppUser
  AppUser? _convertUser(User? user) => user != null
      ? AppUser(
          uid: user.uid,
          email: user.email,
          emailVerified: user.emailVerified,
        )
      : null;
}

// AuthRepository authRepository(AuthRepositoryRef ref) {
//   return AuthRepository(FirebaseAuth.instance);
// }
