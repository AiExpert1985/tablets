// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/features/categories/view/single_image_picker.dart';
import 'package:tablets/src/constants/gaps.dart' as gaps;
import 'package:tablets/src/features/categories/controller/category_controller.dart';
import 'package:tablets/src/features/categories/model/product_category.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class UpdateCategoryDialog extends ConsumerStatefulWidget {
  const UpdateCategoryDialog({super.key});

  @override
  ConsumerState<UpdateCategoryDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<UpdateCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    final categoryController = ref.read(categoryControllerProvider);
    final newCategory = categoryController.tempCategory;
    final oldCategory = ProductCategory(
      name: newCategory.name,
      imageUrl: newCategory.imageUrl,
    );
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(16.0),
      // title: Text(
      //   S.of(context).update_category,
      //   style: const TextStyle(fontSize: 18),
      // ),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.45,
          child: Form(
            key: categoryController.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleImagePicker(imageUrl: oldCategory.imageUrl),
                gaps.VerticalGap.formImageToFields,
                Expanded(
                  child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: oldCategory.name,
                      decoration: utils.formFieldDecoration(label: S.of(context).category),
                      validator: (value) => utils.FormValidation.validateStringField(
                          fieldValue: value,
                          errorMessage: S.of(context).input_validation_error_message_for_strings),
                      onSaved: (value) => newCategory.name = value!),
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
            TextButton(
              onPressed: () => categoryController.updateCategoryInDB(context, oldCategory),
              child: Column(
                children: [
                  const Icon(Icons.check, color: Colors.green),
                  gaps.VerticalGap.iconToText,
                  Text(S.of(context).save),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Column(
                children: [
                  const Icon(Icons.close),
                  gaps.VerticalGap.iconToText,
                  Text(S.of(context).cancel),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                bool? confiramtion =
                    await showDeleteConfirmationDialog(context: context, message: oldCategory.name);
                if (confiramtion != null) {
                  categoryController.deleteCategoryInDB(context, oldCategory);
                }
              },
              child: Column(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  gaps.VerticalGap.iconToText,
                  Text(S.of(context).delete),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
