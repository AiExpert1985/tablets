import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/image_slider_controller.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/image_slider.dart';
import 'package:tablets/src/common/widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/features/categories/controllers/category_form_controllers.dart';
import 'package:tablets/src/features/categories/controllers/category_form_fields_data_provider.dart';
import 'package:tablets/src/features/categories/model/category.dart';
import 'package:tablets/src/features/categories/view/category_form_fields.dart';
import 'package:tablets/src/features/products/controllers/product_form_controllers.dart';
import 'package:tablets/src/common/constants/gaps.dart' as gaps;
import 'package:tablets/src/common/constants/constants.dart' as constants;

class EditCategoryForm extends ConsumerWidget {
  const EditCategoryForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(categoryFormControllerProvider);
    final userFormData = ref.watch(categoryFormFieldsDataProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(
            userFormData['imageUrls'] ?? [constants.defaultImageUrl],
          ),
          gaps.VerticalGap.formImageToFields,
          const CategoryFormFields(
            editMode: true,
          ),
        ],
      ),
      buttons: [
        IconButton(
          onPressed: () => formController.updateCategory(
            context,
            ProductCategory.fromMap(userFormData),
          ),
          icon: const ApproveIcon(),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const CancelIcon(),
        ),
        IconButton(
            onPressed: () async {
              bool? confiramtion = await showDeleteConfirmationDialog(
                context: context,
                message: userFormData['name'],
              );
              if (confiramtion != null && context.mounted) {
                final updatedData = ref.read(productFormDataProvider);
                final updatedImageUrls = ref.read(imageSliderNotifierProvider);
                final category =
                    ProductCategory.fromMap({...updatedData, 'imageUrls': updatedImageUrls});
                formController.deleteCategory(context, category);
              }
            },
            icon: const DeleteIcon())
      ],
      width: constants.categoryFormWidth,
      height: constants.categoryFormHeight,
    );
  }
}
