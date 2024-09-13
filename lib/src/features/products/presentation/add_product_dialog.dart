// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/widgets/image_picker.dart';
import 'package:tablets/src/features/products/data/product_repository_provider.dart';
import 'package:tablets/src/utils/form_validation.dart';
import 'package:tablets/src/utils/user_messages.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _newProductForm =
      GlobalKey<FormState>(); // the key used to access the form

  String _productName = '';
  String _productCode = '';

  void _submitForm() async {
    final isValid =
        _newProductForm.currentState!.validate(); // runs validation inside form
    if (!isValid) return;
    _newProductForm.currentState!.save(); // runs onSave inside form
    bool isSuccessful = await ref.read(productRepositoryProvider).addProduct(
          itemCode: _productCode,
          itemName: _productName,
        );
    if (!context.mounted) return;
    if (isSuccessful) {
      Navigator.of(context).pop();
      showSuccessSnackbar(
        context: context,
        message: S.of(context).success_adding_doc_to_db,
      );
    } else {
      showFailureSnackbar(
        context: context,
        message: S.of(context).error_adding_doc_to_db,
      );
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
          key: _newProductForm,
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
                      validator: (value) => validateNumberFields(
                          fieldValue: value, context: context),
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
                      validator: (value) => validateNameFields(
                          fieldValue: value, context: context),
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
