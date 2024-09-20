import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/features/authentication/data/auth_repository_old.dart';
import 'package:tablets/src/features/authentication/data/firestore_repository.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';

class AddUserPopup extends ConsumerStatefulWidget {
  const AddUserPopup({super.key});

  @override
  ConsumerState<AddUserPopup> createState() => _AddUserPopupState();
}

class _AddUserPopupState extends ConsumerState<AddUserPopup> {
  final _loginForm = GlobalKey<FormState>(); // the key used to access the form

  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  String _userPrivilage = '';

  void _submitForm() async {
    final isValid = _loginForm.currentState!.validate(); // runs validator
    final pickedImage = ref.read(pickedImageNotifierProvider).pickedImage;
    if (isValid && pickedImage != null) {
      _loginForm.currentState!.save(); // runs onSave inside form
      try {
        final uid = await ref.read(authRepositoryProvider).newUser(
              email: _userEmail,
              password: _userPassword,
            );
        if (uid != null) {
          final imageUrl = await ref
              .read(fileStorageProvider)
              .addFile(folder: 'users', fileName: uid, file: pickedImage);
          if (imageUrl != null) {
            ref.read(firestoreRepositoryProvider).addUser(
                uid: uid,
                userName: _userName,
                email: _userEmail,
                imageUrl: imageUrl,
                privilage: _userPrivilage);
          }
          // after uploading image, we must reset it
          ref.read(pickedImageNotifierProvider.notifier).reset();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        debugPrint('User Creation Error: ${e.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(16.0),
      // title: Text(S.of(context).add_new_user),
      content: Container(
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Form(
          key: _loginForm,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const GeneralImagePicker(),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: S.of(context).name),
                  enableSuggestions: false,
                  validator: (value) {
                    if (value == null || value.trim().length < 4) {
                      return S
                          .of(context)
                          .input_validation_error_message_for_user_name;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userName = value!; // value can't be null
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: S.of(context).email),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return S
                          .of(context)
                          .input_validation_error_message_for_email;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value!; // value can't be null
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: S.of(context).password),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return S
                          .of(context)
                          .input_validation_error_message_for_password;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value!; // value can't be null
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: S.of(context).user_privilage),
                  validator: (value) {
                    if (value == null) {
                      return S
                          .of(context)
                          .input_validation_error_message_for_user_privilage;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPrivilage = value!; // value can't be null
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        OverflowBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(S.of(context).save),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text(S.of(context).cancel),
            ),
          ],
        ),
      ],
    );
  }
}
