import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/authentication/presentation/controllers/picked_image_file_provider.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/widgets/image_picker.dart';
import 'package:tablets/src/features/authentication/data/auth_repository_old.dart';
import 'package:tablets/src/features/authentication/data/firestore_repository.dart';
import 'package:tablets/src/features/authentication/data/storage_repository.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _loginForm = GlobalKey<FormState>(); // the key used to access the form

  String _productName = '';
  String _userPassword = '';
  String _productCode = '';
  String _userPrivilage = '';

  void _submitForm() async {
    final isValid = _loginForm.currentState!.validate(); // runs validator
    final pickedImage = ref.read(pickedImageFileProvider);
    if (isValid && pickedImage != null) {
      _loginForm.currentState!.save(); // runs onSave inside form
      try {
        final uid = await ref.read(authRepositoryProvider).newUser(
              email: _productName,
              password: _userPassword,
            );
        if (uid != null) {
          final imageUrl = await ref
              .read(storageRepositoryProvider)
              .addFile(uid: uid, file: pickedImage);
          if (imageUrl != null) {
            ref.read(firestoreRepositoryProvider).addUser(
                uid: uid,
                userName: _productCode,
                email: _productName,
                imageUrl: imageUrl,
                privilage: _userPrivilage);
          }
          // after uploading image, we must reset it
          ref.read(pickedImageFileProvider.notifier).update((state) => null);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const UserImagePicker(),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  //! product code
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: S.of(context).product_code),
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return S
                              .of(context)
                              .input_validation_error_message_for_numbers;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _productCode = value!; // value can't be null
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  //! prodcut name
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: S.of(context).product_name),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return S
                              .of(context)
                              .input_validation_error_message_for_names;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _productName = value!; // value can't be null
                      },
                    ),
                  ),
                ],
              ),
            ],
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
