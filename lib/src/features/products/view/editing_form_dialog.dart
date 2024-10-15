import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_slider_controller.dart';
import 'package:tablets/src/common_widgets/form_frame.dart';
import 'package:tablets/src/common_widgets/custom_icons.dart';
import 'package:tablets/src/common_widgets/image_slider.dart';
import 'package:tablets/src/common_widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/constants/gaps.dart' as gaps;
import 'package:tablets/src/features/products/controllers/form_controllers.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/view/form_fields.dart';

class EditProductForm extends ConsumerWidget {
  const EditProductForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(productFormControllerProvider);
    final userFormData = ref.watch(productFormDataProvider);
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
          const ProductFormFields(
            editMode: true,
          ),
        ],
      ),
      buttons: [
        IconButton(
          onPressed: () => formController.updateProduct(
            context,
            Product.fromMap(userFormData),
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
                final product = Product.fromMap({...updatedData, 'imageUrls': updatedImageUrls});
                formController.deleteProduct(context, product);
              }
            },
            icon: const DeleteIcon())
      ],
      width: 600,
      height: 600,
    );
  }
}
