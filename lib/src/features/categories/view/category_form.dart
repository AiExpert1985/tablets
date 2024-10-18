import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/image_slider.dart';
import 'package:tablets/src/common/widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/features/categories/controllers/category_form_controller.dart';
import 'package:tablets/src/features/categories/controllers/category_form_data_provider.dart';
import 'package:tablets/src/features/categories/view/category_form_fields.dart';
import 'package:tablets/src/common/constants/gaps.dart' as gaps;
import 'package:tablets/src/common/constants/constants.dart' as constants;

class CategoryForm extends ConsumerWidget {
  const CategoryForm(this.isEditMode, {super.key});
  final bool isEditMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(categoryFormControllerProvider);
    final userFormData = ref.watch(categoryFormDataProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(imageUrls: userFormData['imageUrls']),
          gaps.VerticalGap.formImageToFields,
          const CategoryFormFields(editMode: true),
        ],
      ),
      buttons: [
        IconButton(
          onPressed: () => formController.saveCategory(context, isEditMode),
          icon: const ApproveIcon(),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const CancelIcon(),
        ),
        Visibility(
          visible: isEditMode,
          child: IconButton(
              onPressed: () async {
                bool? confiramtion = await showDeleteConfirmationDialog(
                    context: context, message: userFormData['name']);
                if (confiramtion != null) {
                  // ignore: use_build_context_synchronously
                  formController.deleteCategory(context);
                }
              },
              icon: const DeleteIcon()),
        )
      ],
      width: constants.categoryFormWidth,
      height: constants.categoryFormHeight,
    );
  }
}
