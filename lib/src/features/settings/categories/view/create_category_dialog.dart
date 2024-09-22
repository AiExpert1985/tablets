import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/features/settings/categories/controller/category_controller.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class CreateCategoryDialog extends ConsumerStatefulWidget {
  const CreateCategoryDialog({super.key});

  @override
  ConsumerState<CreateCategoryDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<CreateCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    final categoryController = ref.read(categoryControllerProvider);
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(
        S.of(context).add_new_category,
        style: const TextStyle(fontSize: 18),
      ),
      content: Container(
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Form(
          key: categoryController.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GeneralImagePicker(
                  imageUrl: categoryController.category.imageUrl),
              constants.FormFieldsSpacing.vertical,
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: S.of(context).category,
                  ),
                  validator: (value) => utils.FormValidation.validateNameField(
                      fieldValue: value,
                      errorMessage: S
                          .of(context)
                          .input_validation_error_message_for_numbers),
                  onSaved: (value) => categoryController.category.name =
                      value! // value is double (never null)
                  ,
                ),
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
              onPressed: () => categoryController.addCategoryToDB(context),
              child: Text(S.of(context).save),
            ),
            TextButton(
              onPressed: () {
                categoryController.cancelForm(context);
              },
              child: Text(S.of(context).cancel),
            ),
          ],
        )
      ],
    );
  }
}
