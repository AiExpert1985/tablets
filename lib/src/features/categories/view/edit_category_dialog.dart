// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/various/delete_confirmation_dialog.dart';
import 'package:tablets/src/common_widgets/various/general_image_picker.dart';
import 'package:tablets/src/features/categories/controller/category_controller.dart';
import 'package:tablets/src/features/categories/model/product_category.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:tablets/src/constants/constants.dart' as constants;

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
              GeneralImagePicker(imageUrl: oldCategory.imageUrl),
              constants.FormGap.vertical,
              Expanded(
                child: TextFormField(
                    initialValue: oldCategory.name,
                    decoration: InputDecoration(
                      labelText: S.of(context).category,
                    ),
                    validator: (value) =>
                        utils.FormValidation.validateNameField(
                            fieldValue: value,
                            errorMessage: S
                                .of(context)
                                .input_validation_error_message_for_numbers),
                    onSaved: (value) => newCategory.name = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OverflowBar(
          alignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () =>
                  categoryController.updateCategoryInDB(context, oldCategory),
              child: Column(
                children: [
                  const Icon(Icons.save),
                  const Gap(6),
                  Text(S.of(context).save_changes),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                bool? confiramtion = await showDeleteConfirmationDialog(
                    context: context, itemName: oldCategory.name);
                if (confiramtion != null) {
                  categoryController.deleteCategoryInDB(context, oldCategory);
                }
              },
              child: Column(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const Gap(6),
                  Text(S.of(context).delete),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
