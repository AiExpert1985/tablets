// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/widgets/image_picker.dart';
import 'package:tablets/src/features/products/presentation/controller/products_controller.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  @override
  Widget build(BuildContext context) {
    final productController = ref.read(productsControllerProvider);
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(16.0),
      // title: Text(S.of(context).add_new_user),
      content: Container(
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Form(
          key: productController.formKey,
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
                      validator: (value) =>
                          utils.FormValidation.validateNumberField(
                              fieldValue: value,
                              errorMessage: S
                                  .of(context)
                                  .input_validation_error_message_for_numbers),
                      onSaved: (value) {
                        productController.productCode =
                            value!; // value can't be null
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  //! prodcut name
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: S.of(context).product_name),
                      validator: (value) =>
                          utils.FormValidation.validateNameField(
                              fieldValue: value,
                              errorMessage: S
                                  .of(context)
                                  .input_validation_error_message_for_names),
                      onSaved: (value) {
                        productController.productName =
                            value!; // value can't be null
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
              onPressed: () => productController.addProduct(context),
              child: Text(S.of(context).save),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text(S.of(context).cancel),
            ),
          ],
        )
      ],
    );
  }
}
