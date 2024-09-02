import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/providers/firebase_auth_provider.dart';
import 'package:tablets/providers/firebase_firestore_provider.dart';
import 'package:tablets/providers/firebase_storage_provider.dart';
import 'package:tablets/providers/picked_image_file_provider.dart';
import 'package:tablets/screens/signup_screen/widgets/image_picker.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenScreenState();
}

class _SignupScreenScreenState extends ConsumerState<SignupScreen> {
  final _loginForm = GlobalKey<FormState>(); // the key used to access the form

  String _userEmail = '';
  String _userPassword = '';
  String _username = '';

  void _submitForm() async {
    final isValid = _loginForm.currentState!.validate(); // runs validator
    final pickedImage = ref.read(pickedImageFileProvider);
    final firebaseStorage = ref.read(firebaseStorageProvider);
    final firebaseAuth = ref.read(firebaseAuthProvider);
    final firebaseFirestore = ref.read(firebaseFirestoreProvider);
    if (!isValid || pickedImage == null) {
      return;
    }
    _loginForm.currentState!.save(); // runs onSave inside form
    try {
      final userCredentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: _userEmail,
        password: _userPassword,
      );
      final storageRef = firebaseStorage
          .ref()
          .child('user_iamges')
          .child('${userCredentials.user!.uid}.jpg');
      await storageRef.putFile(pickedImage);
      final imageUrl =
          await storageRef.getDownloadURL(); // used later to donwload the image
      await firebaseFirestore
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': _username,
        'email': _userEmail,
        'image_url': imageUrl,
      });
    } on FirebaseAuthException catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Firebase Signup failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _loginForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const UserImagePicker(),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Name'),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.trim().length < 4) {
                              return 'Name should be more than 4 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value!; // value can't be null
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email adress';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userEmail = value!; // value can't be null
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be 6 character at least';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userPassword = value!; // value can't be null
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Signup'),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('I already have an account'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
