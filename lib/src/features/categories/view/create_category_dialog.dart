import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_styling_and_decorations/form_field_box_input_decoration.dart';
import 'package:tablets/src/common_widgets/various/general_image_picker.dart';
import 'package:tablets/src/features/categories/controller/category_controller.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:tablets/src/constants/constants.dart' as constants;

class CreateCategoryDialog extends ConsumerStatefulWidget {
  const CreateCategoryDialog({super.key});

  @override
  ConsumerState<CreateCategoryDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<CreateCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    final categoryController = ref.read(categoryControllerProvider);
    final currentCategory = categoryController.tempCategory;
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(16.0),
      // title: Text(
      //   S.of(context).add_new_category,
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
              GeneralImagePicker(imageUrl: currentCategory.imageUrl),
              constants.FormGap.imageToFields,
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration:
                      formFieldBoxInputDecoration(S.of(context).category),
                  validator: (value) => utils.FormValidation.validateNameField(
                      fieldValue: value,
                      errorMessage: S
                          .of(context)
                          .input_validation_error_message_for_numbers),
                  onSaved: (value) => currentCategory.name =
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
            TextButton(
              onPressed: () => categoryController.addCategoryToDB(context),
              child: Column(
                children: [
                  const Icon(Icons.check, color: Colors.green),
                  constants.IconToTextGap.vertical,
                  Text(S.of(context).save),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Column(
                children: [
                  const Icon(Icons.close),
                  constants.IconToTextGap.vertical,
                  Text(S.of(context).cancel),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
