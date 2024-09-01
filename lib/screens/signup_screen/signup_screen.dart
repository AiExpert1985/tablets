import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/screens/signup_screen/widgets/image_picker.dart';

// global variable for firebase authentication
final _firebase = FirebaseAuth.instance;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenScreenState();
}

class _SignupScreenScreenState extends State<SignupScreen> {
  final _loginForm = GlobalKey<FormState>(); // the key used to access the form

  String _userEmail = '';
  String _userPassword = '';

  void _submitForm() async {
    final isValid = _loginForm.currentState!.validate(); // runs validator
    if (!isValid) {
      return;
    }
    _loginForm.currentState!.save(); // runs onSave inside form
    try {
      await _firebase.createUserWithEmailAndPassword(
        email: _userEmail,
        password: _userPassword,
      );
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
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              width: 200,
              child: Image.asset('assets/images/chat.png'),
            ),
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
