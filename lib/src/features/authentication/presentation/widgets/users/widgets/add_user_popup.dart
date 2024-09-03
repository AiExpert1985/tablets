import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/authentication/presentation/controllers/picked_image_file_provider.dart';
import 'package:tablets/src/features/authentication/presentation/widgets/users/widgets/image_picker.dart';
import 'package:tablets/src/features/authentication/repository/auth_repository.dart';

class AddUserPopup extends ConsumerStatefulWidget {
  const AddUserPopup({super.key});

  @override
  ConsumerState<AddUserPopup> createState() => _AddUserPopupState();
}

class _AddUserPopupState extends ConsumerState<AddUserPopup> {
  final _loginForm = GlobalKey<FormState>(); // the key used to access the form

  String _userEmail = '';
  String _userPassword = '';
  String _username = '';

  void _submitForm() async {
    final isValid = _loginForm.currentState!.validate(); // runs validator
    final pickedImage = ref.read(pickedImageFileProvider);
    if (!isValid || pickedImage == null) {
      return;
    }
    _loginForm.currentState!.save(); // runs onSave inside form
    bool isSuccessful = await ref
        .watch(authRepositoryProvider)
        .createUserWithoutLogin(
            _userEmail, _userPassword, _username, pickedImage);
    if (isSuccessful) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
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
        height: MediaQuery.of(context).size.height * 0.5,
        child: Form(
          key: _loginForm,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const UserImagePicker(),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: S.of(context).name),
                  enableSuggestions: false,
                  validator: (value) {
                    if (value == null || value.trim().length < 4) {
                      return S.of(context).user_name_validation_error;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value!; // value can't be null
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
                      return S.of(context).user_email_validation_error;
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
                      return S.of(context).user_password_validation_error;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value!; // value can't be null
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
